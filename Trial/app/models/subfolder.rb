class Subfolder < ActiveRecord::Base
   attr_accessible :name, :description, :collab_mode
   belongs_to :mainfolder
   belongs_to :user
   has_many :artworks, :foreign_key => "subfolder_id", :dependent => :destroy
   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z ]+\z/
   validates :name, presence: true, format: {with: VALID_NAME}
end
