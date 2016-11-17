class Mainsheet < ActiveRecord::Base
   attr_accessible :name, :description
   has_many :subsheets, :foreign_key => "mainsheet_id", :dependent => :destroy
   belongs_to :user

   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :description, presence: true
   validates :name, presence: true, format: {with: VALID_NAME}, uniqueness: { case_sensitive: false}

   def to_param
      name
   end
end
