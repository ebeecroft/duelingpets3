class Mainsheet < ActiveRecord::Base
   attr_accessible :name, :description
   has_many :subsheets, :foreign_key => "mainsheet_id", :dependent => :destroy
   belongs_to :user

   def to_param
      name
   end
end
