module SessionsHelper
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
      def getType(user) #Only create action should do something different for bad users
         if(user.admin)
            value = "$"
         else
            typeFound = Usertype.find_by_user_id(user.id)
            if(typeFound)
               type = typeFound.privilege
               if(type == "Reviewer")
                  value = "^"
               elsif(type == "Banned")
                  value = "!"
               else
                  value = "~"
               end
            else
               value = "~"
            end
         end
         return value
      end

      def switch(type)
         if(type == "create")
            #Determines if the session is actually valid
            userFound = User.find_by_login_id(params[:session][:login_id].downcase)
            if(userFound)
               passwordValid = userFound.authenticate(params[:session][:password])
               if(passwordValid)
                  #Determine if Maintenance is turned on
                  allmode = Maintenancemode.find_by_id(1)
                  mode_turned_on = allmode.maintenance_on
                  if(mode_turned_on)
                     if(userFound.admin)
                        sign_in userFound
                        redirect_to userFound
                     else
                        flash.now[:error] = 'Only the admin is allowed to login at this time'
                        render 'new'
                     end
                  else
                     typeFound = Usertype.find_by_user_id(userFound.id)
                     if(typeFound.privilege == "Banned" && !userFound.admin)
                        flash.now[:error] = 'Your account has been banned'
                        render 'new'
                     elsif(typeFound.privilege == "Review" && !userFound.admin)
                        flash.now[:error] = 'Your account has not been activated yet'
                        render 'new'
                     else
                        sign_in userFound
                        redirect_to userFound
                     end
                  end
               else
                  flash.now[:error] = 'Invalid vname/password combination'
                  render 'new'
               end
            else
               flash.now[:error] = 'Invalid vname/password combination'
               render 'new'
            end
         elsif(type == "destroy")
            #Determines if user session still exists
            logged_in = current_user
            if(logged_in)
               sign_out
               redirect_to root_path
            end
         end
      end
end
