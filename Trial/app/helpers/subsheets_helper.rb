module SubsheetsHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         subsheetmode = Maintenancemode.find_by_id(25)
         mode_turned_on = (allmode.maintenance_on || subsheetmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to subsheets_maintenance_path
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
               status = "Online"
            else
               status = "Offline"
            end
         end
         return status
      end

      def getTime(user)
         value = ""
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         #if(getStatus(onlineUserFound) != "Online")
            value = onlineUserFound.signed_out_at
         #end
         return value
      end

      def getType(user)
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
         if(type == "index") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allSubsheets = Subsheet.order("id").page(params[:page]).per(10)
                  @subsheets = allSubsheets
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "show") #Guest
            logged_in = current_user
            if(logged_in)
               cstatus = Onlineuser.find_by_user_id(logged_in.id)
               cstatus.last_visited = Time.now
               @cstatus = cstatus
               @cstatus.save
            end
            subsheetFound = Subsheet.find_by_id(params[:id])
            if(subsheetFound)
               mainsheetFound = Mainsheet.find_by_name(params[:mainsheet_id])
               if(mainsheetFound)
                  mainsheetMatch = (subsheetFound.mainsheet_id == mainsheetFound.id)
                  if(mainsheetMatch)
                     @subsheet = subsheetFound
                     @mainsheet = mainsheetFound
                     #Need to know about chapters here
                     subsheetSounds = @subsheet.sounds.all
                     #Need to only display reviewed chapters
                     reviewedSounds = subsheetSounds.select{|sound| sound.reviewed}
                     @sounds = Kaminari.paginate_array(reviewedSounds).page(params[:page]).per(15)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               mainsheetFound = Mainsheet.find_by_name(params[:mainsheet_id])
               if(mainsheetFound)
                  userMatch = (logged_in.id == mainsheetFound.user_id)
                  if(userMatch)
                     newSubsheet = mainsheetFound.subsheets.new
                     @mainsheet = mainsheetFound
                     @subsheet = newSubsheet
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               mainsheetFound = Mainsheet.find_by_name(params[:mainsheet_id])
               if(mainsheetFound)
                  userMatch = (logged_in.id == mainsheetFound.user_id)
                  if(userMatch)
                     newSubsheet = mainsheetFound.subsheets.new(params[:subsheet])
                     newSubsheet.user_id = logged_in.id
                     currentTime = Time.now
                     newSubsheet.created_on = currentTime
                     @subsheet = newSubsheet
                     if(@subsheet.save)
                        @mainsheet = mainsheetFound
                        flash[:success] = 'Subsheet was successfully created.'
                        redirect_to mainsheet_subsheet_path(@mainsheet, @subsheet)
                     else
                        render "new"
                     end
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "edit") #Login only and same user
            logged_in = current_user
            if(logged_in)
               subsheetFound = Subsheet.find_by_id(params[:id])
               if(subsheetFound)
                  userMatch = ((logged_in.id == subsheetFound.user_id) || logged_in.admin)
                  if(userMatch)
                     mainsheetFound = Mainsheet.find_by_name(params[:mainsheet_id])
                     if(mainsheetFound)
                        @mainsheet = mainsheetFound
                        @subsheet = subsheetFound
                     else
                        render "public/404"
                     end
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "update") #Login only and same user
            logged_in = current_user
            if(logged_in)
               subsheetFound = Subsheet.find_by_id(params[:id])
               if(subsheetFound)
                  userMatch = ((logged_in.id == subsheetFound.user_id) || logged_in.admin)
                  if(userMatch)
                     mainsheetFound = Mainsheet.find_by_name(params[:mainsheet_id])
                     if(mainsheetFound)
                        @subsheet = subsheetFound
                        if(@subsheet.update_attributes(params[:subsheet]))
                           @mainsheet = mainsheetFound
                           flash[:success] = 'Subsheet was successfully updated.'
                           redirect_to mainsheet_subsheet_path(@mainsheet, @subsheet)
                        else
                           render "edit"
                        end
                     else
                        render "public/404"
                     end
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "destroy") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  subsheetFound = Subsheet.find_by_id(params[:id]) #Need to move this below the admin section to protect it
                  if(subsheetFound)
                     mainsheetFound = Mainsheet.find_by_id(subsheetFound.mainsheet_id)
                     if(mainsheetFound)
                        @subsheet = subsheetFound
                        @mainsheet = mainsheetFound
                        @subsheet.destroy
                        redirect_to mainsheet_subsheets_path(@mainsheet)
                     else
                        render "public/404"
                     end
                  else
                     render "public/404"
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
