module SoundsHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         soundmode = Maintenancemode.find_by_id(26)
         mode_turned_on = (allmode.maintenance_on || soundmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to sounds_maintenance_path
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

      def soundApproved
         soundFound = Sound.find_by_id(params[:sound_id])
         if(soundFound)
            soundFound.reviewed = true
            pouch = Pouch.find_by_user_id(soundFound.user_id)
            pointsForSound = 10
            pouch.amount += pointsForSound
            @pouch = pouch
            @pouch.save
            @sound = soundFound
            @sound.save
            SoundMailer.sound_approved(@sound, pointsForSound).deliver
            redirect_to sounds_review_path
         else
            render "public/404"
         end
      end

      def soundDenied
         soundFound = Sound.find_by_id(params[:sound_id])
         if(soundFound)
            #Retrieve the user who owns this pet first
            #userEmail = petFound.user.email
            #Send mail to user with link to edit the pet they sent
            @sound = soundFound
            SoundMailer.sound_denied(@sound).deliver
            redirect_to sounds_review_path
         else
            render "public/404"
         end
      end

      def createSound(subsheetFound)
         newSound = subsheetFound.sounds.new
         @subsheet = subsheetFound
         @sound = newSound
      end

      def saveSound(subsheetFound, logged_in)
         newSound = subsheetFound.sounds.new(params[:sound])
         newSound.user_id = logged_in.id
         currentTime = Time.now
         newSound.created_on = currentTime
         @subsheet = subsheetFound
         @sound = newSound
         if(@sound.save)
            SoundMailer.review_sound(@sound).deliver
            flash[:success] = "#{@sound.name} is currently being reviewed please check back later."
            redirect_to subsheet_sound_path(@subsheet, @sound)
         else
            render "new"
         end
      end

      def switch(type)
         if(type == "index") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allSounds = Sound.order("id").page(params[:page]).per(10)
                  @sounds = allSounds
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
            soundFound = Sound.find_by_id(params[:id])
            if(soundFound)
               subsheetFound = Subsheet.find_by_id(params[:subsheet_id])
               if(subsheetFound)
                  if(soundFound.reviewed)
                     @subsheet = subsheetFound
                     @sound = soundFound
                  else
                     logged_in = current_user
                     if(logged_in)
                        userMatch = ((logged_in.id == soundFound.user_id) || logged_in.admin)
                        if(userMatch)
                           @subsheet = subsheetFound
                           @sound = soundFound
                        else
                           redirect_to root_path
                        end
                     else
                        redirect_to root_path
                     end
                  end
               else
                  render "public/404"
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               subsheetFound = Subsheet.find_by_id(params[:subsheet_id])
               if(subsheetFound)
                  if(subsheetFound.collab_mode)
                     createSound(subsheetFound)
                  else
                     userMatch = (logged_in.id == subsheetFound.user_id)
                     if(userMatch)
                        createSound(subsheetFound)
                     else
                        redirect_to root_path
                     end
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
               subsheetFound = Subsheet.find_by_id(params[:subsheet_id])
               if(subsheetFound)
                  if(subsheetFound.collab_mode)
                     saveSound(subsheetFound, logged_in)
                  else
                     userMatch = (logged_in.id == subsheetFound.user_id)
                     if(userMatch)
                        saveSound(subsheetFound, logged_in)
                     else
                        redirect_to root_path
                     end
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
               soundFound = Sound.find_by_id(params[:id])
               if(soundFound)
                  userMatch = (logged_in.id == soundFound.user_id)
                  if(userMatch)
                     subsheetFound = Subsheet.find_by_id(soundFound.subsheet_id)
                     if(subsheetFound)
                        @subsheet = subsheetFound
                        @sound = soundFound
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
               soundFound = Sound.find_by_id(params[:id])
               if(soundFound)
                  userMatch = (logged_in.id == soundFound.user_id)
                  if(userMatch)
                     subsheetFound = Subsheet.find_by_id(soundFound.subsheet_id)
                     if(subsheetFound)
                        @sound = soundFound
                        if(@sound.update_attributes(params[:sound]))
                           @subsheet = subsheetFound
                           flash[:success] = 'Sound was successfully updated.'
                           redirect_to subsheet_sound_path(@subsheet, @sound)
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
               soundFound = Sound.find_by_id(params[:id]) #Need to move this below the admin section to protect it
               if(soundFound)
                  if(logged_in.admin)
                     subsheetFound = Subsheet.find_by_id(soundFound.subsheet_id)
                     if(subsheetFound)
                        @sound = soundFound
                        @subsheet = subsheetFound
                        @sound.destroy
                        redirect_to mainsheet_subsheet_path(@subsheet.mainsheet, @subsheet)
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
         elsif(type == "review")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allSounds = Sound.all
                  soundsToReview = allSounds.select{|sound| !sound.reviewed}
                  @sounds = Kaminari.paginate_array(soundsToReview).page(params[:page]).per(10)
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     allSounds = Sound.all
                     soundsToReview = allSounds.select{|sound| !sound.reviewed}
                     @sounds = Kaminari.paginate_array(soundsToReview).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "approve")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  soundApproved
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     soundApproved
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "deny")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  soundDenied
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     soundDenied
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         end
      end
end
