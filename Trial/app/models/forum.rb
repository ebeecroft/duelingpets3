class Forum < ActiveRecord::Base
  attr_accessible :name, :description
  belongs_to :user
  has_many :tcontainers, :foreign_key => "forum_id", :dependent => :destroy
  VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
  validates :name, presence: true, format: {with: VALID_NAME}, uniqueness: { case_sensitive: false}
  validates :description, presence: true

  def to_param
     name
  end
end
