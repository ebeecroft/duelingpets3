class Chapter < ActiveRecord::Base
   attr_accessible :title, :story #:document, :remote_document_url
   belongs_to :book
   belongs_to :gchapter
   belongs_to :user
   #mount_uploader :document, DocumentUploader
end
