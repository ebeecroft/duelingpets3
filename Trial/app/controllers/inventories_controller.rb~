class InventoriesController < ApplicationController
  include InventoriesHelper

  def index #Must be logged in, however there is two different index's.
     mode "index"
  end

  def create #Logged in only
     mode "create"
  end

  def destroy #Admin only
     mode "destroy"
  end

  def maintenance
  end
end
