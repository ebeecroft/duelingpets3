class Subsheet < ActiveRecord::Base
   attr_accessible :name, :description, :collab_mode
   belongs_to :mainsheet
   belongs_to :user
   has_many :sounds, :foreign_key => "subsheet_id", :dependent => :destroy
end
