class ForumsController < ApplicationController
  include ForumsHelper

  def index #Guest access
     mode "index"
  end

  def show #Guest access
     mode "show"
  end

  def new #Logged in only
     mode "new"
  end

  def edit #Logged in only
     mode "edit"
  end

  def create #Logged in only
     mode "create"
  end

  def update #Logged in only
     mode "update"
  end

  def destroy #Admin only
     mode "destroy"
  end

  def list #Admin only
     mode "list"
  end

  def maintenance
  end
end
