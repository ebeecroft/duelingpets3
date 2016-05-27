class SessionsController < ApplicationController
   include SessionsHelper

   def create
      mode "create"
   end

   def destroy
      mode "destroy"
   end
end
