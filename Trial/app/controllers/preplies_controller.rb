class PrepliesController < ApplicationController
   include PrepliesHelper

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
end
