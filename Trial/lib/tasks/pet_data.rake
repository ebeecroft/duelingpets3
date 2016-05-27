namespace :db do
   task populate: :environment do
      image_location = "/home/eric/Projects/Local/Gallery/pets"

      #Builds the pet species Rooling
      rooling = Pet.create!(species_name: "Rooling",
                          description: "A happy roo that bounces around in the forest as it hops on its large feet",
                          image: File.open(File.join(image_location, 'Kangaroo_pictureEdit.png')),
                          hp: 6,
                          atk: 1,
                          def: 1,
                          spd: 2,
                          monster: false)
      rooling.level = 2
      rooling.cost = 63
      rooling.user_id = 2
      rooling.created_on = Time.now
      rooling.toggle!(:reviewed)
      rooling.toggle!(:starter)
      rooling.save

      #Builds the pet species Hooty
      hooty = Pet.create!(species_name: "Hooty",
                          description: "A creature that hoots at the moon during a dark night",
                          image: File.open(File.join(image_location, 'owl.jpg')),
                          hp: 6,
                          atk: 1,
                          def: 2,
                          spd: 1,
                          monster: false)
      hooty.level = 2
      hooty.cost = 61
      hooty.user_id = 2
      hooty.created_on = Time.now
      hooty.toggle!(:reviewed)
      hooty.toggle!(:starter)
      hooty.save

      #Builds the pet species Stalk
      stalk = Pet.create!(species_name: "Stalk",
                          description: "A cat that roams the great jungle. It's eyes are as ferocious as its sharp teeth. Watch out for this one",
                          image: File.open(File.join(image_location, 'tiger.jpg')),
                          hp: 6,
                          atk: 2,
                          def: 1,
                          spd: 1,
                          monster: false)
      stalk.level = 2
      stalk.cost = 62
      stalk.user_id = 2
      stalk.created_on = Time.now
      stalk.toggle!(:reviewed)
      stalk.toggle!(:starter)
      stalk.save
   end
end
