namespace :db do
   task populate: :environment do
      #Admin
      adminkey = Sessionkey.create!
      adminkey.user_id = 1
      adminkey.remember_token = "NULL"
      adminkey.save

      #Pet Creator
      creatorkey = Sessionkey.create!
      creatorkey.user_id = 2
      creatorkey.remember_token = "NULL"
      creatorkey.save

      #Forum Owner
      ownerkey = Sessionkey.create!
      ownerkey.user_id = 3
      ownerkey.remember_token = "NULL"
      ownerkey.save
   end
end
