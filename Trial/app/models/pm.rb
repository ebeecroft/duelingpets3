class Pm < ActiveRecord::Base
   attr_accessible :title, :description
   belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
   belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
   has_many :preplies, :foreign_key => "pm_id", :dependent => :destroy
   VALID_TITLE_REGEX = /\A[a-z0-9][a-z0-9][a-z0-9[-][()] ]+\z/i
   validates :title, presence: true, format: { with: VALID_TITLE_REGEX}
   validates :description, presence: true
end
