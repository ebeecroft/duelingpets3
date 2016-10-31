module OnlineusersHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         mode_turned_on = allmode.maintenance_on
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
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
      def getStatus(user)
         status = "Offline"
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(onlineUserFound.signed_in_at)
            if(!onlineUserFound.signed_out_at)
               if(onlineUserFound.last_visited == nil)
                  status = "Online"
               else
                  if((currentTime - onlineUserFound.last_visited) > 30.minutes)
                     status = "Inactive"
                  else
                     status = "Online"
                  end
               end
            else
               status = "Offline"
            end
         end
         return status
      end

      def getTime(user, status)
         value = ""
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(status == "Inactive")
            value = onlineUserFound.last_visited
         else
            value = onlineUserFound.signed_out_at
         end
         return value
      end

      def switch(type)
         if(type == "index") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  @onlineusers = Onlineuser.order("id").page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
