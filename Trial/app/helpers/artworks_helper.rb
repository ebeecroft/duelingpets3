module ArtworksHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         artworkmode = Maintenancemode.find_by_id(19)
         mode_turned_on = (allmode.maintenance_on || artworkmode.maintenance_on)
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

      def artworkApproved
         artworkFound = Artwork.find_by_id(params[:artwork_id])
         if(artworkFound)
            artworkFound.reviewed = true
            pouch = Pouch.find_by_user_id(artworkFound.user_id)
            pointsForArt = 10
            pouch.amount += pointsForArt
            @pouch = pouch
            @pouch.save
            @artwork = artworkFound
            @artwork.save
            ArtworkMailer.artwork_approved(@artwork, pointsForArt).deliver
            redirect_to artworks_review_path
         else
            render "public/404"
         end
      end

      def artworkDenied
         artworkFound = Artwork.find_by_id(params[:artwork_id])
         if(artworkFound)
            #Retrieve the user who owns this pet first
            #userEmail = petFound.user.email
            #Send mail to user with link to edit the pet they sent
            @artwork = artworkFound
            ArtworkMailer.artwork_denied(@artwork).deliver
            redirect_to artworks_review_path
         else
            render "public/404"
         end
      end

      def createArtwork(subfolderFound)
         newArtwork = subfolderFound.artworks.new
         @subfolder = subfolderFound
         @artwork = newArtwork
      end

      def saveArtwork(subfolderFound, logged_in)
         newArtwork = subfolderFound.artworks.new(params[:artwork])
         newArtwork.user_id = logged_in.id
         currentTime = Time.now
         newArtwork.created_on = currentTime
         @artwork = newArtwork
         @subfolder = subfolderFound
         if(@artwork.save)
            ArtworkMailer.review_artwork(@artwork).deliver
            flash[:success] = "#{@artwork.title} is currently being reviewed please check back later."
            redirect_to subfolder_artwork_path(@subfolder, @artwork)
         else
            render "new"
         end
      end

      def switch(type)
         if(type == "index") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allArtworks = Artwork.order("id").page(params[:page]).per(10)
                  @artworks = allArtworks
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
            artworkFound = Artwork.find_by_id(params[:id])
            if(artworkFound)
               subfolderFound = Subfolder.find_by_id(params[:subfolder_id])
               if(subfolderFound)
                  if(artworkFound.reviewed)
                     @subfolder = subfolderFound
                     @artwork = artworkFound
                  else
                     logged_in = current_user
                     if(logged_in)
                        userMatch = ((logged_in.id == artworkFound.user_id) || logged_in.admin)
                        if(userMatch)
                           @subfolder = subfolderFound
                           @artwork = artworkFound
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
               subfolderFound = Subfolder.find_by_id(params[:subfolder_id])
               if(subfolderFound)
                  if(subfolderFound.collab_mode)
                     createArtwork(subfolderFound)
                  else
                     userMatch = (logged_in.id == subfolderFound.user_id)
                     if(userMatch)
                        createArtwork(subfolderFound)
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
               subfolderFound = Subfolder.find_by_id(params[:subfolder_id])
               if(subfolderFound)
                  if(subfolderFound.collab_mode)
                     saveArtwork(subfolderFound, logged_in)
                  else
                     userMatch = (logged_in.id == subfolderFound.user_id)
                     if(userMatch)
                        saveArtwork(subfolderFound, logged_in)
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
               artworkFound = Artwork.find_by_id(params[:id])
               if(artworkFound)
                  userMatch = (logged_in.id == artworkFound.user_id)
                  if(userMatch)
                     subfolderFound = Subfolder.find_by_id(artworkFound.subfolder_id)
                     if(subfolderFound)
                        @subfolder = subfolderFound
                        @artwork = artworkFound
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
               artworkFound = Artwork.find_by_id(params[:id])
               if(artworkFound)
                  userMatch = (logged_in.id == artworkFound.user_id)
                  if(userMatch)
                     subfolderFound = Subfolder.find_by_id(artworkFound.subfolder_id)
                     if(subfolderFound)
                        @artwork = artworkFound
                        if(@artwork.update_attributes(params[:artwork]))
                           @subfolder = subfolderFound
                           flash[:success] = 'Artwork was successfully updated.'
                           redirect_to subfolder_artwork_path(@subfolder, @artwork)
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
               artworkFound = Artwork.find_by_id(params[:id]) #Need to move this below the admin section to protect it
               if(artworkFound)
                  if(logged_in.admin)
                     subfolderFound = Subfolder.find_by_id(artworkFound.subfolder_id)
                     if(subfolderFound)
                        @artwork = artworkFound
                        @subfolder = subfolderFound
                        @artwork.destroy
                        redirect_to mainfolder_subfolder_path(@subfolder.mainfolder, @subfolder)
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
         elsif(type == "review") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allArtworks = Artwork.all
                  artworksToReview = allArtworks.select{|artwork| !artwork.reviewed}
                  @artworks = Kaminari.paginate_array(artworksToReview).page(params[:page]).per(10)
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     allArtworks = Artwork.all
                     artworksToReview = allArtworks.select{|artwork| !artwork.reviewed}
                     @artworks = Kaminari.paginate_array(artworksToReview).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "approve") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  artworkApproved
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     artworkApproved
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "deny") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  artworkDenied
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     artworkDenied
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
