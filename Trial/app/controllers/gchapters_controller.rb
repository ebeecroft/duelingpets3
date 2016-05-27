class GchaptersController < ApplicationController

   def index
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         if(current_user && current_user.admin)
            allGchapters = Gchapter.order("id").page(params[:page]).per(10)
            @gchapters = allGchapters
         else
            redirect_to root_path
         end
      end
   end
end
