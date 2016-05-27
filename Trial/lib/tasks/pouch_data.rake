namespace :db do
   task populate: :environment do
      #Admin
      adminmoney = Pouch.create!
      adminmoney.user_id = 1
      adminmoney.amount = 200
      adminmoney.save

      #Pet Creator
      creatormoney = Pouch.create!
      creatormoney.user_id = 2
      creatormoney.amount = 200
      creatormoney.save

      #Forum Owner
      ownermoney = Pouch.create!
      ownermoney.user_id = 3
      ownermoney.amount = 200
      ownermoney.save
   end
end
