namespace :db do
   task populate: :environment do
      #Admin
      admin = Usertype.create!(privilege: "Admin", user_id: 1)
      admin.save

      #Pet Creator
      creator = Usertype.create!(privilege: "User", user_id: 2)
      creator.save

      #Forum Owner
      owner = Usertype.create!(privilege: "User", user_id: 3)
      owner.save
   end
end
