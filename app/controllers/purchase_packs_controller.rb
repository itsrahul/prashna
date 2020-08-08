class PurchasePacksController < ApplicationController

  def index
    @packs = Pack.listed
  end

end