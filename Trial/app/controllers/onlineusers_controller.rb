class OnlineusersController < ApplicationController
   include OnlineusersHelper

   def index
      mode "index"
   end
end
