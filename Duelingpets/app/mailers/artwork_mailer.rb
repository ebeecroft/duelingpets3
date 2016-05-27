class ArtworkMailer < ActionMailer::Base
   default from: "notification@duelingpets.net"

   def review_artwork(artwork)
      @artwork = artwork
      @url = "http://www.duelingpets.net/artworks/review"
      allUsers = Usertype.all
      reviewers = allUsers.select{|user| user.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, subject: "New Artwork Awaiting Review")
         end
      end
   end

   def artwork_approved(artwork, points)
      @artwork = artwork
      @points = points
      @url = "http://www.duelingpets.net/subfolders/#{@artwork.subfolder_id}/artworks/#{@artwork.id}"
      mail(to: artwork.user.email, subject: "Your Artwork was Approved")
   end

   def artwork_denied(artwork)
      @artwork = artwork
      @url = "http://www.duelingpets.net/subfolders/#{@artwork.subfolder_id}/artworks/#{@artwork.id}"
      mail(to: artwork.user.email, subject: "Your Artwork was Denied")
   end
end
