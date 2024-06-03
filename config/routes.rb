Rails.application.routes.draw do
  post 'auth/login', to: 'auth/login#handle'
  post 'auth/register', to: 'auth/register#handle'
  get 'auth/verify', to: 'auth/verify#handle'
  
  post 'checkout', to: 'payment/create_checkout#handle'

  post 'products', to: 'product/create_product#handle'
  get 'products', to: 'product/load_products#handle'
  put "products/:id", to: "product/update_product#handle"

  post "carts", to: "cart/add_cart#handle"
  get "carts", to: "cart/load_carts#handle"
  put "carts/:id", to: "cart/add_cart#handle"
  delete "carts/clear", to: 'carts/clear#handle'

  put 'users', to: 'user/update_user#update'
  
  get "orders", to: "order/load_orders#handle"
  get 'orders/:id', to: 'order/retrieve_order#handle'

  get "up" => "rails/health#show", as: :rails_health_check
end
