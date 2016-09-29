class Blacklisteddomain < ActiveRecord::Base
   attr_accessible :name, :domain_only
   VALID_DOMAIN_REGEX = /\A[a-z\d\-.]+\.[a-z]+\z/i
   validates :name, presence: true, format: { with: VALID_DOMAIN_REGEX}
   def to_param
      name
   end
end
