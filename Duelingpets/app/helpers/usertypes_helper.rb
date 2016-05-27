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
                  @usertypes = Usertype.all
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "new") #Will be removed when all users are updated
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  @usertype = Usertype.new
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Will be removed when all users are updated
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  newUserType = Usertype.new(params[:usertype])
                  #newUserType.user_id = logged_in.id
                  newUserType.privilege = "User"
                  @usertype = newUserType
                  if(@usertype.save)
                     flash[:success] = "Usertype was successfully created."
                     redirect_to usertypes_path
                  else
                     render "new"
                  end
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
