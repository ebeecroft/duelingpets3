class SoundMailer < ActionMailer::Base
   default from: "notification@duelingpets.net"

   def review_sound(sound)
      @sound = sound
      @url = "http://www.duelingpets.net/sounds/review"
      allUsers = Usertype.all
      reviewers = allUsers.select{|user| user.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, subject: "New Audio Awaiting Review")
         end
      end
   end

   def sound_approved(sound, points)
      @sound = sound
      @points = points
      @url = "http://www.duelingpets.net/subsheets/#{@sound.subsheet_id}/sounds/#{@sound.id}"
      mail(to: sound.user.email, subject: "Your Audio was Approved")
   end

   def sound_denied(sound)
      @sound = sound
      @url = "http://www.duelingpets.net/subsheets/#{@sound.subsheet_id}/sounds/#{@sound.id}"
      mail(to: sound.user.email, subject: "Your Audio was Denied")
   end
end
