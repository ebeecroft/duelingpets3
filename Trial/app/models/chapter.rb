class Chapter < ActiveRecord::Base
   attr_accessible :title, :story #:document, :remote_document_url
   belongs_to :book
   belongs_to :gchapter
   belongs_to :user
   VALID_TITLE = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :title, presence: true, format: {with: VALID_TITLE}
   validates :story, presence: true
   #mount_uploader :document, DocumentUploader
end
