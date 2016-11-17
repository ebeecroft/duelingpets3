class Artwork < ActiveRecord::Base
   attr_accessible :title, :description, :art, :remote_art_url, :art_cache
   belongs_to :subfolder
   belongs_to :user
   VALID_TITLE = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :title, presence: true, format: {with: VALID_TITLE}
   validates :description, presence: true
   mount_uploader :art, ArtUploader
end
