namespace :db do
   task populate: :environment do
      #All
      allmode = Maintenancemode.create!(name: "All")
      allmode.created_on = Time.now
      allmode.save

      #Users
      usersmode = Maintenancemode.create!(name: "Users")
      usersmode.created_on = Time.now
      usersmode.save

      #Pets
      petsmode = Maintenancemode.create!(name: "Pets")
      petsmode.created_on = Time.now
      petsmode.save

      #Petowners
      petownersmode = Maintenancemode.create!(name: "Petowners")
      petownersmode.created_on = Time.now
      petownersmode.save

      #Fights
      fightsmode = Maintenancemode.create!(name: "Fights")
      fightsmode.created_on = Time.now
      fightsmode.save

      #Items
      itemsmode = Maintenancemode.create!(name: "Items")
      itemsmode.created_on = Time.now
      itemsmode.save

      #Inventories
      inventoriesmode = Maintenancemode.create!(name: "Inventories")
      inventoriesmode.created_on = Time.now
      inventoriesmode.save

      #Equips
      equipsmode = Maintenancemode.create!(name: "Equips")
      equipsmode.created_on = Time.now
      equipsmode.save

      #Forums
      forumsmode = Maintenancemode.create!(name: "Forums")
      forumsmode.created_on = Time.now
      forumsmode.save

      #Tcontainers
      tcontainersmode = Maintenancemode.create!(name: "Tcontainers")
      tcontainersmode.created_on = Time.now
      tcontainersmode.save

      #Maintopics
      maintopicsmode = Maintenancemode.create!(name: "Maintopics")
      maintopicsmode.created_on = Time.now
      maintopicsmode.save

      #Subtopics
      subtopicsmode = Maintenancemode.create!(name: "Subtopics")
      subtopicsmode.created_on = Time.now
      subtopicsmode.save

      #Narratives
      narrativesmode = Maintenancemode.create!(name: "Narratives")
      narrativesmode.created_on = Time.now
      narrativesmode.save

      #Sbooks
      sbooksmode = Maintenancemode.create!(name: "Sbooks")
      sbooksmode.created_on = Time.now
      sbooksmode.save

      #Books
      booksmode = Maintenancemode.create!(name: "Books")
      booksmode.created_on = Time.now
      booksmode.save

      #Chapters
      chaptersmode = Maintenancemode.create!(name: "Chapters")
      chaptersmode.created_on = Time.now
      chaptersmode.save
   end
end
