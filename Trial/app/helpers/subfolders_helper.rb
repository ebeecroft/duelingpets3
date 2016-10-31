module SubfoldersHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         subfoldermode = Maintenancemode.find_by_id(18)
         mode_turned_on = (allmode.maintenance_on || subfoldermode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to subfolders_maintenance_path
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
         if(type == "index") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allSubfolders = Subfolder.order("id").page(params[:page]).per(10)
                  @subfolders = allSubfolders
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
            subfolderFound = Subfolder.find_by_id(params[:id])
            if(subfolderFound)
               mainfolderFound = Mainfolder.find_by_name(params[:mainfolder_id])
               if(mainfolderFound)
                  @mainfolder = mainfolderFound
                  @subfolder = subfolderFound
                  subfolderArtworks = @subfolder.artworks.all
                  reviewedArtworks = subfolderArtworks
                  if(subfolderArtworks.count > 0)
                     reviewedArtworks = subfolderArtworks.select{|artwork| artwork.reviewed}
                  end
                  @artworks = Kaminari.paginate_array(reviewedArtworks).page(params[:page]).per(10)
               else
                  render "public/404"
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               mainfolderFound = Mainfolder.find_by_name(params[:mainfolder_id])
               if(mainfolderFound)
                  userMatch = (logged_in.id == mainfolderFound.user_id)
                  if(userMatch)
                     newSubfolder = mainfolderFound.subfolders.new
                     @mainfolder = mainfolderFound
                     @subfolder = newSubfolder
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
               mainfolderFound = Mainfolder.find_by_name(params[:mainfolder_id])
               if(mainfolderFound)
                  userMatch = (logged_in.id == mainfolderFound.user_id)
                  if(userMatch)
                     newSubfolder = mainfolderFound.subfolders.new(params[:subfolder])
                     newSubfolder.user_id = logged_in.id
                     currentTime = Time.now
                     newSubfolder.created_on = currentTime
                     @subfolder = newSubfolder
                     if(@subfolder.save)
                        @mainfolder = mainfolderFound
                        flash[:success] = 'Subfolder was successfully created.'
                        redirect_to mainfolder_subfolder_path(@mainfolder, @subfolder)
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
               subfolderFound = Subfolder.find_by_id(params[:id])
               if(subfolderFound)
                  userMatch = ((logged_in.id == subfolderFound.user_id) || logged_in.admin)
                  if(userMatch)
                     mainfolderFound = Mainfolder.find_by_name(params[:mainfolder_id])
                     if(mainfolderFound)
                        @mainfolder = mainfolderFound
                        @subfolder = subfolderFound
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
               subfolderFound = Subfolder.find_by_id(params[:id])
               if(subfolderFound)
                  userMatch = ((logged_in.id == subfolderFound.user_id) || logged_in.admin)
                  if(userMatch)
                     mainfolderFound = Mainfolder.find_by_name(params[:mainfolder_id])
                     if(mainfolderFound)
                        @subfolder = subfolderFound
                        if(@subfolder.update_attributes(params[:subfolder]))
                           @mainfolder = mainfolderFound
                           flash[:success] = 'Subfolder was successfully updated.'
                           redirect_to mainfolder_subfolder_path(@mainfolder, @subfolder)
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
               subfolderFound = Subfolder.find_by_id(params[:id]) #Need to move this below the admin section to protect it
               if(subfolderFound)
                  if(logged_in.admin)
                     mainfolderFound = Mainfolder.find_by_id(subfolderFound.mainfolder_id)
                     if(mainfolderFound)
                        @subfolder = subfolderFound
                        @mainfolder = mainfolderFound
                        @subfolder.destroy
                        redirect_to mainfolder_subfolders_path(@mainfolder)
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
