class Forum < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :user
  has_many :tcontainers
  
  validates :name, presence: true, uniqueness: { case_sensitive: false}

  def to_param
     name
  end
end
