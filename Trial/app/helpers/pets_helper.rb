module PetsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         petmode = Maintenancemode.find_by_id(3)
         mode_turned_on = (allmode.maintenance_on || petmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to pets_maintenance_path
               end
            else
               switch type
            end
         else
            switch type
         end
      end
   end

   def getPetType
      @petType
   end

   def getPetType2(monster)
      value = monster
      return value
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

      def petDenied
         petFound = Pet.find_by_id(params[:pet_id])
         if(petFound)
            #Retrieve the user who owns this pet first
            #userEmail = petFound.user.email
            #Send mail to user with link to edit the pet they sent
            @pet = petFound
            PetMailer.pet_denied(@pet).deliver
            redirect_to pets_review_path
         else
            render "public/404"
         end
      end

      def petApproved
         petFound = Pet.find_by_id(params[:pet_id])
         if(petFound)
            petFound.reviewed = true
            pouch = Pouch.find_by_user_id(petFound.user_id)
            pointsForPet = 10
            pouch.amount += pointsForPet
            @pouch = pouch
            @pouch.save
            @pet = petFound
            @pet.save
            PetMailer.pet_approved(@pet, pointsForPet).deliver
            redirect_to pets_review_path
         else
            render "public/404"
         end
      end

      def petType(type)
         allPets = Pet.order("created_on desc") #originall all
#.order("created_on desc")
         reviewedPets = allPets.select{|pet| pet.reviewed}
         if(type == "pet")
            pets = reviewedPets.select{|pet| !pet.monster}
            petCount = pets.count
            if(current_user && !current_user.admin)
               ownedPetCount = current_user.petowners.count
               if(ownedPetCount > 0)
                  @pets = Kaminari.paginate_array(pets).page(params[:page]).per(9)
               else
                  starterPets = pets.select{|pet| pet.starter}
                  @pets = Kaminari.paginate_array(starterPets).page(params[:page]).per(9)
               end
            else
               @pets = Kaminari.paginate_array(pets).page(params[:page]).per(9)
            end
            @count = petCount
         elsif(type == "monster")
            monsters = reviewedPets.select{|pet| pet.monster}
            monsterCount = monsters.count
            @pets = Kaminari.paginate_array(monsters).page(params[:page]).per(9)
            @count = monsterCount
         end
         @petType = type
      end

      def calculator(health, attack, defense, speed)
         results = `calc/calc #{health} #{attack} #{defense} #{speed}`
         string_array = results.split(",")
         return string_array
      end

      def validator(health, attack, defense, speed)
         #Minimum pet values
         minHealth = 6
         minAttack = 1
         minDefense = 1
         minSpeed = 1

         #Determines if the pet is valid
         errorFlag = false
         validPet = ((health >= minHealth && attack >= minAttack) && (defense >= minDefense && speed >= minSpeed))
         if(validPet)
            #Does nothing since this pet is valid
            if(attack == defense && defense == speed)
               flash.now[:aerror] = "Attack, Defense and Speed can not be the same value"
               errorFlag = true
            else
               total = health + attack + defense + speed
               divisibleBy2 = (total % 2 == 0)
               if(!divisibleBy2)
                  flash.now[:aerror] = "The pet's total value is not divisible by 2"
                  errorFlag = true
               end
            end
         else
            if(health < minHealth)
               flash.now[:herror] = "HP is below minimum value of #{minHealth}"
            end

            if(attack < minAttack)
               flash.now[:aerror] = "ATK is below minimum value of #{minAttack}"
            end

            if(defense < minDefense)
               flash.now[:derror] = "DEF is below minimum value of #{minDefense}"
            end

            if(speed < minSpeed)
               flash.now[:serror] = "SPD is below minimum value of #{minSpeed}"
            end
            errorFlag = true
         end
         return errorFlag
      end

      def switch(type)
         if(type == "index") #Guest
            petType("pet")
#            @count2 = 0
         elsif(type == "show") #Guest
            #We want to show pets regardless of review status
            petFound = Pet.find_by_species_name(params[:id])
            if(petFound)
               #Pets that haven't been reviewed should only be visable to the user who created them
               if(petFound.reviewed)
                  @pet = petFound
               else
                  logged_in = current_user
                  if(logged_in)
                     userMatch = ((logged_in.id == petFound.user_id) || logged_in.admin)
                     if(userMatch)
                        @pet = petFound
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
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               newPet = Pet.new
               @user = logged_in
               @pet = newPet
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               newPet = Pet.new(params[:pet])
               #Need to check if the pet is valid first before proceeding
               errorFlag = validator(newPet.hp, newPet.atk, newPet.def, newPet.spd)
               if(errorFlag)
                  @pet = newPet
                  @user = logged_in
                  render "new"
               else
                  #Need to calculate the pet's cost and level
                  string_array = calculator(newPet.hp, newPet.atk, newPet.def, newPet.spd)
                  petCost, petLevel = string_array.map { |str| str.to_i}
                  newPet.cost = petCost
                  newPet.level = petLevel
                  currentTime = Time.now
                  newPet.created_on = currentTime
                  newPet.user_id = logged_in.id
                  #Add the pet to the database
                  @pet = newPet
                  @user = logged_in
                  if(@pet.save)
                     PetMailer.review_pet(@pet).deliver
                     flash[:success] = "#{@pet.species_name} is currently being reviewed please check back later."
                     redirect_to pets_url
                  else
                     render "new"
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "edit") #Login only and same user
            logged_in = current_user
            if(logged_in)
               petFound = Pet.find_by_species_name(params[:id])
               if(petFound)
                  userMatch = ((logged_in.id == petFound.user_id) || logged_in.admin)
                  if(userMatch)
                     @user = logged_in
                     @pet = petFound
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
               petFound = Pet.find_by_species_name(params[:id])
               if(petFound)
                  #Need to calculate the pet's cost and level
                  #Check for error here
                  errorFlag = validator(petFound.hp, petFound.atk, petFound.def, petFound.spd)
                  if(!errorFlag)
                     userMatch = ((logged_in.id == petFound.user_id) || logged_in.admin)
                     if(userMatch)
                        @user = logged_in
                        @pet = petFound
                        string_array = calculator(@pet.hp, @pet.atk, @pet.def, @pet.spd)
                        petCost, petLevel = string_array.map { |str| str.to_i}
                        @pet.cost = petCost
                        @pet.level = petLevel
                        if(@pet.update_attributes(params[:pet])) #@pet.update_attributes(params[:pet])
                           #Save the hp, atk, def and spd first
                           #Save the pet cost, and level
                           #@pet.save
                           flash[:success] = 'Pet was successfully updated.'
                           redirect_to @pet
                        else
                           render "edit"
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     render "edit"
                  end
               else
                  redirect_to "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "destroy") #Admin
            logged_in = current_user
            if(logged_in)
               petFound = Pet.find_by_species_name(params[:id])
               if(petFound)
                  if(logged_in.admin)
                     @pet = petFound
                     @pet.destroy
                     flash[:success] = 'Pet was succesfully removed.'
                     redirect_to pets_url
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "list") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allPets = Pet.order("id").page(params[:page]).per(10)
                  @pets = allPets
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "review") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allPets = Pet.all
                  petsToReview = allPets.select{|pet| !pet.reviewed}
                  @pets = Kaminari.paginate_array(petsToReview).page(params[:page]).per(10)
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     allPets = Pet.all
                     petsToReview = allPets.select{|pet| !pet.reviewed}
                     @pets = Kaminari.paginate_array(petsToReview).page(params[:page]).per(10)
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
                  petApproved
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     petApproved
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
                  petDenied
               else
                  typeFound = Usertype.find_by_user_id(logged_in.id)
                  if(typeFound.privilege == "Reviewer")
                     petDenied
                  else
                     redirect_to root_path
                  end
               end
            else
               redirect_to root_path
            end
         elsif(type == "monsters") #Login only
            logged_in = current_user
            if(logged_in)
               petType("monster")
               #Petowner List
               healthyPets = logged_in.petowners.select{|pet| pet.hp != 0}
               availablePets = healthyPets.select{|pet| pet.in_battle != true}
               @mypets = availablePets
               @selectpet = logged_in.petowners.minimum(:id)
               #@petselected = availablePets.minimum()
               #Might need @pet here for last parameter
            else
               redirect_to root_path
            end
         else
            raise "Invalid selection was chosen."
         end
      end
end
