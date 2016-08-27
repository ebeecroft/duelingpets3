class StartController < ApplicationController
   include StartHelper

   def home
      mode "home"
   end

   def sitemap
      mode "sitemap"
   end
end
