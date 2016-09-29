module BlacklisteddomainsHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         mode_turned_on = allmode.maintenance_on
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               redirect_to maintenance_path
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
                  allBlacklistedDomains = Blacklisteddomain.order("id").page(params[:page]).per(10)
                  @blacklisteddomains = allBlacklistedDomains
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "new")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  newBlacklistedDomain = Blacklisteddomain.new
                  @blacklisteddomain = newBlacklistedDomain
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "create")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  newBlacklistedDomain = Blacklisteddomain.new(params[:blacklisteddomain])
                  @blacklisteddomain = newBlacklistedDomain
                  if(@blacklisteddomain.save)
                     flash[:success] = "Domain #{@blacklisteddomain.name} has been added to the blacklist!"
                     redirect_to blacklisteddomains_url
                  else
                     render "new"
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "edit") #Might not be necessary
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  blacklisteddomainFound = Blacklisteddomain.find_by_name(params[:id])
                  if(blacklisteddomainFound)
                     @blacklisteddomain = blacklisteddomainFound
                  else
                     render "public/404"
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "update") #Might not be necessary
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  blacklisteddomainFound = Blacklisteddomain.find_by_name(params[:id])
                  if(blacklisteddomainFound)
                     @blacklisteddomain = blacklisteddomainFound
                     if(@blacklisteddomain.update_attributes(params[:blacklistdomain]))
                        flash[:success] = 'Blacklisteddomain was successfully updated.'
                        redirect_to blacklisteddomains_url
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
               redirect_to root_path
            end
         elsif(type == "destroy")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  blacklisteddomainFound = Blacklisteddomain.find_by_name(params[:id])
                  if(blacklisteddomainFound)
                     @blacklisteddomain = blacklisteddomainFound
                     @blacklisteddomain.destroy
                     flash[:success] = 'Blacklisteddomain was successfully removed.'
                     redirect_to blacklisteddomains_url
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
