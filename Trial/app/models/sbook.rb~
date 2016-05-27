class Sbook < ActiveRecord::Base
  attr_accessible :name, :series_open
  belongs_to :user
  has_many :books, :foreign_key => "sbook_id", :dependent => :destroy
  VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z ]+\z/
  validates :name, presence: true, format: {with: VALID_NAME}, uniqueness: {case_sensitive: false}

   def to_param
      name
   end
end
