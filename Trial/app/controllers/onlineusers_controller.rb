class OnlineusersController < ApplicationController
   include OnlineusersHelper

   def index
      mode "index"
   end

   def new #Temporary
      mode "new"
   end

   def create #Temporary
      mode "create"
   end
end
