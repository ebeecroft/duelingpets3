module ItemsHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         itemmode = Maintenancemode.find_by_id(6)
         mode_turned_on = (allmode.maintenance_on || itemmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to items_maintenance_path
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

      def getItemValue(itemValue)
         value = itemValue
         if(itemValue == 0)
            value="N/A"
         end
         return value
      end

      def switch(type)
         if(type == "index") #Guest Access needed
            itemCount = 0
            items = Item.order("id").page(params[:page]).per(10)
            items.each do |item|
               itemCount += 1
            end
            @items = items
            @count = itemCount
         elsif(type == "show") #Guest Access needed
            itemFound = Item.find_by_name(params[:id])
            if(itemFound)
               @item = itemFound
            else
               render "public/404"
            end
         elsif(type == "new") #Admin Only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  newItem = Item.new
                  @item = newItem
               else
                  redirect_to root_url
               end
            else
               redirect_to root_url
            end
         elsif(type == "create") #Admin Only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  newItem = Item.new(params[:item])
                  currentTime = Time.now
                  newItem.created_on = currentTime
                  @item = newItem
                  if(@item.save)
                     flash[:success] = 'Item was successfully created.'
                     redirect_to @item
                  else
                     render "new"
                  end
               else
                  redirect_to root_url
               end
            else
               redirect_to root_url
            end
         elsif(type == "edit") #Admin Only
            logged_in = current_user
            if(logged_in)
               itemFound = Item.find_by_name(params[:id])
               if(itemFound)
                  if(logged_in.admin)
                     @item = itemFound
                  else
                     redirect_to root_url
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_url
            end
         elsif(type == "update") #Admin Only
            logged_in = current_user
            if(logged_in)
               itemFound = Item.find_by_name(params[:id])
               if(itemFound)
                  if(logged_in.admin)
                     @item = itemFound
                     if(@item.update_attributes(params[:item]))
                        flash[:success] = 'Item was successfully updated.'
                        redirect_to @item
                     else
                        render "edit"
                     end
                  else
                     redirect_to root_url
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_url
            end
         elsif(type == "destroy") #Admin Only
            logged_in = current_user
            if(logged_in)
               itemFound = Item.find_by_name(params[:id])
               if(itemFound)
                  if(logged_in.admin)
                     @item = itemFound
                     @item.destroy
                     redirect_to items_url, notice: 'Item was successfully removed.'
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
