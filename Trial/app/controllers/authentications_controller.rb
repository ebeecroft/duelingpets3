class AuthenticationsController < ApplicationController
   include AuthenticationsHelper

   def create
      mode "create"
   end
end
