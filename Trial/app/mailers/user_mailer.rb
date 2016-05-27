class UserMailer < ActionMailer::Base
   default from: "do-not-reply@duelingpets.net"

   def welcome_email(user)
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
end
