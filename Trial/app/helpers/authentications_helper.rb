module AuthenticationsHelper
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
         if(type == "create") #Guest
            userFoundByLogin = User.find_by_login_id(params[:session][:login_id].downcase)
            if(userFoundByLogin)
               accountFound = Accountkey.find_by_token(params[:session][:token])
               if(accountFound)
                  userMatch = (accountFound.user_id == userFoundByLogin.id)
                  if(userMatch)
                     if(accountFound.activated)
                        flash[:info] = "This account has already been activated"
                     else
                        accountFound.activated = true;
                        @accountkey = accountFound
                        @accountkey.save
                        userType = Usertype.find_by_user_id(userFoundByLogin.id)
                        userType.privilege = "User"
                        @usertype = userType
                        @usertype.save
                        flash[:success] = "Your account has now been activated"
                        redirect_to signin_path
                     end
                  else
                     flash[:error] = "Invalid login id or token!"
                     redirect_to verify_path
                  end
               else
                  flash[:error] = "Invalid login id or token!"
                  redirect_to verify_path
               end
            else
               flash[:error] = "Invalid login id or token!"
               redirect_to verify_path
            end
         end
      end
end
