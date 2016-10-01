module BlogsHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         blogmode = Maintenancemode.find_by_id(20)
         mode_turned_on = (allmode.maintenance_on || blogmode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to blogs_maintenance_path
               end
            else
               switch type
            end
         else
            switch type
         end
      end
   end

   def getOptional
      @optional
   end

   private
      def getStatus(user)
         status = "Offline"
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(onlineUserFound.signed_in_at)
            if(!onlineUserFound.signed_out_at)
               if(onlineUserFound.last_visited == nil)
                  status = "Online"
               else
                  if((currentTime - onlineUserFound.last_visited) > 30.minutes)
                     status = "Inactive"
                  else
                     status = "Online"
                  end
               end
            else
               status = "Offline"
            end
         end
         return status
      end

      def getTime(user, status)
         value = ""
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(status == "Inactive")
            value = onlineUserFound.last_visited
         else
            value = onlineUserFound.signed_out_at
         end
         return value
      end

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

      def setOptional(optional)
         @optional = optional
      end

      def switch(type)
         if(type == "index") #Guest
            optional = params[:user_id]
            setOptional optional
            if(getOptional)
               userFound = User.find_by_vname(optional)
               if(userFound)
                  userBlogs = userFound.blogs.order("created_on desc")
                  @blogs = Kaminari.paginate_array(userBlogs).page(params[:page]).per(10)
                  @user = userFound
               else
                  render "public/404"
               end
            else
               allBlogs = Blog.order("created_on desc").page(params[:page]).per(10)
               @blogs = allBlogs
            end
         elsif(type == "show") #Guest
            userFound = User.find_by_vname(params[:user_id])
            if(userFound)
               blogFound = Blog.find_by_id(params[:id])
               if(blogFound)
                  userMatch = (userFound.id == blogFound.user_id)
                  if(userMatch)
                     @blog = blogFound
                     blogReplies = @blog.replies.all
                     @replies = Kaminari.paginate_array(blogReplies).page(params[:page]).per(10)
                  else
                     redirect_to root_path
                  end
               else
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     newBlog = logged_in.blogs.new
                     @blog = newBlog
                     @user = userFound
                  else
                     redirect_to root_path
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
               userFound = User.find_by_vname(params[:user_id])
               if(userFound)
                  userMatch = (logged_in.id == userFound.id)
                  if(userMatch)
                     #Builds the new blog for the logged in user
                     newBlog = logged_in.blogs.new(params[:blog])
                     currentTime = Time.now
                     newBlog.created_on = currentTime
                     @blog = newBlog
                     if(@blog.save)
                        @user = userFound
                        flash[:success] = "Blog #{@blog.title} was successfully created."
                        redirect_to user_blog_path(@user, @blog)
                     else
                        render "new"
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
         elsif(type == "edit") #Login only and same user
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  blogFound = Blog.find_by_id(params[:id])
                  if(blogFound)
                     userMatch = ((userFound.id == blogFound.user_id) || userFound.admin)
                     if(userMatch)
                        @user = userFound
                        @blog = blogFound
                     else
                        redirect_to root_path
                     end
                  else
                     render "public/404"
                  end
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "update") #Login only and same user
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  blogFound = Blog.find_by_id(params[:id])
                  if(blogFound)
                     userMatch = ((userFound.id == blogFound.user_id) || userFound.admin)
                     if(userMatch)
                        @blog = blogFound
                        if(@blog.update_attributes(params[:blog]))
                           @user = userFound
                           flash[:success] = 'Blog was successfully updated.'
                           redirect_to user_blog_path(@user, @blog)
                        else
                           render "edit"
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
            else
               redirect_to root_path
            end
         elsif(type == "destroy") #Admin only
            logged_in = current_user
            if(logged_in)
               userFound = User.find_by_vname(logged_in.vname)
               if(userFound)
                  if(logged_in.admin)
                     blogFound = Blog.find_by_id(params[:id])
                     if(blogFound)
                        userMatch = ((userFound.id == blogFound.user_id) || userFound.admin)
                        if(userMatch)
                           @blog = blogFound
                           @blog.destroy
                           redirect_to blogs_url
                        else
                           redirect_to root_path
                        end
                     else
                        render "public/404"
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
         elsif(type == "list") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allBlogs = Blog.order("created_on desc").page(params[:page]).per(10)
                  @blogs = allBlogs
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         end
      end
end
