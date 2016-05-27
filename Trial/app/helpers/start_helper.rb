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
      def getOnline
         allUsers = Sessionkey.all
         onlineUsers = allUsers.select{|key| key.remember_token != "NULL"}
         value = onlineUsers.count
         return value
      end

      def getOffline
         allUsers = Sessionkey.all
         offlineUsers = allUsers.select{|key| key.remember_token == "NULL"}
         value = offlineUsers.count
         return value
      end

      def getTotal
         allUsers = Sessionkey.all
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
         return value
      end

      def getMonthSignups
         allUsers = User.all
         currentTime = Time.now
         month = allUsers.select{|user| (currentTime - user.joined_on) <= 1.month}
         value = month.count
         return value
      end

      def getYearSignups
         allUsers = User.all
         currentTime = Time.now
         year = allUsers.select{|user| (currentTime - user.joined_on) <= 1.year}
         value = year.count
         return value
      end

      def switch(type)
         if(type == "home") #Guest
         end
      end
end
