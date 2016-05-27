module CusersHelper
#A current user helper

   #Mandatory
   def expires
      keyFound = Sessionkey.find_by_user_id(current_user.id)
      @sessionkey = keyFound.expiretime
   end

   #Mandatory
   def currentTime
      Time.now
   end

   #Mandatory
   def sign_in(user)
      #We know what the user is right here
      keyFound = Sessionkey.find_by_user_id(user.id)

      #Set Variables
      token = SecureRandom.urlsafe_base64
      keyFound.remember_token = token

      #Set variable 2
      expireTime = 2.days.from_now.utc
      keyFound.expiretime = expireTime
      tokenTime = expireTime + 1.month

      @sessionkey = keyFound
      @sessionkey.save

      cookies[:remember_token] = { :value => keyFound.remember_token, :expires => tokenTime } #The working solution now
      self.current_user = user
   end

   #Mandatory
   def current_user=(user) #sets the current_user to the user's value
      @current_user = user
   end

   #Mandatory
   def current_user #Sets the current_user if it is nil
      #This structure needs to change
      tokenFound = cookies[:remember_token]
      if(tokenFound)
         key = Sessionkey.find_by_remember_token(cookies[:remember_token])
         @current_user ||= User.find_by_id(key.user_id)
      else
         @current_user
      end
#      @current_user ||= User.find_by_remember_token(cookies[:remember_token])
   end

   #Mandatory
   def sign_out
      flash[:success] = "#{current_user.vname} was logged out"
      self.current_user = nil

      #Remove old sessionkey
      keyFound = Sessionkey.find_by_user_id(current_user.id)
      keyFound.remember_token = "NULL"
      keyFound.expiretime = nil
      @sessionkey = keyFound
      @sessionkey.save

      #Delete cookie last
      cookies.delete(:remember_token)
   end

   #View only
   def timeleft
      if(current_user)
         if(expires)
            render "layouts/timeleft"
         end
      end
   end

   #Controller only
   def auto_logout
      if(current_user)
         if(expires.nil?) #Never happens
            return true
         else
            expired = currentTime >= expires
            if(expired)
               return true
            else
               return false
            end
         end
      end
   end

   #Move these to a different helper
   def profile
      if(current_user)
         render 'layouts/loggedin'
      else
         render "layouts/guest"
      end
   end

   def getSymbol
      value = "NULL"
      if(current_user.admin)
         value = "$"
      else
         type = current_user.usertype.privilege
         if(type == "Reviewer")
            value = "^"
         elsif(type == "Banned")
            value = "!"
         else
            value = "~"
         end
      end
      return value
   end
end
