namespace :db do
   task populate: :environment do
      #Builds Basic container
      basics = Tcontainer.create!(name: "Basics")
      basics.forum_id = 1
      basics.user_id = 3
      basics.save

      #Builds Misc container
      misc = Tcontainer.create!(name: "Misc")
      misc.forum_id = 1
      misc.user_id = 3
      misc.save
   end
end
