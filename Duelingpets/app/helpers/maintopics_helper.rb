module MaintopicsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         maintopicmode = Maintenancemode.find_by_id(11)
         mode_turned_on = (allmode.maintenance_on || maintopicmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to maintopics_maintenance_path
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
                  allMaintopics = Maintopic.order("id").page(params[:page]).per(10)
                  @maintopics = allMaintopics
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "show") #Guest
            maintopicFound = Maintopic.find_by_id(params[:id])
            if(maintopicFound)
               tcontainerFound = Tcontainer.find_by_id(maintopicFound.tcontainer_id)
               if(tcontainerFound)
                  @tcontainer = tcontainerFound
                  @maintopic = maintopicFound
                  maintopicSubtopics = @maintopic.subtopics.all
                  @subtopics = Kaminari.paginate_array(maintopicSubtopics).page(params[:page]).per(10)
               else
                  render "public/404"
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               tcontainerFound = Tcontainer.find_by_id(params[:tcontainer_id])
               if(tcontainerFound)
                  newMaintopic = tcontainerFound.maintopics.new
                  @tcontainer = tcontainerFound
                  @maintopic = newMaintopic
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               tcontainerFound = Tcontainer.find_by_id(params[:tcontainer_id])
               if(tcontainerFound)
                  newMaintopic = tcontainerFound.maintopics.new(params[:maintopic])
                  newMaintopic.user_id = logged_in.id
                  currentTime = Time.now
                  newMaintopic.created_on = currentTime
                  @maintopic = newMaintopic
                  if(@maintopic.save)
                     @tcontainer = tcontainerFound
                     flash[:success] = 'Maintopic was successfully created.'
                     redirect_to tcontainer_maintopic_path(@tcontainer, @maintopic)
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
               maintopicFound = Maintopic.find_by_id(params[:id])
               if(maintopicFound)
                  userMatch = (logged_in.id == maintopicFound.user_id)
                  if(userMatch)
                     tcontainerFound = Tcontainer.find_by_id(maintopicFound.tcontainer_id)
                     if(tcontainerFound)
                        @tcontainer = tcontainerFound
                        @maintopic = maintopicFound
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
               maintopicFound = Maintopic.find_by_id(params[:id])
               if(maintopicFound)
                  userMatch = (logged_in.id == maintopicFound.user_id)
                  if(userMatch)
                     tcontainerFound = Tcontainer.find_by_id(maintopicFound.tcontainer_id)
                     if(tcontainerFound)
                        @maintopic = maintopicFound
                        if(@maintopic.update_attributes(params[:maintopic]))
                           @tcontainer = tcontainerFound
                           flash[:success] = 'Maintopic was successfully updated.'
                           redirect_to tcontainer_maintopic_path(@tcontainer, @maintopic)
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
               maintopicFound = Maintopic.find_by_id(params[:id])
               if(maintopicFound)
                  if(logged_in.admin)
                     tcontainerFound = Tcontainer.find_by_id(maintopicFound.tcontainer_id)
                     if(tcontainerFound)
                        @maintopic = maintopicFound
                        @tcontainer = tcontainerFound
                        @maintopic.destroy
                        redirect_to tcontainer_maintopics_path(@tcontainer)
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
