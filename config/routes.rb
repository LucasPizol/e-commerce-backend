Rails.application.routes.draw do
  post 'auth/login', to: 'auth#login'
  post 'auth/register', to: 'auth#register'
  get 'auth/verify', to: 'auth#verify'
  
  post 'checkout', to: 'payment/create_checkout#handle'

  post 'products', to: 'product#add'
  get 'products', to: 'product#index'
  put "products/:id", to: "product#update"

  post "carts", to: "cart#add"
  get "carts", to: "cart#index"
  put "carts/:id", to: "cart#update"
  delete "carts/:id", to: "cart#delete"
  delete "carts/clear", to: 'cart#clear'

  put 'users', to: 'user/update_user#handle'
  
  get "orders", to: "order/load_orders#handle"
  get 'orders/:id', to: 'order/retrieve_order#handle'

  get "up" => "rails/health#show", as: :rails_health_check
end
