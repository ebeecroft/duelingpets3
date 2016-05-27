module PetownersHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         petownermode = Maintenancemode.find_by_id(4)
         mode_turned_on = (allmode.maintenance_on || petownermode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to petowners_maintenance_path
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

      def savePetowner(purchaseCode)
         if(@petowner.save)
            if(purchaseCode == 2)
               @pouch.save
            end
            flash[:success] = 'Petowner was successfully created.'
            redirect_to user_petowners_path(@user)
         else
            render "new"
         end
      end

      def storeStats(petowner, pet)
         #Initially sets up pet stats
         petowner.level = pet.level
         petowner.hp = pet.hp
         petowner.atk = pet.atk
         petowner.def = pet.def
         petowner.spd = pet.spd
         petowner.hp_max = pet.hp
         currentTime = Time.now
         petowner.adopted_on = currentTime
         @petowner = petowner
      end

      def purchase(petCount, petowner, pouch)
         #Determine the amount of pets the user owns
         purchaseCode = 0
         if(petCount > 0)
            #Determine if the user can afford to purchase the pet
            moneyLeft = pouch.amount - petowner.pet.cost
            if(moneyLeft < 0)
               purchaseCode = 1
            else
               purchaseCode = 2
               pouch.amount = moneyLeft
               @pouch = pouch
            end
         end
         return purchaseCode
      end

      def setOptional(optional)
         @optional = optional
      end

      def switch(type)
         if(type == "index") #Guest and Admin
            optional = params[:user_id]
            setOptional optional
            if(getOptional)
               userFound = User.find_by_vname(optional)
               if(userFound)
                  userPets = userFound.petowners.all
                  @petowners = Kaminari.paginate_array(userPets).page(params[:page]).per(10)
                  @user = userFound
               else
                  render "public/404"
               end
            else
               logged_in = current_user
               if(logged_in)
                  if(logged_in.admin)
                     allPetowners = Petowner.order("id").page(params[:page]).per(10)
                     @petowners = allPetowners
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            end
         elsif(type == "show") #Guest
            userFound = User.find_by_vname(params[:user_id])
            if(userFound)
               petownerFound = Petowner.find_by_id(params[:id])
               if(petownerFound)
                  userMatch = (userFound.id == petownerFound.user_id)
                  if(userMatch)
                     @petowner = petownerFound
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               rendirect_to root_path
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     newPetowner = logged_in.petowners.new
                     petFound = Pet.find_by_id(params[:pet_id])
                     if(petFound)
                        newPetowner.pet_id = petFound.id
                        @petowner = newPetowner
                        @user = userFound
                     else
                        redirect_to pets_path
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
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     #Initialize the local variables
                     newPetowner = logged_in.petowners.new(params[:petowner])
                     pouchFound = Pouch.find_by_id(newPetowner.user_id)
                     #Purchases the pet
                     purchaseCode = purchase(logged_in.petowners.count, newPetowner, pouchFound)
                     #Stores the petowner's stats
                     storeStats(newPetowner, newPetowner.pet)
                     #Checks the return code to see if the pet can be bought
                     if(purchaseCode == 1)
                        flash[:error] = 'You do not have enough points to afford this pet.'
                        redirect_to pets_path
                     else
                        @user = userFound
                        if(purchaseCode == 0)
                           #Allows the purchase only if the user has selected a starter pet
                           starterPet = newPetowner.pet.starter
                           if(starterPet)
                              savePetowner(purchaseCode)
                           else
                              redirect_to pets_path
                           end
                        else
                           savePetowner(purchaseCode)
                        end
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
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  petownerFound = Petowner.find_by_id(params[:id])
                  if(petownerFound)
                     userMatch = ((userFound.id == petownerFound.user_id) || logged_in.admin)
                     if(userMatch)
                        @user = userFound
                        @petowner = petownerFound
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
         elsif(type == "update") #Login only and same user
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  petownerFound = Petowner.find_by_id(params[:id])
                  if(petownerFound)
                     userMatch = ((userFound.id == petownerFound.user_id) || logged_in.admin)
                     if(userMatch)
                        @petowner = petownerFound
                        if(@petowner.update_attributes(params[:petowner]))
                           @user = userFound
                           flash[:success] = 'Petowner was successfully updated.'
                           redirect_to user_petowner_path(@user, @petowner)
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
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "destroy") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  petownerFound = Petowner.find_by_id(params[:id])
                  if(petownerFound)
                     userFound = User.find_by_vname(petownerFound.user_id)
                     if(userFound)
                        @petowner = petownerFound
                        @user = userFound
                        @petowner.destroy
                        redirect_to user_petowners_path(@user)
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
         elsif(type == "health")
            petownerFound = Petowner.find_by_id(params[:petowner_id])
            if(petownerFound)
               if(petownerFound.boost_tokens > 0)
                  petownerFound.hp_max += 1
                  petownerFound.boost_tokens -= 1
                  @petowner = petownerFound
                  @petowner.save
                  flash[:success]="Pets hp was successfully increased."
                  redirect_to user_petowners_path(@petowner.user)
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "attack")
            petownerFound = Petowner.find_by_id(params[:petowner_id])
            if(petownerFound)
               if(petownerFound.boost_tokens > 0)
                  if(petownerFound.def != petownerFound.spd || (petownerFound.atk + 1) != petownerFound.spd)
                     petownerFound.atk += 1
                     petownerFound.boost_tokens -= 1
                     @petowner = petownerFound
                     @petowner.save
                     flash[:success]="Pets atk was successfully increased."
                     redirect_to user_petowners_path(@petowner.user)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "defense")
            petownerFound = Petowner.find_by_id(params[:petowner_id])
            if(petownerFound)
               if(petownerFound.boost_tokens > 0)
                  if(petownerFound.spd != petownerFound.atk || (petownerFound.def + 1) != petownerFound.atk)
                     petownerFound.def += 1
                     petownerFound.boost_tokens -= 1
                     @petowner = petownerFound
                     @petowner.save
                     flash[:success]="Pets def was successfully increased."
                     redirect_to user_petowners_path(@petowner.user)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "speed")
            petownerFound = Petowner.find_by_id(params[:petowner_id])
            if(petownerFound)
               if(petownerFound.boost_tokens > 0)
                  if(petownerFound.atk != petownerFound.def || (petownerFound.spd + 1) != petownerFound.def)
                     petownerFound.spd += 1
                     petownerFound.boost_tokens -= 1
                     @petowner = petownerFound
                     @petowner.save
                     flash[:success]="Pets spd was successfully increased."
                     redirect_to user_petowners_path(@petowner.user)
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
