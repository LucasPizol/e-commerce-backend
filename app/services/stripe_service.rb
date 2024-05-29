class StripeService 
    def create_checkout_session(stripe_id, price_id)
        if !price_id || !stripe_id
            raise BadRequestException.new('Price ID or Stripe ID is missing')
        end

        customer = retrieve_customer(stripe_id)

        if !customer
            raise BadRequestException.new('Customer not found')
        end

        session = Stripe::Checkout::Session.create( 
            customer: customer, 
            payment_method_types: ["card"],
            line_items: [{
                price: price_id,
                quantity: 1,
            }],
            mode: 'payment',
            success_url: "https://www.google.com/",
            cancel_url: "https://www.facebook.com/"
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

    private
    def retrieve_customer(stripe_id)
        customer = Stripe::Customer.retrieve(stripe_id)
        return customer
    end
end