class Fight < ActiveRecord::Base
  belongs_to :pet
  belongs_to :petowner
end
