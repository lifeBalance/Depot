class StoreController < ApplicationController
  def index
    @products = Product.order(:title) # Products ordered by their 'title' field.
  end
end
