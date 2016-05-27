class PasswordrecoveriesController < ApplicationController
   include PasswordrecoveriesHelper

   def create
      mode "create"
   end
end
