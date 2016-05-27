module FightsHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         fightmode = Maintenancemode.find_by_id(5)
         mode_turned_on = (allmode.maintenance_on || fightmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to fights_maintenance_path
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

      def startBattle
         start = !(@fight.mdamage.nil? || @fight.pdamage.nil?)
         return start
      end

      def battleDone
         value = @fight.battle_done
         return value
      end

      def getCoins
         value = 0
         if(!@fight.coins.nil? && @fight.coins > 0)
            value = @fight.coins
         end
         return value
      end

      def getExpGained
         value = @fight.exp_gained
         return value
      end

      def getBoostTokens
         value = 0
         if(@fight.boost_tokens > 0)
            value = @fight.boost_tokens
         end
         return value
      end

      def getFight
         value = ""
         if(!@fight.battle_done)
            sameUser = (current_user && (current_user.id == @fight.petowner.user.id))
            if(sameUser)
               render "battle"
            end
         else
            win = (!@fight.coins.nil? && @fight.coins > 0)
            draw = (@fight.mhp == 0 && @fight.petowner.hp == 0)
            loss = (@fight.mhp > 0)
            if(win)
               value = "Congratulations your pet won!"#Congratulations your pet just won #{@fight.coins} dp points!<br> Your pet gained #{@fight.exp_gained} experience!<br> Your pet also gained #{@fight.boost_tokens} boost tokens!"
            elsif(draw)
               value = "Well at least your pet gave it all it had!"#"Your pet gained #{@fight.exp_gained} experience!<br> Your pet also gained #{@fight.boost_tokens} boost tokens!" #"Your pet gained #{@fight.boost_tokens} boost tokens!"
            elsif(loss)
               value = "Sorry better luck next time!"
            end
            return value
         end
      end

      def getName(type)
         value = "NULL"
         if(type == "Pet")
            value = @fight.petowner.pet_name
         else
            value = @fight.pet.species_name
         end
         return value
      end

      def getImage(type)
         value = "No image available"
         if(type == "Pet")
            value = @fight.petowner.pet.image_url(:thumb).to_s
         else
            value = @fight.pet.image_url(:thumb).to_s
         end
         return value
      end

      def getLevel(type)
         value = 0
         if(type == "Pet")
            value = @fight.level #petowner.level
         else
            value = @fight.pet.level
         end
         return value
      end

      def getExp(type)
         value = 0
         if(type == "Pet")
            value = @fight.exp #petowner.exp
         end
         return value
      end

      def getCurrentHp(type)
         value = 0
         if(type == "Pet")
            value = @fight.pet_hp #petowner.hp
         else
            value = @fight.mhp
         end
         return value
      end

      def getMaxHp(type)
         value = 0
         if(type == "Pet")
            value = @fight.hp #petowner.hp_max
         else
            value = @fight.pet.hp
         end
         return value
      end

      def getAtk(type)
         value = 0
         if(type == "Pet")
            value = @fight.atk #petowner.atk
         else
            value = @fight.pet.atk
         end
         return value
      end

      def getDef(type)
         value = 0
         if(type == "Pet")
            value = @fight.def #petowner.def
         else
            value = @fight.pet.def
         end
         return value
      end

      def getSpd(type)
         value = 0
         if(type == "Pet")
            value = @fight.spd #petowner.spd
         else
            value = @fight.pet.spd
         end
         return value
      end

      def getDamage(type)
         value = 0
         if(type == "Pet")
            if(@fight.mdamage > 0)
               value = "Damage dealt to pet: #{@fight.mdamage}"
            else
               value = "The monster's attack missed!"
            end
         else
            if(@fight.pdamage > 0)
               value = "Damage dealt to monster: #{@fight.pdamage}"
            else
               value = "The pet's attack missed!"
            end
         end
         return value
      end

      def baseStats(petownerFound, health)
         #Base stats need to be useable outside of this method
         baseAttack = petownerFound.atk
         baseDefense = petownerFound.def
         baseSpeed = petownerFound.spd
         baseHealth = health #petownerFound.hp #Should eventually be replaced by fight.pet_hp
         baseMaxHealth = petownerFound.hp_max
         baseLevel = petownerFound.level
         baseExp = petownerFound.exp
         bStats = [baseLevel, baseAttack, baseDefense, baseSpeed, baseHealth, baseMaxHealth, baseExp]
         return bStats
      end

      def petEquipment(petownerFound)
         #Equipment attached to the pet
         equipAttack = 0
         equipDefense = 0
         equipSpeed = 0
         petEquips = petownerFound.equips.all
         petEquips.each do |equip|
            equipAttack += equip.inventory.item.atk
            equipDefense += equip.inventory.item.def
            equipSpeed += equip.inventory.item.spd
         end
         eStats = [equipAttack, equipDefense, equipSpeed]
         return eStats
      end

      def enhancedStats(bStats, eStats)
         #Sets the pets total stats
         petAttack = bStats[1] + eStats[0]
         petDefense = bStats[2] + eStats[1]
         petSpeed = bStats[3] + eStats[2]
         petStats = [petAttack, petDefense, petSpeed]
         return petStats
      end

      def monsterStats(fightFound)
         #Monster stats to be used outside this method
         monsterAttack = fightFound.pet.atk
         monsterDefense = fightFound.pet.def
         monsterSpeed = fightFound.pet.spd
         monsterHealth = fightFound.mhp
         monsterMaxHealth = fightFound.pet.hp
         monsterLevel = fightFound.pet.level
         monsterValues = [monsterLevel, monsterAttack, monsterDefense, monsterSpeed, monsterHealth, monsterMaxHealth]
         return monsterValues
      end

      def battleCalculations(bStats, pStats, mStats)
         #Pet stats to be used for calculations
         petLevel = bStats[0]
         petAttack = pStats[0]
         petDefense = pStats[1]
         petSpeed = pStats[2]

         #Monster stats to be used for calculations
         monsterLevel = mStats[0]
         monsterAttack = mStats[1]
         monsterDefense = mStats[2]
         monsterSpeed = mStats[3]

         #Return the battle results
         results = `formulas/formula #{petLevel} #{petAttack} #{petDefense} #{petSpeed} #{monsterLevel} #{monsterAttack} #{monsterDefense} #{monsterSpeed}`
         string_array = results.split(",")
         return string_array
      end

      def petDamageDealt(petDamage, monsterHealth)
         #Calculate the remaining monster health
         monsterHealthLeft = monsterHealth - petDamage
         if(monsterHealthLeft < 0)
            monsterHealthLeft = 0
         end
         return monsterHealthLeft
      end

      def monsterDamageDealt(monsterDamage, petHealth)
         #Calculate the remaining pet health
         petHealthLeft = petHealth - monsterDamage
         if(petHealthLeft < 0)
            petHealthLeft = 0
         end
         return petHealthLeft
      end

      def runBattle(petHealth, monsterHealth, petDamage, monsterDamage, fightFound, petownerFound, pouchFound, bStats, mStats)
         inBattle = (petHealth > 0 && monsterHealth > 0)
         win = (petHealth > 0 && monsterHealth == 0)
         draw = (petHealth == 0 && monsterHealth == 0)
         loss = (petHealth == 0 && monsterHealth > 0)
         #Increments the current round
         fightFound.round += 1
         #Sets the hp for both pets and monsters
         fightFound.mhp = monsterHealth
         petownerFound.hp = petHealth
         fightFound.pet_hp = petHealth
         #Sets the damage for both pets and monsters
         fightFound.pdamage = petDamage
         fightFound.mdamage = monsterDamage
         if(inBattle)
            @fight = fightFound
            @petowner = petownerFound
         elsif(win)#This place needs to have petHealth added in
            petLevelUp(petownerFound, fightFound, pouchFound, bStats, mStats, petHealth)
         elsif(draw)
            petLevelUp(petownerFound, fightFound, pouchFound, bStats, mStats, petHealth)
         elsif(loss)
            fightFound.battle_done = true
            petownerFound.in_battle = false
            @petowner = petownerFound
            @fight = fightFound
         else
            raise "Something went wrong!"
         end
      end

      def statCalculations(bStats, mStats, petHealth)
         #Pass in pet level, experience, pet health and monster level
         petLevel = bStats[0]
         petExperience = bStats[6]
         monsterLevel = mStats[0]
         results = `formulas/formula #{petLevel} #{petExperience} #{petHealth} #{monsterLevel}`
         string_array = results.split(",")
         return string_array
      end

      def petLevelUp(petownerFound, fightFound, pouchFound, bStats, mStats, petHealth)
         fightFound.battle_done = true
         petownerFound.in_battle = false
         #Calculate the new stats for the pet
         statArray = statCalculations(bStats, mStats, petHealth)
         levelGained, expGained, coinsGained, attackGained, 
         defenseGained, speedGained, healthGained, 
         maxHealthGained = statArray.map { |str| str.to_i }
         levelIncrease = levelGained - petownerFound.level
         if(levelIncrease > 0)
            petownerFound.level = levelGained
            petownerFound.boost_tokens += 2
            fightFound.boost_tokens = 2
            if(petHealth > 0)
               currentHealth = petHealth + healthGained
               petownerFound.hp = currentHealth
            end
            currentMaxHealth = petownerFound.hp_max + maxHealthGained
            petownerFound.hp_max = currentMaxHealth
            currentAttack = petownerFound.atk + attackGained
            petownerFound.atk = currentAttack
            currentDefense = petownerFound.def + defenseGained
            petownerFound.def = currentDefense
            currentSpeed = petownerFound.spd + speedGained
            petownerFound.spd = currentSpeed
         end
         currentExperience = expGained + petownerFound.exp
         petownerFound.exp = currentExperience
         fightFound.exp_gained = expGained
         if(coinsGained > 0)
            fightFound.coins = coinsGained
            totalCoins = pouchFound.amount + coinsGained
            pouchFound.amount = totalCoins
            @pouch = pouchFound
            @pouch.save
         end
         @petowner = petownerFound
         @fight = fightFound
      end

      def setOptional(optional)
         @optional = optional
      end

      def switch(type)
         if(type == "index") #Guest and Admin
            optional = params[:petowner_id]
            setOptional optional
            if(getOptional)
               petownerFound = Petowner.find_by_id(optional)
               if(petownerFound)
                  petownerFights = petownerFound.fights.all
                  @fights = Kaminari.paginate_array(petownerFights).page(params[:page]).per(10)
                  @petowner = petownerFound
               else
                  render "public/404"
               end
            else
               logged_in = current_user
               if(logged_in)
                  if(logged_in.admin)
                     allFights = Fight.order("id").page(params[:page]).per(10)
                     @fights = allFights
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            end
         elsif(type == "show") #Guest access
            fightFound = Fight.find_by_id(params[:id])
            if(fightFound)
               petownerFound = Petowner.find_by_id(fightFound.petowner_id)
               if(petownerFound)
                  petFound = Pet.find_by_id(fightFound.pet_id)
                  @fight = fightFound
                  @petowner = petownerFound
                  @pet = petFound
               else
                  redirect_to root_path
               end
            else
               render "public/404"
            end
         elsif(type == "create") #Login only and the same user
            logged_in = current_user
            if(logged_in)
               petchosen = params[:selectedpet][:petowner_id]
               petownerFound = Petowner.find_by_id(petchosen)
               if(petownerFound)
                  petFound = Pet.find_by_id(params[:pet_id])
                  if(petFound)
                     userMatch = (petownerFound.user_id == logged_in.id)
                     if(userMatch)
                        newFight = petownerFound.fights.new(params[:fight])
                        newFight.petowner_id = petownerFound.id
                        newFight.pet_id = petFound.id
                        newFight.mhp = petFound.hp
                        #Stores the pets current values for the fight
                        newFight.pet_hp = petownerFound.hp
                        newFight.level = petownerFound.level
                        newFight.exp = petownerFound.exp
                        newFight.hp = petownerFound.hp_max
                        newFight.atk = petownerFound.atk
                        newFight.def = petownerFound.def
                        newFight.spd = petownerFound.spd
                        petownerFound.in_battle = true
                        @fight = newFight
                        if(@fight.save)
                           @petowner = petownerFound
                           @petowner.save
                           redirect_to petowner_fight_path(@petowner, @fight)
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
         elsif(type == "destroy") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  fightFound = Fight.find_by_id(params[:id])
                  if(fightFound)
                     petownerFound = Petowner.find_by_id(fightFound.petowner_id)
                     if(petownerFound)
                        petownerFound.in_battle = false
                        @fight = fightFound
                        @petowner = petownerFound
                        @fight.destroy
                        @petowner.save
                        redirect_to petowner_fights_path(@petowner)
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
         elsif(type == "battle") #Login only and same user
            logged_in = current_user
            if(logged_in)
               fightFound = Fight.find_by_id(params[:id])
               if(fightFound)
                  petownerFound = Petowner.find_by_id(fightFound.petowner_id)
                  if(petownerFound)
                     userMatch = (logged_in.id == petownerFound.user_id)
                     if(userMatch)
                        pouchFound = Pouch.find_by_id(logged_in.id)
                        #Get the pets stats
                        bStats = baseStats(petownerFound, fightFound.pet_hp)
                        eStats = petEquipment(petownerFound)
                        mStats = monsterStats(fightFound)
                        pStats = enhancedStats(bStats, eStats)
                        #Calculate the damage dealt
                        damageArray = battleCalculations(bStats, pStats, mStats)
                        petDamage, monsterDamage = damageArray.map { |str| str.to_i }
                        monsterHealth = petDamageDealt(petDamage, mStats[4])
                        petHealth = monsterDamageDealt(monsterDamage, bStats[4])
                        #Determine if the battle is still going on
                        runBattle(petHealth, monsterHealth, petDamage, monsterDamage, fightFound,petownerFound, pouchFound, bStats, mStats)
                        if(@fight.save)
                           @petowner.save
                           redirect_to petowner_fight_path(@petowner, @fight)
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
