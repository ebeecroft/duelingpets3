module SbooksHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         sbookmode = Maintenancemode.find_by_id(14)
         mode_turned_on = (allmode.maintenance_on || sbookmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to sbooks_maintenance_path
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
                  userSbooks = userFound.sbooks.all
                  @sbooks = Kaminari.paginate_array(userSbooks).page(params[:page]).per(10)
                  @user = userFound
               else
                  render "public/404"
               end
            else
               allSbook = Sbook.order("id").page(params[:page]).per(10)
               @sbooks = allSbook
            end
         elsif(type == "show") #Guest
            sbookFound = Sbook.find_by_name(params[:id]) #remember to come back and repair this
            if(sbookFound)
               userFound = User.find_by_vname(params[:user_id]) #cant use user id here
               if(userFound)
                  userMatch = (userFound.id == sbookFound.user_id)
                  if(userMatch)
                     @sbook = sbookFound
                     sbookBooks = @sbook.books.all
                     @books = Kaminari.paginate_array(sbookBooks).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only and same user
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     newSbook = Sbook.new
                     @sbook = newSbook
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
         elsif(type == "create") #Login only and same user
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id]) #This parameter is necessary
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     newSbook = Sbook.new(params[:sbook])
                     currentTime = Time.now
                     newSbook.created_on = currentTime
                     newSbook.user_id = userFound.id
                     @sbook = newSbook
                     @user = userFound
                     if(@sbook.save)
                        flash[:success] = 'Series was successfully created.'
                        redirect_to user_sbook_path(@user, @sbook)
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
               sbookFound = Sbook.find_by_name(params[:id])
               if(sbookFound)
                  userFound = User.find_by_vname(logged_in.vname)
                  if(userFound)
                     userMatch = ((userFound.id == sbookFound.user_id) || userFound.admin)
                     if(userMatch)
                        @user = userFound
                        @sbook = sbookFound
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
               sbookFound = Sbook.find_by_name(params[:id])
               if(sbookFound)
                  userFound = User.find_by_vname(params[:user_id])
                  if(userFound)
                     userMatch = ((userFound.id == sbookFound.user_id) || userFound.admin)
                     if(userMatch)
                        @sbook = sbookFound
                        @user = userFound
                        if(@sbook.update_attributes(params[:sbook]))
                           flash[:success] = 'Series was successfully updated.'
                           redirect_to user_sbook_path(@user, @sbook)
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
                  sbookFound = Sbook.find_by_name(params[:id])
                  if(sbookFound)
                     @sbook = sbookFound
                     @sbook.destroy
                     redirect_to sbooks_list_url
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
                  allSbook = Sbook.order("id").page(params[:page]).per(10)
                  @sbooks = allSbook
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
