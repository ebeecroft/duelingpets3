class UsertypesController < ApplicationController
   include UsertypesHelper

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
end
