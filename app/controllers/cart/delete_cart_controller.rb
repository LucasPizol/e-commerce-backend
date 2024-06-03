class Cart::DeleteCartController < ApplicationController
    def handle
        Cart.where(id: params[:id]).destroy_all

        render status: :no_content
    end
end
  