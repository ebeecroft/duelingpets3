module BooksHelper

   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         bookmode = Maintenancemode.find_by_id(15)
         mode_turned_on = (allmode.maintenance_on || bookmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to books_maintenance_path
               end
            else
               switch type
            end
         else
            switch type
         end
      end
   end

   private
      def getType(user)
         if(user.admin)
            value = "$"
         else
            typeFound = Usertype.find_by_user_id(user.id)
            if(typeFound)
               type = typeFound.privilege
               if(type == "Reviewer")
                  value = "^"
               elsif(type == "Banned")
                  value = "!"
               else
                  value = "~"
               end
            else
               value = "~"
            end
         end
         return value
      end

      def storeBook(sbookFound, logged_in)
         newBook = sbookFound.books.new(params[:book])
         currentTime = Time.now
         newBook.created_on = currentTime
         newBook.sbook_id = sbookFound.id
         newBook.user_id = logged_in.id
         #These two fields need to exist prior to saving
         @book = newBook
         @sbook = sbookFound
         if(@book.save)
            flash[:success] = 'Book was successfully created.'
            redirect_to sbook_book_path(@sbook, @book)
         else
            render "new"
         end
      end

      def storeNewBook(sbookFound)
         newBook = sbookFound.books.new
         @book = newBook
         @sbook = sbookFound
      end

      def switch(type)
         if(type == "index") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allBooks = Book.order("id").page(params[:page]).per(10)
                  @books = allBooks
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "show") #Guest
            bookFound = Book.find_by_id(params[:id])
            if(bookFound)
               sbookFound = Sbook.find_by_name(params[:sbook_id])
               if(sbookFound)
                  sbookMatch = (bookFound.sbook_id == sbookFound.id)
                  if(sbookMatch)
                     @book = bookFound
                     @sbook = sbookFound
                     #Need to know about chapters here
                     bookChapters = @book.chapters.all
                     #Need to only display reviewed chapters
                     reviewedChapters = bookChapters.select{|chapter| chapter.reviewed}
                     @chapters = Kaminari.paginate_array(reviewedChapters).page(params[:page]).per(1)
                  else
                     redirect_to root_path
                  end
               else
                  redirect_to root_path
               end
            else
               render "public/404"
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               sbookFound = Sbook.find_by_name(params[:sbook_id])
               if(sbookFound)
                  #Need to check if the series is open or closed
                  if(sbookFound.series_open)
                     storeNewBook(sbookFound)
                  else
                     userMatch = (logged_in.id == sbookFound.user_id)
                     if(userMatch)
                        storeNewBook(sbookFound)
                     else
                        redirect_to root_path
                     end
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               sbookFound = Sbook.find_by_name(params[:sbook_id])
               if(sbookFound)
                  if(sbookFound.series_open)
                     storeBook(sbookFound, logged_in)
                  else
                     userMatch = (logged_in.id == sbookFound.user_id)
                     if(userMatch)
                        storeBook(sbookFound, logged_in)
                     else
                        redirect_to root_path
                     end
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "edit") #Login only and same user
            logged_in = current_user
            if(logged_in)
               bookFound = Book.find_by_id(params[:id])
               if(bookFound)
                  sbookFound = Sbook.find_by_name(params[:sbook_id])
                  if(sbookFound)
                     seriesMatch = (bookFound.sbook_id == sbookFound.id)
                     if(seriesMatch)
                        userMatch = ((logged_in.id == bookFound.user_id) || logged_in.admin)
                        if(userMatch)
                           @sbook = sbookFound
                           @book = bookFound
                        else
                           redirect_to root_path
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "update") #Login only and same user
            logged_in = current_user
            if(logged_in)
               bookFound = Book.find_by_id(params[:id])
               if(bookFound)
                  sbookFound = Sbook.find_by_name(params[:sbook_id])
                  if(sbookFound)
                     seriesMatch = (bookFound.sbook_id == sbookFound.id)
                     if(seriesMatch)
                        userMatch = ((logged_in.id == bookFound.user_id) || logged_in.admin)
                        if(userMatch)
                           @book = bookFound
                           @sbook = sbookFound
                           if(@book.update_attributes(params[:book]))
                              flash[:success] = 'Book was successfully updated.'
                              redirect_to sbook_book_path(@sbook, @book)
                           else
                              render "edit"
                           end
                        else
                           redirect_to root_path
                        end
                     else
                        redirect_to root_path
                     end
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "destroy") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  bookFound = Book.find_by_id(params[:id])
                  if(bookFound)
                     @book = bookFound
                     @book.destroy
                     redirect_to books_url
                  else
                     render "public/404"
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
