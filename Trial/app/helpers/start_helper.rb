module StartHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         maintenancemode = Maintenancemode.find_by_id(1)
         if(maintenancemode.maintenance_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
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
      def registrationStatus
         maintenancemode = Maintenancemode.find_by_id(2)
         status = ""
         if(maintenancemode.maintenance_on)
            status = "Closed"
         end
         return status
      end
      def getOnline
         allUsers = Onlineuser.all
#         @onlineusers = allUsers
#         fresh_when @onlineusers.maximum(:created_at)
         onlineUsers = allUsers.select{|status| status.signed_in_at != nil && status.signed_out_at == nil}
         inactiveTime = 30.minutes
         activeUsers = onlineUsers.select{|status| status.last_visited == nil || (status.last_visited != nil && (currentTime - status.last_visited) < inactiveTime)}
#         @onlineusers = onlineUsers
#         fresh_when last_modified: @onlineusers
         value = activeUsers.count
         return value
      end

      def getInactive
         allUsers = Onlineuser.all
         onlineUsers = allUsers.select{|status| status.signed_in_at != nil && status.signed_out_at == nil}
         inactiveTime = 30.minutes
         inactiveUsers = onlineUsers.select{|status| status.last_visited != nil && ((currentTime - status.last_visited) > inactiveTime)}
         value = inactiveUsers.count
         return value
      end

      def getOffline
         allUsers = Onlineuser.all
         offlineUsers = allUsers.select{|status| status.signed_in_at == nil || (status.signed_in_at != nil && status.signed_out_at != nil)}
         value = offlineUsers.count
         return value
      end

      def getTotal
         allUsers = Onlineuser.all
         total = allUsers.count
         return total
      end

      def getDaySignups
         allUsers = User.all
         currentTime = Time.now
         day = allUsers.select{|user| (currentTime - user.joined_on) <= 1.day}
         value = day.count
         return value
      end

      def getWeekSignups
         allUsers = User.all
         currentTime = Time.now
         week = allUsers.select{|user| (currentTime - user.joined_on) <= 1.week}
         value = week.count
         signups = value - getDaySignups
         return signups
      end

      def getMonthSignups
         allUsers = User.all
         currentTime = Time.now
         month = allUsers.select{|user| (currentTime - user.joined_on) <= 1.month}
         value = month.count
         signups = value - getWeekSignups - getDaySignups
         return signups
      end

      def getYearSignups
         allUsers = User.all
         currentTime = Time.now
         year = allUsers.select{|user| (currentTime - user.joined_on) <= 1.year}
         value = year.count
         signups = value - getMonthSignups - getWeekSignups - getDaySignups
         return signups
      end

      def tutorial
         user_forum_path("forumowner", "tutorial")
      end

      def switch(type)
         if(type == "home") #Guest
         elsif(type == "sitemap") #Guest
         elsif(type == "active") #Login only
            logged_in = current_user
            if(logged_in)
               allUsers = Onlineuser.all
               onlineUsers = allUsers.select{|status| status.signed_in_at != nil && status.signed_out_at == nil}
               inactiveTime = 30.minutes
               activeUsers = onlineUsers.select{|status| status.last_visited == nil || (status.last_visited != nil && (currentTime - status.last_visited) < inactiveTime)}
               @onlineusers = Kaminari.paginate_array(activeUsers).page(params[:page]).per(10)
            else
               redirect_to root_path
            end
         end
      end
end
