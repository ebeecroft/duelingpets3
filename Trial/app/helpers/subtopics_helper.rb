module SubtopicsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         subtopicmode = Maintenancemode.find_by_id(12)
         mode_turned_on = (allmode.maintenance_on || subtopicmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to subtopics_maintenance_path
               end
            else
               switch type
            end
         else
            switch type
         end
      end
   end

   def firstPage
      params[:page].nil?
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

      def switch(type)
         if(type == "index") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allSubtopics = Subtopic.order("id").page(params[:page]).per(10)
                  @subtopics = allSubtopics
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "show") #Guest
            subtopicFound = Subtopic.find_by_id(params[:id])
            if(subtopicFound)
               maintopicFound = Maintopic.find_by_id(subtopicFound.maintopic_id)
               if(maintopicFound)
                  @maintopic = maintopicFound
                  @subtopic = subtopicFound
                  subtopicNarratives = @subtopic.narratives.all
                  @narratives = Kaminari.paginate_array(subtopicNarratives).page(params[:page]).per(10)
               else
                  render "public/404"
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
               if(maintopicFound)
                  newSubtopic = maintopicFound.subtopics.new
                  @maintopic = maintopicFound
                  @subtopic = newSubtopic
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               maintopicFound = Maintopic.find_by_id(params[:maintopic_id])
               if(maintopicFound)
                  newSubtopic = maintopicFound.subtopics.new(params[:subtopic])
                  newSubtopic.user_id = logged_in.id
                  currentTime = Time.now
                  newSubtopic.created_on = currentTime
                  @subtopic = newSubtopic
                  if(@subtopic.save)
                     @maintopic = maintopicFound
                     flash[:success] = 'Subtopic was successfully created.'
                     redirect_to maintopic_subtopic_path(@maintopic, @subtopic)
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
               subtopicFound = Subtopic.find_by_id(params[:id])
               if(subtopicFound)
                  userMatch = (logged_in.id == subtopicFound.user_id)
                  if(userMatch)
                     maintopicFound = Maintopic.find_by_id(subtopicFound.maintopic_id)
                     if(maintopicFound)
                        @maintopic = maintopicFound
                        @subtopic = subtopicFound
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
               subtopicFound = Subtopic.find_by_id(params[:id])
               if(subtopicFound)
                  userMatch = (logged_in.id == subtopicFound.user_id)
                  if(userMatch)
                     maintopicFound = Maintopic.find_by_id(subtopicFound.maintopic_id)
                     if(maintopicFound)
                        @subtopic = subtopicFound
                        if(@subtopic.update_attributes(params[:subtopic]))
                           @maintopic = maintopicFound
                           flash[:success] = 'Subtopic was successfully updated.'
                           redirect_to maintopic_subtopic_path(@maintopic, @subtopic)
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
               subtopicFound = Subtopic.find_by_id(params[:id])
               if(subtopicFound)
                  if(logged_in.admin)
                     maintopicFound = Maintopic.find_by_id(subtopicFound.maintopic_id)
                     if(maintopicFound)
                        @subtopic = subtopicFound
                        @maintopic = maintopicFound
                        @subtopic.destroy
                        redirect_to tcontainer_maintopic_path(@maintopic.tcontainer, @maintopic)
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
