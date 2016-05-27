class PetownersController < ApplicationController
  include PetownersHelper

  def index
     mode "index"
  end

  def show
     mode "show"
  end

  def new
     mode "new"
  end

  def edit
     mode "edit"
  end

  def create
     mode "create"
  end

  def update
     mode "update"
  end

  def destroy
     mode "destroy"
  end

  def attack
     mode "attack"
  end

  def defense
     mode "defense"
  end

  def speed
     mode "speed"
  end

  def health
     mode "health"
  end

  def maintenance
  end
end
