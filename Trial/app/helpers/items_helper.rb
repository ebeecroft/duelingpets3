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

      def itemApproved
         itemFound = Item.find_by_id(params[:item_id])
         if(itemFound)
            itemFound.reviewed = true
            pouch = Pouch.find_by_user_id(itemFound.user_id)
            pointsForItem = 3
            pouch.amount += pointsForItem
            @pouch = pouch
            @pouch.save
            @item = itemFound
            @item.save
            ItemMailer.item_approved(@item, pointsForItem).deliver
            redirect_to items_review_path
         else
            render "public/404"
         end
      end

      def itemDenied
         itemFound = Item.find_by_id(params[:item_id])
         if(itemFound)
            #Retrieve the user who owns this pet first
            #userEmail = petFound.user.email
            #Send mail to user with link to edit the pet they sent
            @item = itemFound
            ItemMailer.item_denied(@item).deliver
            redirect_to items_review_path
         else
            render "public/404"
         end
      end

      def switch(type)
         if(type == "index") #Guest Access needed
            itemCount = 0
            allItems = Item.order("created_on desc")
            reviewedItems = allItems.select{|item| item.reviewed}
            itemCount = reviewedItems.count
            @items = Kaminari.paginate_array(reviewedItems).page(params[:page]).per(9) #reviewedItems
            @count = itemCount
         elsif(type == "show") #Guest Access needed
            logged_in = current_user
            if(logged_in)
               cstatus = Onlineuser.find_by_user_id(logged_in.id)
               cstatus.last_visited = Time.now
               @cstatus = cstatus
               @cstatus.save
            end
            itemFound = Item.find_by_name(params[:id])
            if(itemFound)
               @item = itemFound
            else
               render "public/404"
            end
         elsif(type == "new") #Login Only
            logged_in = current_user
            if(logged_in)
               newItem = Item.new
               @item = newItem
            else
               redirect_to root_url
            end
         elsif(type == "create") #Login Only
            logged_in = current_user
            if(logged_in)
               newItem = Item.new(params[:item])
               newItem.user_id = logged_in.id
               cost = 0
               if((newItem.hp && newItem.atk) && (newItem.def && newItem.spd))
                  hpCost = 3 * newItem.hp
                  atkCost = 3 * newItem.atk
                  defCost = 3 * newItem.def
                  spdCost = 3 * newItem.spd
                  baseCost = 3
                  cost = hpCost + atkCost + defCost + spdCost + baseCost
               end
               newItem.cost = cost
               currentTime = Time.now
               newItem.created_on = currentTime
               @item = newItem
               if(@item.save)
                  ItemMailer.review_item(@item).deliver
                  flash[:success] = 'Item was successfully created.'
                  redirect_to @item
               else
                  render "new"
               end
            else
               redirect_to root_url
            end
         elsif(type == "edit") #Login and same user
            logged_in = current_user
            if(logged_in)
               itemFound = Item.find_by_name(params[:id])
               if(itemFound)
                  userMatch = ((logged_in.id == itemFound.user_id) || logged_in.admin)
                  if(userMatch)
                     @item = itemFound
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_url
            end
         elsif(type == "update") #Login Only
            logged_in = current_user
            if(logged_in)
               itemFound = Item.find_by_name(params[:id])
               if(itemFound)
                  userMatch = ((logged_in.id == itemFound.user_id) || logged_in.admin)
                  if(userMatch)
                     cost = 0
                     if((itemFound.hp && itemFound.atk) && (itemFound.def && itemFound.spd))
                        hpCost = 3 * itemFound.hp
                        atkCost = 3 * itemFound.atk
                        defCost = 3 * itemFound.def
                        spdCost = 3 * itemFound.spd
                        baseCost = 3
                        cost = hpCost + atkCost + defCost + spdCost + baseCost
                     end
                     itemFound.cost = cost
                     @item = itemFound
                     if(@item.update_attributes(params[:item]))
                        flash[:success] = 'Item was successfully updated.'
                        redirect_to @item
                     else
                        render "edit"
                     end
                  else
                     redirect_to root_path
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
         elsif(type == "review")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allItems = Item.all
                  itemsToReview = allItems.select{|item| !item.reviewed}
                  @items = Kaminari.paginate_array(itemsToReview).page(params[:page]).per(10)
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     allItems = Item.all
                     itemsToReview = allItems.select{|item| !item.reviewed}
                     @items = Kaminari.paginate_array(itemsToReview).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "approve")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  itemApproved
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     itemApproved
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "deny")
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  itemDenied
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     itemDenied
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "list") #Admin needed
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allItems = Item.order("created_on desc")
                  @items = Kaminari.paginate_array(allItems).page(params[:page]).per(9) #reviewedItems
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
