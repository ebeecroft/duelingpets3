class EquipsController < ApplicationController
  include EquipsHelper

  def index
     mode "index"
  end

  def create
     mode "create"
  end

  def destroy
     mode "destroy"
  end

  def maintenance
  end
end
