class AccountkeysController < ApplicationController
   include AccountkeysHelper

   def index
      mode "index"
   end

   def new
      mode "new"
   end

   def create
      mode "create"
   end
end
