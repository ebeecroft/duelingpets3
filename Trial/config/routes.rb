Trial::Application.routes.draw do

   #Builds the users actions and the nested actions
   get '/users/maintenance' => 'users#maintenance'
   resources :users, :except => [:new] do #builds everything except new
#      get '/:id/page/:page', :action => :index, :on => :collection
      resources :petowners #Builds everything
      resources :inventories, :only =>[:index, :create, :destroy] #Builds only index, create, destroy
      resources :comments, :only => [:create, :destroy] #Builds only create and destroy
      resources :forums #Builds everything 
      resources :sbooks #Builds everything
      resources :mainfolders #Builds everything
      resources :blogs #Builds everything
      resources :pets, :except =>[:index, :show, :new, :create, :edit, :update, :destroy]
   end

   #Builds the blogs
   get '/blogs/maintenance' => 'blogs#maintenance'
   get 'blogs/list' => 'blogs#list'
   resources :blogs, :only =>[:index] do
      resources :replies, :except =>[:index, :show]
   end

   #Builds the replies
   get '/replies/maintenance' => 'replies#maintenance'
   resources :replies, :only =>[:index]

   #Builds the mainfolders
   get '/mainfolders/maintenance' => 'mainfolders#maintenance'
   get 'mainfolders/list' => 'mainfolders#list'
   resources :mainfolders, :only =>[:index] do #Only index
      resources :subfolders, :except =>[:index] #Everything except index
   end

   #Builds the subfolders
   get '/subfolders/maintenance' => 'subfolders#maintenance'
   resources :subfolders, :only =>[:index] do #Only index
      resources :artworks, :except =>[:index] #Everything except index
   end

   #Builds the artworks
   get '/artworks/maintenance' => 'artworks#maintenance'
   get '/artworks/review' => 'artworks#review' #has to be before the pets controller
   post 'artworks/review1' => 'artworks#approve'
   post 'artworks/review2' => 'artworks#deny'
   resources :artworks, :only =>[:index] #Only index

   #Builds the series
   get '/sbooks/maintenance' => 'sbooks#maintenance'
   get 'sbooks/list' => 'sbooks#list'
   resources :sbooks, :only =>[:index] do #Only index
      resources :books, :except =>[:index] #Everything except index
   end
#get '/:id/page/:page', :action => :show, :on => :collection

   #Builds the books
   get '/books/maintenance' => 'books#maintenance'
   resources :books, :only =>[:index] do #Only index
      resources :chapters, :except =>[:index, :show] #everything except index and show
   end

   #Builds the chapters
   get '/chapters/maintenance' => 'chapters#maintenance'
   get 'chapters/review' => 'chapters#review'
   post 'chapters/review1' => 'chapters#approve'
   post 'chapters/review2' => 'chapters#deny'
   resources :chapters, :only =>[:index] #Only index
   resources :gchapters, :only =>[:index] #Only index

   #Comments actions
   resources :comments, :only =>[:index] #Only index

   #Suggestion box for users
   resources :suggestions, :except =>[:show, :edit, :update] #Everything except edit, update, and show

   #Inventory routes
   get '/inventories/maintenance' => 'inventories#maintenance'
   resources :inventories, :only =>[:index] #Only index

   #Money Bag
   resources :pouches, :only =>[:index] #Only index

   #Builds the pet actions
   get '/pets/maintenance' => 'pets#maintenance'
   get '/pets/list' => 'pets#list'
   get '/pets/review' => 'pets#review' #has to be before the pets controller
   get '/pets/monsters' => 'pets#monsters'

   #Accept and deny if both post actions then we need '/pets/reviews/accept or /pets/reviews/deny'
   post 'pets/review1' => 'pets#approve'
   post 'pets/review2' => 'pets#deny'

   #Base pets route
   resources :pets, :except =>[:index, :show, :new, :create, :edit, :update, :destroy] #Builds everything for pets

   #Builds the item actions
   get '/items/maintenance' => 'items#maintenance'
   resources :items #Builds everything for items

   #Builds the equips and fights actions
   post 'petowners/increase1' => 'petowners#health'
   post 'petowners/increase2' => 'petowners#attack'
   post 'petowners/increase3' => 'petowners#defense'
   post 'petowners/increase4' => 'petowners#speed'
   get '/petowners/maintenance' => 'petowners#maintenance'
   resources :petowners, :only =>[:index] do #Prevents building the petowners routes #Only index
      resources :equips, :only =>[:index, :create, :destroy] #Only builds index, create and destroy
      resources :fights, :except =>[:new, :edit, :update] #Builds everything except new, edit, and update
   end

   #Builds fights path
   get '/fights/maintenance' => 'fights#maintenance'
   post '/petowners/:petowner_id/fights/:id' => 'fights#battle'
   resources :fights, :only =>[:index] #Only index

   #Builds equips path
   get '/equips/maintenance' => 'equips#maintenance'
   resources :equips, :only =>[:index] #Only index

   #Builds the forum index page and nested routes
   get '/forums/maintenance' => 'forums#maintenance'
   get '/forums/list' => 'forums#list'
   resources :forums, :only =>[:index] do #Only index
      resources :tcontainers, :except =>[:index] #Builds everything but index
   end

   #Builds the container for the topics and the nested routes
   get '/tcontainers/maintenance' => 'tcontainers#maintenance'
   resources :tcontainers, :only =>[:index] do #Only index
      resources :maintopics, :except =>[:index] #Builds everything except index
   end

   #Build the forum maintopics actions and the nested actions
   get '/maintopics/maintenance' => 'maintopics#maintenance'
   resources :maintopics, :only =>[:index] do #Only index
      resources :subtopics, :except =>[:index] #Builds everything except index
   end

   #Builds the forum narratives actions
   get '/subtopics/maintenance' => 'subtopics#maintenance'
   resources :subtopics, :only =>[:index] do #Prevents building the subtopics routes #Only index
      resources :narratives, :except =>[:index, :show] #Builds everything except index and show
   end

   #Builds the narrative routes
   get '/narratives/maintenance' => 'narratives#maintenance'
   resources :narratives, :only =>[:index] #Only index

   #Creates the user connection to the website
   resources :sessions, :only =>[:create] #Only create

   #Creates the recovery routes
   resources :passwordrecoveries, :only =>[:create] #Only create

   #Login pages + user signup
   get '/recover' => 'passwordrecoveries#new'
   get '/signup' => 'users#new'
   get '/signin' => 'sessions#new'
   match '/logout' => 'sessions#destroy', via: :delete #has to be a match condition

   #Builds the sessionkey
   resources :sessionkeys, :only =>[:index] #Only index

   #Builds the staff
   resources :usertypes, :except =>[:show, :destroy] #Only builds index, new, create, edit and update actions

   #Builds the user status
   resources :onlineusers, :only =>[:index, :new, :create]

   #Controls page visibility
   resources :maintenancemodes, :except =>[:show, :destroy] #Builds everything except show and destroy

   #Root pages
   get 'maintenance' => "start#maintenance"
   root :to => "start#home"
end
