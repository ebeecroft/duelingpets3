module NarrativesHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         narrativemode = Maintenancemode.find_by_id(13)
         mode_turned_on = (allmode.maintenance_on || narrativemode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to narratives_maintenance_path
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
                  allNarratives = Narrative.order("id").page(params[:page]).per(10)
                  @narratives = allNarratives
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               subtopicFound = Subtopic.find_by_id(params[:subtopic_id])
               if(subtopicFound)
                  newNarrative = subtopicFound.narratives.new
                  @subtopic = subtopicFound
                  @narrative = newNarrative
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               subtopicFound = Subtopic.find_by_id(params[:subtopic_id])
               if(subtopicFound)
                  newNarrative = subtopicFound.narratives.new(params[:narrative])
                  newNarrative.user_id = logged_in.id
                  currentTime = Time.now
                  newNarrative.created_on = currentTime
                  @narrative = newNarrative
                  if(@narrative.save)
                     @subtopic = subtopicFound
                     flash[:success] = 'Narrative was successfully created.'
                     redirect_to maintopic_subtopic_path(@subtopic.maintopic, @narrative.subtopic)
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
               narrativeFound = Narrative.find_by_id(params[:id])
               if(narrativeFound)
                  userMatch = (logged_in.id == narrativeFound.user_id)
                  if(userMatch)
                     subtopicFound = Subtopic.find_by_id(narrativeFound.subtopic_id)
                     if(subtopicFound)
                        @subtopic = subtopicFound
                        @narrative = narrativeFound
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
         elsif(type == "update") #Login only
            logged_in = current_user
            if(logged_in)
               narrativeFound = Narrative.find_by_id(params[:id])
               if(narrativeFound)
                  userMatch = (logged_in.id == narrativeFound.user_id)
                  if(userMatch)
                     subtopicFound = Subtopic.find_by_id(narrativeFound.subtopic_id)
                     if(subtopicFound)
                        @narrative = narrativeFound
                        if(@narrative.update_attributes(params[:narrative]))
                           @subtopic = subtopicFound
                           flash[:success] = 'Narrative was successfully updated.'
                           redirect_to maintopic_subtopic_path(@subtopic.maintopic, @narrative.subtopic)
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
               narrativeFound = Narrative.find_by_id(params[:id])
               if(narrativeFound)
                  if(logged_in.admin)
                     subtopicFound = Subtopic.find_by_id(narrativeFound.subtopic_id)
                     if(subtopicFound)
                        @narrative = narrativeFound
                        @subtopic = subtopicFound
                        @narrative.destroy
                        redirect_to maintopic_subtopic_path(@subtopic.maintopic, @subtopic)
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
