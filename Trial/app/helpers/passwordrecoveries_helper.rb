module PasswordrecoveriesHelper
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
               userFoundByVname = User.find_by_vname(params[:session][:vname].downcase)
               if(userFoundByVname)
                  userMatch = (userFoundByVname.id == userFoundByLogin.id)
                  if(userMatch)
                     token = SecureRandom.urlsafe_base64
                     userFoundByVname.password = token
                     userFoundByVname.password_confirmation = token
                     @user = userFoundByVname
                     @user.save
                     @passwordtoken = token
                     UserMailer.recover_account(@user, @passwordtoken).deliver
                     flash[:success] = "Your password was succesfully sent"
                  else
                     flash[:success] = "Your password was succesfully sent"
                  end
               else
                  flash[:success] = "Your password was succesfully sent"
               end
            else
               flash[:success] = "Your password was succesfully sent"
            end
            redirect_to root_path
         end
      end
end
