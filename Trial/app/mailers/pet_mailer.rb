class PetMailer < ActionMailer::Base
   default from: "notification@duelingpets.net"

   def review_pet(pet)
      @pet = pet
      @url = "http://www.duelingpets.net/pets/review"
      allUsers = Usertype.all
      reviewers = allUsers.select{|user| user.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, subject: "New Pet Awaiting Review")
         end
      end
   end

   def pet_approved(pet, points)
      @pet = pet
      @points = points
      @url = "http://www.duelingpets.net/users/#{@pet.user.vname}/pets/#{@pet.species_name}"
      mail(to: pet.user.email, subject: "Your Pet was Approved")
   end

   def pet_denied(pet)
      @pet = pet
      @url = "http://www.duelingpets.net/users/#{@pet.user.vname}/pets/#{@pet.species_name}/edit"
      mail(to: pet.user.email, subject: "Your Pet was Denied")
   end
end
