class AccountkeysController < ApplicationController
   include AccountkeysHelper

   def index
      mode "index"
   end
end
