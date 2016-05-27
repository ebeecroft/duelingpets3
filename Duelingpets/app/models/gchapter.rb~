class Gchapter < ActiveRecord::Base
  attr_accessible :title
  has_many :chapters, :foreign_key => "gchapter_id", :dependent => :destroy
  VALID_TITLE = /\A[C][h][a][p][t][e][r][ ][1-9]+\z/
  validates :title, presence: true, format: { with: VALID_TITLE}, uniqueness: { case_sensitive: false}
end
