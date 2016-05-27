namespace :db do
   task populate: :environment do
      admin = User.create!(first_name: "Monty",
                           last_name: "Mole",
                           email: "mmole@funhill.com",
                           vname: "mmole",
                           password: "Mole12",
                           password_confirmation: "Mole12")
      admin.toggle!(:admin)
   end
end
