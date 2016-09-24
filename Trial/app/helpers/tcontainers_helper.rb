module TcontainersHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         tcontainermode = Maintenancemode.find_by_id(10)
         mode_turned_on = (allmode.maintenance_on || tcontainermode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to tcontainers_maintenance_path
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

      def switch(type)
         if(type == "index") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allTcontainers = Tcontainer.order("id").page(params[:page]).per(10)
                  @tcontainers = allTcontainers
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "show") #Guest
            tcontainerFound = Tcontainer.find_by_id(params[:id])
            if(tcontainerFound)
               forumFound = Forum.find_by_id(tcontainerFound.forum_id)
               if(forumFound)
                  @forum = forumFound
                  @tcontainer = tcontainerFound
                  tcontainerMaintopics = @tcontainer.maintopics.all
                  @maintopics = Kaminari.paginate_array(tcontainerMaintopics).page(params[:page]).per(10)
               else
                  render "public/404"
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               forumFound = Forum.find_by_name(params[:forum_id])
               if(forumFound)
                  newTcontainer = forumFound.tcontainers.new
                  @forum = forumFound
                  @tcontainer = newTcontainer
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               forumFound = Forum.find_by_name(params[:forum_id])
               if(forumFound)
                  newTcontainer = forumFound.tcontainers.new(params[:tcontainer])
                  newTcontainer.user_id = logged_in.id
                  currentTime = Time.now
                  newTcontainer.created_on = currentTime
                  @tcontainer = newTcontainer
                  if(@tcontainer.save)
                     @forum = forumFound
                     flash[:success] = 'Tcontainer was successfully created.'
                     redirect_to forum_tcontainer_path(@forum, @tcontainer)
                  else
                     render "new"
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
               tcontainerFound = Tcontainer.find_by_id(params[:id])
               if(tcontainerFound)
                  userMatch = ((tcontainerFound.user_id == logged_in.id) || logged_in.admin)
                  if(userMatch)
                     forumFound = Forum.find_by_id(tcontainerFound.forum_id)
                     if(forumFound)
                        @forum = forumFound
                        @tcontainer = tcontainerFound
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
               tcontainerFound = Tcontainer.find_by_id(params[:id])
               if(tcontainerFound)
                  userMatch = ((tcontainerFound.user_id == logged_in.id) || logged_in.admin)
                  if(userMatch)
                     forumFound = Forum.find_by_id(tcontainerFound.forum_id)
                     if(forumFound)
                        @tcontainer = tcontainerFound
                        if(@tcontainer.update_attributes(params[:tcontainer]))
                           @forum = forumFound
                           flash[:success] = 'Tcontainer was successfully updated.'
                           redirect_to forum_tcontainer_path(@forum, @tcontainer)
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
         elsif(type == "destroy") #Admin only
            logged_in = current_user
            if(logged_in)
               tcontainerFound = Tcontainer.find_by_id(params[:id])
               if(tcontainerFound)
                  if(logged_in.admin)
                     forumFound = Forum.find_by_id(tcontainerFound.forum_id)
                     if(forumFound)
                        @tcontainer = tcontainerFound
                        @forum = forumFound
                        @tcontainer.destroy
                        redirect_to user_forum_path(@forum.user, @forum)
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
         end
      end
end
