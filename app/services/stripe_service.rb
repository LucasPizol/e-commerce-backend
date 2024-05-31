class StripeService 
    def create_checkout_session(user, prices, success_url, cancel_url)
        if !user.stripe_id || !prices
            raise BadRequestException.new('Price ID or Stripe ID is missing')
        end

        customer = retrieve_customer(user.stripe_id)

        if !customer
            raise BadRequestException.new('Customer not found')
        end

        line_items = prices.map do |price|
            {
                price: price[:price_id],
                quantity: price[:quantity]
            }
        end

        session = Stripe::Checkout::Session.create( 
            customer: customer, 
            payment_method_types: ["card"],
            line_items: line_items,
            mode: 'payment',
            success_url: success_url,
            cancel_url: cancel_url,
            metadata: {
                user_id: user.id,
                line_items: line_items.to_s
            }
            )  
        return session
    end

    def create_customer(user)
        customer = Stripe::Customer.create(
            email: user.email,
            name: user.name,
            metadata: {
                user_id: user.id
            }   
        )
        return customer
    end

    def create_product(product)
        new_product = Stripe::Product.create({name: product[:name], description: product[:description], images: product[:images], metadata: product[:metadata]})

        price = create_price(product[:price].to_f, new_product.id)

        Stripe::Product.update(new_product.id, {default_price: price.id})
        
        return format_product(new_product, price)
    end

    def load_orders(user)
        orders = Stripe::Checkout::Session.list(customer: user.stripe_id)
        prices = list_price().data

        rejected_orders = orders[:data].reject { |order| order[:metadata][:line_items].nil? }.map do |order|
            string = order[:metadata][:line_items]
            string = string.gsub(/:(\w+)=>/, '"\1":')
            {
                id: order[:id],
                status: order[:payment_status],
                created_at: order[:created],
                payment_method_types: order[:payment_method_types],
                total_details: order[:total_details],
                amount_total: order[:amount_total].to_f / 100,
                line_items: JSON.parse(string)
            }
        end

        prices_id = rejected_orders.map do |order|
            order[:line_items].map  do |item| 
                {id: item["price"], quantity: item["quantity"]}
            end
        end

        products_ids = prices_id.flatten.map do |item|
            id = prices.find { |price| price[:id] == item[:id] }[:product]

            {id: id, quantity: item[:quantity]}
        end 

        products = list_products_by_ids(products_ids.map{|item| item[:id]}, prices)  
        
        return rejected_orders.map do |order|
            products = order[:line_items].map do |item|
                product = products.find { |product| product[:price][:id] == item["price"] }
                quantity = products_ids.find{ |data| data[:id] == product[:id] }[:quantity]

                {**product, quantity: quantity}
            end
            {
                **order,
                line_items: nil,
                products: products
            }
        end
    end

    def list_products(prices)
        products = Stripe::Product.list(active: true)

        products[:data].map do |product|
            price = prices[:data].find { |price| price[:product] == product[:id] }
            format_product(product, price)
        end
    end

    def list_products_by_ids(ids, prices)
        products = Stripe::Product.list(ids: ids)

        products[:data].map do |product|
            price = prices.find { |price| price[:product] == product[:id] }
            format_product(product, price)
        end
    end

    def format_product(product, price)
        {
            id: product[:id],
            name: product[:name],
            description: product[:description],
            price: {
                id: price[:id],
                value: price[:unit_amount].to_f / 100
            },
            images: product[:images],
            metadata: product[:metadata]
        }
    end

    def update_price(id, data)  
        Stripe::Price.update(
        id,
        {**data},
        )
     end

    def list_price()
       Stripe::Price.list()
    end

    private
    def retrieve_customer(stripe_id)
        Stripe::Customer.retrieve(stripe_id)
    end

    private
    def create_price(price, product_id)  
        Stripe::Price.create({
            currency: 'brl',
            unit_amount: (price * 100).to_i,
            product: product_id,
        })
    end
end