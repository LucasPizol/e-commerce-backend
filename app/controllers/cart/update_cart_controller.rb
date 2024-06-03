class Cart::UpdateCartController < ApplicationController
    def handle
        cart = Cart.find(params[:id])

        if cart.update(cart_params)
            render json: @cart
        else
            render json: @cart.errors, status: :unprocessable_entity
        end
    end
  
    private
    def cart_params
        params.require(:cart).permit(:stripe_product_id, :quantity)
    end
  end
  