module InventoriesHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         inventorymode = Maintenancemode.find_by_id(7)
         mode_turned_on = (allmode.maintenance_on || inventorymode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to inventories_maintenance_path
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

      def getItemValue(itemValue)
         value = itemValue
         if(itemValue == 0)
            value="N/A"
         end
         return value
      end

      def getItemType(itemType)
         value = "default"
         if itemType.manyuses
            value="Weapon"
         else
            value="Food"
         end
         return value
      end

      def switch(type)
         if(type == "index")
            #Locking down index till I get a better idea of what I am doing
            logged_in = current_user
            if(logged_in) #Forced loggin
               optional = params[:user_id]
               setOptional optional
               if(getOptional)
                  userFound = User.find_by_vname(optional)
                  if(userFound)
                     userMatch = (logged_in.id == userFound.id)
                     if(userMatch)
                        inventoryCount = 0
                        userInventories = logged_in.inventories.all
                        inventoryItems = userInventories.select{|inventory| !inventory.equipped}
                        @inventories = Kaminari.paginate_array(inventoryItems).page(params[:page]).per(10)
                        @inventories.each do |inventory|
                           if(!inventory.equipped) #Handles both no items and all equips
                              inventoryCount += 1
                           end
                        end
                        @icount = inventoryCount
                        if(@icount > 0)
                           userPets = logged_in.petowners
                           if(userPets.count > 0)
                              petsAvailable = userPets.select{|pet| !pet.in_battle}
                              @mypets = petsAvailable
                              @petCount = @mypets.count
                              @selectpet = logged_in.petowners.minimum(:id)
                           end
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     render "public/404"
                  end
               else
                  if(logged_in.admin) #Must be admin in this case
                     allInventories = Inventory.all
                     inventoryItems = allInventories.select{|inventory| !inventory.equipped}
                     @inventories = Kaminari.paginate_array(inventoryItems).page(params[:page]).per(10)
                     @icount = @inventories.count
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "create")
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in == userFound)
                  if(userMatch)
                     itemFound = Item.find_by_id(params[:item_id])
                     if(itemFound)
                        #Determines if the user has enough points to afford the item
                        pouchFound = Pouch.find_by_id(userFound.id)
                        amountLeft = (pouchFound.amount - itemFound.cost)
                        if(amountLeft < 0)
                           redirect_to items_path
                        else
                           newInventory = userFound.inventories.new(params[:inventory])
                           newInventory.item_id = itemFound.id
                           @inventory = newInventory
                           #Stores the inventory in the database if successful
                           if(@inventory.save)
                              pouchFound.amount = amountLeft
                              @pouch = pouchFound
                              @pouch.save
                              @user = userFound
                              redirect_to user_inventories_path(@user)
                           else
                              redirect_to root_path
                           end
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     redirect_to root_path
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
               inventoryFound = Inventory.find_by_id(params[:id])
               if(inventoryFound)
                  if(logged_in.admin)
                     userFound = User.find_by_vname(inventoryFound.user_id)
                     @inventory = inventoryFound
                     @inventory.destroy
                     redirect_to inventories_path
                  else
                     redirect_to root_path
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
