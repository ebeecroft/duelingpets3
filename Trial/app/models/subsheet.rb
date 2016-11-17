class Subsheet < ActiveRecord::Base
   attr_accessible :name, :description, :collab_mode
   belongs_to :mainsheet
   belongs_to :user
   has_many :sounds, :foreign_key => "subsheet_id", :dependent => :destroy
   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :name, presence: true, format: {with: VALID_NAME, case_sensitive: false}
   validates :description, presence: true
end
