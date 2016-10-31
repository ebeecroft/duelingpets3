module ForumsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         forummode = Maintenancemode.find_by_id(9)
         mode_turned_on = (allmode.maintenance_on || forummode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to forums_maintenance_path
               end
            else
               switch type
            end
         else
            switch type
         end
      end
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
         if(type == "index")
            optional = params[:user_id]
            setOptional optional
            if(getOptional)
               userFound = User.find_by_vname(optional)
               if(userFound)
                  userForums = userFound.forums.all
                  @forums = Kaminari.paginate_array(userForums).page(params[:page]).per(10)
                  @user = userFound
               else
                  render "public/404"
               end
            else
               allForums = Forum.order("id").page(params[:page]).per(10)
               @forums = allForums
            end
         elsif(type == "show")
            logged_in = current_user
            if(logged_in)
               cstatus = Onlineuser.find_by_user_id(logged_in.id)
               cstatus.last_visited = Time.now
               @cstatus = cstatus
               @cstatus.save
            end
            userFound = User.find_by_vname(params[:user_id])
            if(userFound)
               forumFound = Forum.find_by_name(params[:id])
               if(forumFound)
                  userMatch = (userFound.id == forumFound.user_id)
                  if(userMatch)
                     @forum = forumFound
                     forumTcontainers = @forum.tcontainers.all
                     @tcontainers = Kaminari.paginate_array(forumTcontainers).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "new")
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in == userFound)
                  if(userMatch)
                     newForum = logged_in.forums.new
                     @forum = newForum
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
         elsif(type == "create")
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in == userFound)
                  if(userMatch)
                     #Builds the new forum for the logged in user
                     newForum = logged_in.forums.new(params[:forum])
                     currentTime = Time.now
                     newForum.created_on = currentTime
                     @forum = newForum
                     if(@forum.save)
                        @user = userFound
                        flash[:success] = 'Forum was successfully created.'
                        redirect_to user_forum_path(@user, @forum)
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
         elsif(type == "edit")
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  forumFound = Forum.find_by_name(params[:id])
                  if(forumFound)
                     userMatch = (userFound.id == forumFound.user_id)
                     if(userMatch)
                        @user = userFound
                        @forum = forumFound
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
         elsif(type == "update")
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  forumFound = Forum.find_by_name(params[:id])
                  if(forumFound)
                     userMatch = (userFound.id == forumFound.user_id)
                     if(userMatch)
                        @forum = forumFound
                        if(@forum.update_attributes(params[:forum]))
                           @user = userFound
                           flash[:success] = 'Forum was successfully updated.'
                           redirect_to user_forum_path(@user, @forum)
                        else
                           render "edit"
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
         elsif(type == "destroy")
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  if(logged_in.admin)
                     forumFound = Forum.find_by_name(params[:id])
                     if(forumFound)
                        userMatch = (userFound.id == forumFound.user_id)
                        if(userMatch)
                           @forum = forumFound
                           @forum.destroy
                           redirect_to forums_url
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
            else
               redirect_to root_path
            end
         elsif(type == "list")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allForums = Forum.order("id").page(params[:page]).per(10)
                  @forums = allForums
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
