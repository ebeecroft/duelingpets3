class UsertypesController < ApplicationController
   include UsertypesHelper

   def index
      mode "index"
   end

   def edit
      mode "edit"
   end

   def update
      mode "update"
   end
end
