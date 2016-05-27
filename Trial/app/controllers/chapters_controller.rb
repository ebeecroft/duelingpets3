class ChaptersController < ApplicationController
  include ChaptersHelper

  def index
     mode "index"
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

  def review
     mode "review"
  end

  def approve
     mode "approve"
  end

  def deny
     mode "deny"
  end

  def maintenance
  end
end
