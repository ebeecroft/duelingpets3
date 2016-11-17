class Suggestion < ActiveRecord::Base
   attr_accessible :name, :description
   belongs_to :user
   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :description, presence: true
   validates :name, presence: true, format: {with: VALID_NAME, case_sensitive: false}
end
