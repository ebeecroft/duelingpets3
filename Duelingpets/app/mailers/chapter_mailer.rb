class ChapterMailer < ActionMailer::Base
   default from: "notification@duelingpets.net"

   def review_chapter(chapter)
      @chapter = chapter
      @url = "http://www.duelingpets.net/chapters/review"
      allUsers = Usertype.all
      reviewers = allUsers.select{|user| user.privilege == "Reviewer"}
      if(reviewers.count > 0)
         reviewers.each do |reviewer|
            mail(to: reviewer.user.email, subject: "New Chapter Awaiting Review")
         end
      end
   end

   def chapter_approved(chapter, points)
      @chapter = chapter
      @points = points
      @url = "http://www.duelingpets.net/books/#{@chapter.book_id}/chapters"
      mail(to: chapter.user.email, subject: "Your Chapter was Approved")
   end

   def chapter_denied(chapter)
      @chapter = chapter
      @url = "http://www.duelingpets.net/books/#{@artwork.book_id}/chapters/#{@chapter.id}/edit"
      mail(to: chapter.user.email, subject: "Your Chapter was Denied")
   end
end
