namespace :db do
   task populate: :environment do
      tutorial = Forum.create!(name: "Tutorial",
                           description: "This is a tutorial forum to teach new users how to build build a forum on their own. Users should pay careful attention to the instruction if they wish to master the new system.")
      tutorial.user_id = 3
      tutorial.save
   end
end
