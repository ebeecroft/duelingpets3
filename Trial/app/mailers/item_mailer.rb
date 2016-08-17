class ItemMailer < ActionMailer::Base
   default from: "notification@duelingpets.net"

   def review_item(item)
      @item = item
      @url = "http://www.duelingpets.net/items/review"
      allUsers = Usertype.all
      reviewers = allUsers.select{|user| user.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, subject: "New Item Awaiting Review")
         end
      end
   end

   def item_approved(item, points)
      @item = item
      @points = points
      @url = "http://www.duelingpets.net/items/#{@item.name}"
      mail(to: item.user.email, subject: "Your Item was Approved")
   end

   def item_denied(item)
      @item = item
      @url = "http://www.duelingpets.net/items/#{@item.name}/edit"
      mail(to: item.user.email, subject: "Your Item was Denied")
   end
end
