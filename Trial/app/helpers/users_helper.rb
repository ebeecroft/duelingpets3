module UsersHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         usermode = Maintenancemode.find_by_id(2)
         mode_turned_on = (allmode.maintenance_on || usermode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to users_maintenance_path
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
      def getAgeGroup(userFound)
         group = ""
         string_array = userFound.birthday.split("/")
         month, day, year = string_array.map { |str| str.to_i}
         value1 = month / 12
         value2 = day / 365
         value3 = year + value1 + value2
         #convertedValue = value3.to_datetime
         currentTime = Time.now.to_i
#         string_array2 = currentTime.split("-")
#         year2, month2, day2 = string_array2.map { |str| str.to_i}
#         value4 = month2 / 12
#         value5 = day / 365
#         value6 = year2 + value5 + value4
#         value4 = (currentTime - convertedValue)
         #raise "Current value 4 is: #{value4}"
         age = currentTime - value3 #(value6 - value3)
         if(age >= 7 && age <= 10)
            group = "Newborn"
         elsif(age >= 11 && age <= 14)
            group = "Toddler"
         elsif(age >= 15 && age <= 18)
            group = "Kid"
         elsif(age >= 19 && age <= 22)
            group = "Teen"
         elsif(age >= 23 && age <= 26)
            group = "Young Adult"
         elsif(age > 26)
            group = "Adult"
         else
            group = "Underaged"
         end
         return group
      end

      def getAge(userFound)
         currentTime = Time.now
         age = 10
         if(userFound.birthday)
            string_array = userFound.birthday.split("/")
            month, day, year = string_array.map { |str| str.to_i}
            value = year
            age = userFound.birthday 
            #petCost, petLevel = string_array.map { |str| str.to_i}
            #Need to split on slashes and dash 
            #age = (currentTime - userFound.birthday) / 1.year #currentTime - userFound.birthday
         end
         return age
      end

      def getAvatar(userFound)
         currentAvatar = "No avatar available"
         avatarFound = userFound.avatar_url(:thumb)
         if(avatarFound)
            currentAvatar = avatarFound
         end
         return currentAvatar
      end

      def getStatus(user)
         status = "Offline"
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(onlineUserFound.signed_in_at)
            if(!onlineUserFound.signed_out_at)
               status = "Online"
            else
               status = "Offline"
            end
         end
         return status
      end

      def getTime(user)
         value = ""
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         #if(getStatus(onlineUserFound) != "Online")
            value = onlineUserFound.signed_out_at
         #end
         return value
      end

      def getCreated
         allPets = Pet.all
         userPets = allPets.select{|pet| pet.user_id == @user.id}
         value = userPets.count
         return value
      end

      def getOwned
         value = @user.petowners.count
         return value
      end

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
                  @users = User.order("id").page(params[:page]).per(10)
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "show") #Guest access
            userFound = User.find_by_vname(params[:id])
            if(userFound)
               @pouch = Pouch.find_by_id(userFound.id)
               commentCount = 0 #May remove this variable in a later build
               allComments = Comment.all
               userComments = allComments.select{|comment| comment.user_id == userFound.id}
               @comments = Kaminari.paginate_array(userComments).page(params[:page]).per(10)
               commentCount = userComments.count
               @pcount = userFound.petowners.count
               @fcount = userFound.forums.count
               @scount = userFound.sbooks.count
               @gcount = userFound.mainfolders.count
               @ccount = commentCount
               @bcount = userFound.blogs.count
               @rcount = userFound.mainsheets.count
               onlineUserFound = Onlineuser.find_by_user_id(userFound.id) #Ignore this for right now
               @onlineuser = onlineUserFound
               allPm = Pm.all
               outbox = allPm.select{|pm| pm.from_user_id == userFound.id}
               inbox = allPm.select{|pm| pm.user_id == userFound.id}
               @pmtcount = (inbox.count + outbox.count)
               @pmicount = inbox.count
               @pmocount = outbox.count
               @user = userFound
            else
               render "public/404"
            end
         elsif(type == "new") #Guest access
            @user = User.new
         elsif(type == "create") #Guest access
            newMember = User.new(params[:user])
            currentTime = Time.now
            newMember.joined_on = currentTime
            @user = newMember
            if(@user.save)
               #Create the pouch
               newPouch = Pouch.new(params[:pouch])
               newPouch.user_id = newMember.id
               @pouch = newPouch
               @pouch.save
               #Create the key
               newKey = Sessionkey.new(params[:sessionkey])
               newKey.remember_token = "NULL"
               newKey.user_id = newMember.id
               @sessionkey = newKey
               @sessionkey.save
               #Create usertype
               newUserType = Usertype.new(params[:usertype])
               newUserType.user_id = newMember.id
               newUserType.privilege = "Review"
               @usertype = newUserType
               @usertype.save
               #Create onlineuser
               newOnlineUser = Onlineuser.new(params[:onlineuser])
               newOnlineUser.user_id = newMember.id
               #newOnlineUser.signed_in_at = currentTime
               @onlineuser = newOnlineUser
               @onlineuser.save
               #Create accountkey
               newAccountKey = Accountkey.new(params[:accountkey])
               newAccountKey.token = SecureRandom.urlsafe_base64
               newAccountKey.user_id = newMember.id
               @accounttoken = newAccountKey.token
               @accountkey = newAccountKey
               @accountkey.save
               #newAccountKey.exx
               #Login the user
               #sign_in newMember
               flash[:success] = "Welcome to the Duelingpets Website #{@user.vname}!"
               UserMailer.welcome_email(@user, @accounttoken).deliver
               redirect_to @user
            else
               render "new"
            end
         elsif(type == "edit") #Login only and same user
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:id])
               if(userFound)
                  userMatch = ((logged_in.id == userFound.id) || logged_in.admin)
                  if(userMatch)
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
         elsif(type == "update") #Login only and same user
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:id])
               if(userFound)
                  userMatch = ((logged_in.id == userFound.id) || logged_in.admin)
                  if(userMatch)
                     @user = userFound
                     if(@user.update_attributes(params[:user]))
                        if(!logged_in.admin || logged_in == userFound)
                           sign_in @user
                        end
                        flash[:success] = 'User was successfully updated.'
                        redirect_to @user
                        #redirect_to @user, notice: 'User was successfully updated.'
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
         elsif(type == "destroy") #Admin only
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:id])
               if(userFound)
                  if(logged_in.admin)
                     if(!userFound.admin)
                        @user = userFound
                        @user.destroy
                        flash[:success] = 'User was successfully removed.'
                        redirect_to users_url
                        #redirect_to users_url, notice: 'User was successfully removed.'
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
