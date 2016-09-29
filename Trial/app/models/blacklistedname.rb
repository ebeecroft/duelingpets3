class Blacklistedname < ActiveRecord::Base
   attr_accessible :name
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z0-9]+\z/i
   validates :name, presence: true, format: { with: VALID_NAME_REGEX}
   def to_param
      name
   end
end
