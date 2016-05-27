class PouchesController < ApplicationController

   def index
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         if(current_user && current_user.admin)
            @pouches = Pouch.order("id").page(params[:page]).per(10)
         else
            redirect_to root_path
         end
      end
   end
end
