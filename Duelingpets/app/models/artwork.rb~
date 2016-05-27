class Artwork < ActiveRecord::Base
   attr_accessible :title, :description, :art, :remote_art_url
   belongs_to :subfolder
   belongs_to :user
   VALID_TITLE = /\A[A-Za-z][A-Za-z][A-Za-z ]+\z/
   validates :title, presence: true, format: {with: VALID_TITLE}
   mount_uploader :art, ArtUploader
end
