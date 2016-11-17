class UserMailer < ActionMailer::Base
   default from: "do-not-reply@duelingpets.net"

   def welcome_email(user, token)
      @accounttoken = token
      @user = user
      @url = "http://www.duelingpets.net/signin"
      mail(to: @user.email, subject: "Welcome to the World of Duelingpets")
   end
#   'notifications@example.com'

   def recover_account(user, token)
      @user = user
      @passwordtoken = token
      @url = "http://www.duelingpets.net/signin"
      mail(to: @user.email, subject: "Password Recovery System", from: "recovery@duelingpets.net")
   end

   def send_message(comment)
      @comment = comment
      @url = "http://www.duelingpets.net/users/#{@comment.to_user.vname}"
      if(@comment.to_user.vname != @comment.from_user.vname)
         mail(to: comment.to_user.email, subject: "A New Comment has arrived at the Palace")
      end
   end

   def send_pm(pm)
      @pm = pm
      @url = "http://www.duelingpets.net/pms/inbox"
      if(@pm.to_user.vname != @pm.from_user.vname)
         mail(to: pm.to_user.email, subject: "A New PM has arrived at the Palace")
      end
   end

   def send_preply(preply)
      @preply = preply
      @url = "http://www.duelingpets.net/pms/inbox"
      owner = @preply.user.vname
      reciever = @preply.pm.to_user.vname
      sender = @preply.pm.from_user.vname
      
      if(sender != reciever)
         emailUser = nil
         if(owner == sender)
            emailUser = @preply.pm.to_user.email
         end
         if(owner == reciever)
            emailUser = @preply.pm.from_user.email
         end
         if(emailUser != nil)
            mail(to: emailUser, subject: "A New PReply has arrived at the Palace")
         end
      end
   end

   def referral_received(referral, points)
      @referral = referral
      @points = points
      @url = "http://www.duelingpets.net/referrals"
      mail(to: referral.referrer.email, "Congratulations you Referred a New User"
   end
end
