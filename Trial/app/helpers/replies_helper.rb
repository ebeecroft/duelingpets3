module RepliesHelper
   def mode(type)
      code = auto_logout
      if(code == true)
         sign_out
         redirect_to root_path
      else
         #Check if Maintenance is turned_on
         allmode = Maintenancemode.find_by_id(1)
         replymode = Maintenancemode.find_by_id(21)
         mode_turned_on = (allmode.maintenance_on || replymode.maintenance_on)
         #Determine if any maintenance is on
         if(mode_turned_on)
            #Determine if we are a regular user
            regularUser = (!current_user || !current_user.admin?)
            if(regularUser)
               #Determine which maintenance mode is on
               if(allmode.maintenance_on)
                  redirect_to maintenance_path
               else
                  redirect_to replies_maintenance_path
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
      def getStatus(user)
         status = "Offline"
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         if(onlineUserFound.signed_in_at)
            if(!onlineUserFound.signed_out_at)
               status = "Online"
            else
               status = "Offline"
            end
         end
         return status
      end

      def getTime(user)
         value = ""
         onlineUserFound = Onlineuser.find_by_user_id(user.id)
         #if(getStatus(onlineUserFound) != "Online")
            value = onlineUserFound.signed_out_at
         #end
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

      def switch(type)
         if(type == "index") #Admin
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  allReplies = Reply.order("created_on").page(params[:page]).per(10)
                  @replies = allReplies
               else
                  redirect_to root_path
               end
            else
               redirect_to root_path
            end
         elsif(type == "new") #Login only
            logged_in = current_user
            if(logged_in)
               blogFound = Blog.find_by_id(params[:blog_id])
               if(blogFound)
                  newReply = blogFound.replies.new
                  @reply = newReply
                  @blog = blogFound
               else
                  render "public/404"
               end               
            else
               redirect_to root_path
            end
         elsif(type == "create") #Login only
            logged_in = current_user
            if(logged_in)
               blogFound = Blog.find_by_id(params[:blog_id])
               if(blogFound)
                  newReply = blogFound.replies.new(params[:reply])
                  blogMatch = (blogFound.id == newReply.blog_id)
                  if(blogMatch)
                     newReply.user_id = logged_in.id
                     currentTime = Time.now
                     newReply.created_on = currentTime
                     @reply = newReply
                     if(@reply.save)
                        @blog = blogFound
                        flash[:success] = "Reply was successfully created."
                        redirect_to user_blog_path(@blog.user, @reply.blog)
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
               replyFound = Reply.find_by_id(params[:id])
               if(replyFound)
                  userMatch = ((logged_in.id == replyFound.user_id) || logged_in.admin)
                  if(userMatch)
                     blogFound = Blog.find_by_id(replyFound.blog_id)
                     if(blogFound)
                        @blog = blogFound
                        @reply = replyFound
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
               replyFound = Reply.find_by_id(params[:id])
               if(replyFound)
                  userMatch = ((logged_in.id == replyFound.user_id) || logged_in.admin)
                  if(userMatch)
                     blogFound = Blog.find_by_id(replyFound.blog_id)
                     if(blogFound)
                        @reply = replyFound
                        if(@reply.update_attributes(params[:reply]))
                           @blog = blogFound
                           flash[:success] = 'Reply was successfully updated.'
                           redirect_to user_blog_path(@blog.user, @reply.blog)
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
                  render "public/404"
               end
            else
               redirect_to root_path
            end
         elsif(type == "destroy") #Admin only
            logged_in = current_user
            if(logged_in)
               if(logged_in.admin)
                  replyFound = Reply.find_by_id(params[:id])
                  if(replyFound)
                     blogFound = Blog.find_by_id(replyFound.blog_id)
                     @reply = replyFound
                     @blog = blogFound
                     @reply.destroy
                     redirect_to user_blog_path(@blog.user, @blog)
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
