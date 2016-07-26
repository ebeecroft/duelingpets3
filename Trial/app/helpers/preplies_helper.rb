module PrepliesHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         preplymode = Maintenancemode.find_by_id(23)
         mode_turned_on = (allmode.maintenance_on || preplymode.maintenance_on)
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
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               pmFound = Pm.find_by_id(params[:pm_id])
               if(pmFound)
                  sender = User.find_by_vname(pmFound.from_user.vname)
                  reciever = User.find_by_vname(pmFound.to_user.vname)
                  userMatch = ((logged_in.id == sender.id) || (logged_in.id == reciever.id))
                  if(userMatch)
                     newReply = pmFound.preplies.new
                     @preply = newReply
                     @pm = pmFound
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
               pmFound = Pm.find_by_id(params[:pm_id])
               if(pmFound)
                  sender = User.find_by_vname(pmFound.from_user.vname)
                  reciever = User.find_by_vname(pmFound.to_user.vname)
                  userMatch = ((logged_in.id == sender.id) || (logged_in.id == reciever.id))
                  if(userMatch)
                     newReply = pmFound.preplies.new(params[:preply])
                     newReply.user_id = logged_in.id
                     currentTime = Time.now
                     newReply.created_on = currentTime
                     @preply = newReply
                     if(@preply.save)
                        @pm = pmFound
                        flash[:success] = "PReply #{@preply.message} was successfully created."
                        UserMailer.send_preply(@preply).deliver
                        redirect_to pms_outbox_path #user_pm_path(@pm.to_user, @pm)
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
               replyFound = Preply.find_by_id(params[:id])
               if(replyFound)
                  pmFound = Pm.find_by_id(replyFound.pm_id)
                  if(pmFound)
                     userMatch = ((logged_in.id == replyFound.user_id) || logged_in.admin)
                     if(userMatch)
                        @pm = pmFound
                        @preply = replyFound
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
               replyFound = Preply.find_by_id(params[:id])
               if(replyFound)
                  pmFound = Pm.find_by_id(replyFound.pm_id)
                  if(pmFound)
                     userMatch = ((logged_in.id == replyFound.user_id) || logged_in.admin)
                     if(userMatch)
                        @preply = replyFound
                        if(@preply.update_attributes(params[:preply]))
                           @pm = pmFound
                           flash[:success] = 'PReply was successfully updated.'
                           redirect_to pms_outbox_path #user_pm_path(@pm.to_user, @pm)
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
         elsif(type == "destroy") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  replyFound = Preply.find_by_id(params[:id])
                  if(replyFound)
                     userFound = User.find_by_vname(replyFound.user.vname)
                     if(userFound)
                        userMatch = ((userFound.id == logged_in.id) || logged_in.admin)
                        if(userMatch)
                           @preply = replyFound
                           @preply.destroy
                           redirect_to preplies_url
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
         end
      end
end
