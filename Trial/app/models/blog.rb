class Blog < ActiveRecord::Base
  attr_accessible :title, :description
  belongs_to :user
  VALID_TITLE = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
  has_many :replies, :foreign_key => "blog_id", :dependent => :destroy
  validates :title, presence: true, format: {with: VALID_TITLE}
  validates :description, presence: true
end
