module MainfoldersHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         mainfoldermode = Maintenancemode.find_by_id(17)
         mode_turned_on = (allmode.maintenance_on || mainfoldermode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to mainfolders_maintenance_path
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

      def getArtwork(subfolderFound)
         subfolderArtworks = subfolderFound.artworks.all
         reviewedArtworks = subfolderArtworks
         if(subfolderArtworks.count > 0)
            reviewedArtworks = subfolderArtworks.select{|artwork| artwork.reviewed}
         end
         recentArtwork = "No image available"
         if(reviewedArtworks.count > 0)
            recentArtwork = reviewedArtworks.last.art_url(:thumb).to_s
         end
         return recentArtwork
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
                  userMainfolders = userFound.mainfolders.all
                  @mainfolders = Kaminari.paginate_array(userMainfolders).page(params[:page]).per(10)
                  @user = userFound
               else
                  render "public/404"
               end
            else
               allMainfolders = Mainfolder.order("id").page(params[:page]).per(10)
               @mainfolders = allMainfolders
            end
         elsif(type == "show") #Guest
            mainfolderFound = Mainfolder.find_by_name(params[:id])
            if(mainfolderFound)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (userFound.id == mainfolderFound.user_id)
                  if(userMatch)
                     @mainfolder = mainfolderFound
                     mainfolderSubfolders = @mainfolder.subfolders.all
                     @subfolders = Kaminari.paginate_array(mainfolderSubfolders).page(params[:page]).per(10)
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
                     newMainfolder = Mainfolder.new
                     @mainfolder = newMainfolder
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
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     newMainfolder = Mainfolder.new(params[:mainfolder])
                     currentTime = Time.now
                     newMainfolder.created_on = currentTime
                     newMainfolder.user_id = userFound.id
                     @mainfolder = newMainfolder
                     @user = userFound
                     if(@mainfolder.save)
                        flash[:success] = 'Gallery was successfully created.'
                        redirect_to user_mainfolder_path(@user, @mainfolder)
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
               mainfolderFound = Mainfolder.find_by_name(params[:id])
               if(mainfolderFound)
                  userFound = User.find_by_vname(logged_in.vname)
                  if(userFound)
                     userMatch = ((userFound.id == mainfolderFound.user_id) || userFound.admin)
                     if(userMatch)
                        @user = userFound
                        @mainfolder = mainfolderFound
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
               mainfolderFound = Mainfolder.find_by_name(params[:id])
               if(mainfolderFound)
                  userFound = User.find_by_vname(params[:user_id])
                  if(userFound)
                     userMatch = ((userFound.id == mainfolderFound.user_id) || userFound.admin)
                     if(userMatch)
                        @mainfolder = mainfolderFound
                        @user = userFound
                        if(@mainfolder.update_attributes(params[:mainfolder]))
                           flash[:success] = 'Gallery was successfully updated.'
                           redirect_to user_mainfolder_path(@user, @mainfolder)
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
         elsif(type == "destroy") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  mainfolderFound = Mainfolder.find_by_name(params[:id])
                  if(mainfolderFound)
                     @mainfolder = mainfolderFound
                     @mainfolder.destroy
                     redirect_to mainfolders_list_url
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
                  allMainfolders = Mainfolder.order("id").page(params[:page]).per(10)
                  @mainfolders = allMainfolders
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
