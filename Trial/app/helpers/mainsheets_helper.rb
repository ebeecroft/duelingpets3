module MainsheetsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         mainsheetmode = Maintenancemode.find_by_id(24)
         mode_turned_on = (allmode.maintenance_on || mainsheetmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to mainsheets_maintenance_path
               end
            else
               switch type
            end
         else
            switch type
         end
      end
   end

   def getSound(subsheetFound)
      subsheetSounds = subsheetFound.sounds.all
      reviewedSounds = subsheetSounds
      if(subsheetSounds.count > 0)
         reviewedSounds = subsheetSounds.select{|sound| sound.reviewed}
      end
      recentSound = "No audio available"
      if(reviewedSounds.count > 0)
         recentSound = reviewedSounds.last.ogg_url.to_s
      end
      return recentSound
   end

   def getOptional
      @optional
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

      def setOptional(optional)
         @optional = optional
      end

      def switch(type)
         if(type == "index") #Guest
            optional = params[:user_id]
            setOptional optional
            if(getOptional)
               userFound = User.find_by_vname(optional)
               if(userFound)
                  userMainSheets = userFound.mainsheets.all
                  @mainsheets = Kaminari.paginate_array(userMainSheets).page(params[:page]).per(10)
                  @user = userFound
               else
                  render "public/404"
               end
            else
               allMainSheets = Mainsheet.order("id").page(params[:page]).per(10)
               @mainsheets = allMainSheets
            end
         elsif(type == "show") #Guest
            logged_in = current_user
            if(logged_in)
               cstatus = Onlineuser.find_by_user_id(logged_in.id)
               cstatus.last_visited = Time.now
               @cstatus = cstatus
               @cstatus.save
            end
            mainsheetFound = Mainsheet.find_by_name(params[:id]) #remember to come back and repair this
            if(mainsheetFound)
               userFound = User.find_by_vname(params[:user_id]) #cant use user id here
               if(userFound)
                  userMatch = (userFound.id == mainsheetFound.user_id)
                  if(userMatch)
                     @mainsheet = mainsheetFound
                     mainsheetSubsheets = @mainsheet.subsheets.all
                     @subsheets = Kaminari.paginate_array(mainsheetSubsheets).page(params[:page]).per(10)
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
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     newMainSheet = Mainsheet.new
                     @mainsheet = newMainSheet
                     @user = userFound
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
               userFound = User.find_by_vname(params[:user_id]) #This parameter is necessary
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     newMainSheet = Mainsheet.new(params[:mainsheet])
                     currentTime = Time.now
                     newMainSheet.created_on = currentTime
                     newMainSheet.user_id = userFound.id
                     @mainsheet = newMainSheet
                     @user = userFound
                     if(@mainsheet.save)
                        flash[:success] = 'Mainsheet was successfully created.'
                        redirect_to user_mainsheet_path(@user, @mainsheet)
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
               mainsheetFound = Mainsheet.find_by_name(params[:id])
               if(mainsheetFound)
                  userFound = User.find_by_vname(logged_in.vname)
                  if(userFound)
                     userMatch = ((userFound.id == mainsheetFound.user_id) || logged_in.admin) #Reminder to change sbooks edit in helper
                     if(userMatch)
                        @user = userFound
                        @mainsheet = mainsheetFound
                     else
                        redirect_to root_path
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
               mainsheetFound = Mainsheet.find_by_name(params[:id])
               if(mainsheetFound)
                  userFound = User.find_by_vname(params[:user_id])
                  if(userFound)
                     userMatch = ((userFound.id == mainsheetFound.user_id) || logged_in.admin)
                     if(userMatch)
                        @mainsheet = mainsheetFound
                        @user = userFound
                        if(@mainsheet.update_attributes(params[:mainsheet]))
                           flash[:success] = 'Mainsheet was successfully updated.'
                           redirect_to user_mainsheet_path(@user, @mainsheet)
                        else
                           render "edit"
                        end
                     else
                        redirect_to root_path
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
                  mainsheetFound = Mainsheet.find_by_name(params[:id])
                  if(mainsheetFound)
                     @mainsheet = mainsheetFound
                     @mainsheet.destroy
                     redirect_to mainsheets_list_url
                  else
                     render "public/404"
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "list") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allMainSheets = Mainsheet.order("id").page(params[:page]).per(10)
                  @mainsheets = allMainSheets
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
