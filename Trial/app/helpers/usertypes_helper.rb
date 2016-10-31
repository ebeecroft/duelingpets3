module UsertypesHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         switch type
      end
   end

   private
      def switch(type)
         if(type == "index") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  @usertypes = Usertype.order("id").page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "edit")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  @usertype = Usertype.find(params[:id])
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "update")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  @usertype = Usertype.find(params[:id])
                  if(@usertype.update_attributes(params[:usertype]))
                     flash[:success] = "Usertype was successfully updated."
                     redirect_to usertypes_path
                  else
                     render "edit"
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
