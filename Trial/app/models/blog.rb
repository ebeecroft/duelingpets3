class Blog < ActiveRecord::Base
  attr_accessible :title, :description
  belongs_to :user
  has_many :replies, :foreign_key => "blog_id", :dependent => :destroy
  validates :title, presence: true
  validates :description, presence: true
end
