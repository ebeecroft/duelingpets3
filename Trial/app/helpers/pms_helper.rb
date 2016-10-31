module PmsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         pmmode = Maintenancemode.find_by_id(22)
         mode_turned_on = (allmode.maintenance_on || pmmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to artworks_maintenance_path
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
      def getCount(pm)
         value = pm.preplies.count
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
                  allPms = Pm.order("created_on desc").page(params[:page]).per(10)
                  @pms = allPms
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "show") #Login only
            logged_in = current_user
            if(logged_in)
               cstatus = Onlineuser.find_by_user_id(logged_in.id)
               cstatus.last_visited = Time.now
               @cstatus = cstatus
               @cstatus.save
            end
            if(logged_in)
               pmFound = Pm.find_by_id(params[:id])
               if(pmFound)
                  sender = User.find_by_vname(pmFound.from_user.vname)
                  reciever = User.find_by_vname(pmFound.to_user.vname)
                  userMatch = (sender.id == logged_in.id) || (reciever.id == logged_in.id)
                  if(userMatch)
                     @user = reciever
                     @pm = pmFound
                     #Replies added here
                     pmReplies = @pm.preplies.all
                     @preplies = Kaminari.paginate_array(pmReplies).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end               
            else
               redirect_to root_path
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  newPm = userFound.pms.new
                  @pm = newPm
                  @user = userFound
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  newPm = userFound.pms.new(params[:pm])
                  newPm.from_user_id = logged_in.id
                  currentTime = Time.now
                  newPm.created_on = currentTime
                  @pm = newPm
                  if(@pm.save)
                     @user = userFound
                     flash[:success] = "PM #{@pm.title} was successfully created."
                     UserMailer.send_pm(@pm).deliver
                     redirect_to pms_outbox_path
                  else
                     render "new"
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "edit") #Login only
            logged_in = current_user
            if(logged_in)
               pmFound = Pm.find_by_id(params[:id])
               if(pmFound)
                  userFound = User.find_by_vname(pmFound.from_user.vname)
                  if(userFound)
                     userMatch = ((userFound.id == logged_in.id) || logged_in.admin)
                     if(userMatch)
                        @user = userFound
                        @pm = pmFound
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
         elsif(type == "update") #Login only
            logged_in = current_user
            if(logged_in)
               pmFound = Pm.find_by_id(params[:id])
               if(pmFound)
                  userFound = User.find_by_vname(pmFound.from_user.vname)
                  if(userFound)
                     userMatch = ((userFound.id == logged_in.id) || logged_in.admin)
                     if(userMatch)
                        @pm = pmFound
                        if(@pm.update_attributes(params[:pm]))
                           @user = userFound
                           flash[:success] = 'PM was successfully updated.'
                           redirect_to user_pm_path(@user, @pm)
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
         elsif(type == "destroy") #Login only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  pmFound = Pm.find_by_id(params[:id])
                  if(pmFound)
                     userFound = User.find_by_vname(pmFound.from_user.vname)
                     if(userFound)
                        userMatch = ((userFound.id == logged_in.id) || logged_in.admin)
                        if(userMatch)
                           @pm = pmFound
                           @pm.destroy
                           redirect_to pms_url
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
            else
               redirect_to root_path
            end
         elsif(type == "inbox") #Login only and same user
            logged_in = current_user
            if(logged_in)
               allPms = Pm.order("created_on desc")
               inbox = allPms.select{|pm| pm.user_id == logged_in.id || ((pm.from_user.id == logged_in.id) && pm.preplies.count > 0)}
               @pms = Kaminari.paginate_array(inbox).page(params[:page]).per(10)
            else
               redirect_to root_path
            end
         elsif(type == "outbox") #Login only and same user
            logged_in = current_user
            if(logged_in)
               allPms = Pm.order("created_on desc")
               outbox = allPms.select{|pm| pm.from_user_id == logged_in.id}
               @pms = Kaminari.paginate_array(outbox).page(params[:page]).per(10)
            else
               redirect_to root_path
            end
         end
      end
end
