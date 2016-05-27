class Book < ActiveRecord::Base
  attr_accessible :title, :description
  belongs_to :sbook
  belongs_to :user
  has_many :chapters, :foreign_key => "book_id", :dependent => :destroy

  VALID_TITLE = /\A[A-Za-z][A-Za-z][A-Za-z ]+\z/
  validates :title, presence: true, format: {with: VALID_TITLE},uniqueness: {case_sensitive: false, :scope => :sbook_id}
  validates :description, presence: true
end
