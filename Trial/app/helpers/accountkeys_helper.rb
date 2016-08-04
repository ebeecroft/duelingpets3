module AccountkeysHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         usermode = Maintenancemode.find_by_id(2)
         mode_turned_on = (allmode.maintenance_on || usermode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to users_maintenance_path
               end
            else
               switch type
            end
         else
            switch type
         end
      end
   end

   private
      def switch(type)
         if(type == "index") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allAccountKeys = Accountkey.all
                  @accountkeys = allAccountKeys
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "new")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  newAccountKey = Accountkey.new
                  @accountkey = newAccountKey
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "create")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  newAccountKey = Accountkey.new(params[:accountkey])
                  newAccountKey.token = SecureRandom.urlsafe_base64
                  @accountkey = newAccountKey
                  if(@accountkey.save)
                     flash[:success] = "Accountkey created"
                     redirect_to accountkeys_path
                  else
                     render "new"
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
