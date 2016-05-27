module EquipsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         equipmode = Maintenancemode.find_by_id(8)
         mode_turned_on = (allmode.maintenance_on || equipmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to equips_maintenance_path
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

      def savePetowner(petownerFound)
         #Check to see if pets is full
         if(petownerFound.hp == petownerFound.hp_max)
            redirect_to root_path
         else
            #Since pet isn't full we can use item
            petHealth = petownerFound.hp + @inventory.item.hp
            if(petHealth > petownerFound.hp_max)
               petownerFound.hp = petownerFound.hp_max
            else
               petownerFound.hp = petHealth
            end
            @petowner = petownerFound
            @petowner.save
            @inventory.destroy
            redirect_to user_inventories_path(@petowner.user.vname)
         end
      end

      def saveEquip(petownerFound)
         newEquip = petownerFound.equips.new(params[:equip])
         newEquip.inventory_id = @inventory.id
         newEquip.petowner_id = petownerFound.id
         @equip = newEquip
         if(@equip.save)
            @inventory.equipped = true
            @inventory.save
            redirect_to petowner_equips_path(petownerFound)
         else
            redirect_to user_inventories_path(petownerFound.user.vname)
         end
      end

      def use_item(multiple_use, petownerFound, inventoryFound)
         @inventory = inventoryFound
         if(multiple_use)
            #Special code here with inventory
            saveEquip(petownerFound)
         else
            #Special code here with inventory
            savePetowner(petownerFound)
         end
      end

      def switch(type)
         if(type == "index") #Guest and Admin
            optional = params[:petowner_id]
            setOptional optional
            if(getOptional)
               petownerFound = Petowner.find_by_id(optional)
               if(petownerFound)
                  petownerEquips = petownerFound.equips.all
                  @equips = Kaminari.paginate_array(petownerEquips).page(params[:page]).per(10)
                  @petowner = petownerFound
               else
                  render "public/404"
               end
            else
               logged_in = current_user
               if(logged_in)
                  if(logged_in.admin)
                     allEquips = Equip.order("id").page(params[:page]).per(10)
                     @equips = allEquips
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            end
         elsif(type == "create") #Login only and same user
            logged_in = current_user
            if(logged_in)
               petchosen = params[:selectedpet][:petowner_id]
               petownerFound = Petowner.find_by_id(petchosen)
               if(petownerFound)
                  inventoryFound = Inventory.find_by_id(params[:inventory_id])
                  if(inventoryFound)
                     userMatch = (inventoryFound.user_id == petownerFound.user_id)
                     if(userMatch)
                        use_item(inventoryFound.item.manyuses, petownerFound, inventoryFound)
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
               raise "My petowner field is not found"
               redirect_to root_path
            end
         elsif(type == "destroy") #Login only and same user
            logged_in = current_user
            if(logged_in)
               equipFound = Equip.find_by_id(params[:id])
               if(equipFound)
                  userMatch = (logged_in.id == equipFound.inventory.user_id)
                  if(userMatch)
                     petownerFound = Petowner.find_by_id(equipFound.petowner_id)
                     if(petownerFound)
                        inventoryFound = Inventory.find_by_id(equipFound.inventory_id)
                        if(inventoryFound)
                           inventoryFound.equipped = false
                           @inventory = inventoryFound
                           if(@inventory.save)
                              @equip = equipFound
                              @equip.destroy
                              redirect_to petowner_equips_path(petownerFound)
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
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         end
      end
end
