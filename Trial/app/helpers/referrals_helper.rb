module ReferralsHelper

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

   def getOptional
      @optional
   end

   private
      def getStatus(user)
         status = "Offline"
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(onlineUserFound.signed_in_at)
            if(!onlineUserFound.signed_out_at)
               if(onlineUserFound.last_visited == nil)
                  status = "Online"
               else
                  if((currentTime - onlineUserFound.last_visited) > 30.minutes)
                     status = "Inactive"
                  else
                     status = "Online"
                  end
               end
            else
               status = "Offline"
            end
         end
         return status
      end

      def getTime(user, status)
         value = ""
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(status == "Inactive")
            value = onlineUserFound.last_visited
         else
            value = onlineUserFound.signed_out_at
         end
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

      def setOptional(optional)
         @optional = optional
      end

      def switch(type)
         if(type == "index") #Logged in
            logged_in = current_user
            if(logged_in)
               optional = params[:user_id]
               setOptional optional
               if(getOptional)
                  userFound = User.find_by_vname(optional)
                  if(userFound)
                     userReferrals = userFound.referrals.order("created_on desc")
                     @referrals = Kaminari.paginate_array(userReferrals).page(params[:page]).per(10)
                     @user = userFound
                  else
                     render "public/404"
                  end
               else
                  allReferrals = Referral.order("created_on desc").page(params[:page]).per(10)
                  @referrals = allReferrals
               end
            else
               redirect_to root_path
            end
         elsif(type == "new") #Logged in
            logged_in = current_user
            if(logged_in)
               allReferrals = Referral.all
               referralFound = allReferrals.select{|referral| referral.user_id == logged_in.id}
               if(referralFound.count > 0)
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Logged in
            logged_in = current_user
            if(logged_in)
               allReferrals = Referral.all
               referralFound = allReferrals.select{|referral| referral.user_id == logged_in.id}
               if(referralFound.count > 0)
                  redirect_to root_path
               else
                  referreeFound = User.find_by_vname(params[:session][:vname].downcase)
                  if(referreeFound)
                     newReferral = Referral.new(params[:referral])
                     currentTime = Time.now
                     newReferral.created_on = currentTime
                     newReferral.user_id = logged_in.id
                     newReferral.referred_by_id = referreeFound.id
                     #Gives the referred user some points that they can use
                     pointsForReferrals = 43
                     referreePouch = Pouch.find_by_user_id(referreeFound.id)
                     referreePouch.amount += pointsForReferrals
                     @pouch = referreePouch
                     @pouch.save
                     @referral = newReferral
                     if(@referral.save)
                        flash[:success] = "Referral #{@referral.referre.vname} was successfully created."
                        UserMailer.referral_received(@referral, pointsForReferrals).deliver
                        redirect_to root_path
                     end
                  else
                     render "new"
                  end
               end
            else
               redirect_to root_path
            end
         end
      end
end
