class StartController < ApplicationController
   include StartHelper

   def home
      mode "home"
   end
end
