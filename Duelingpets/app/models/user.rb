class User < ActiveRecord::Base
   attr_accessible :email, :first_name, :last_name, :login_id, :vname, :password, :password_confirmation, :avatar
   has_secure_password
   mount_uploader :avatar, AvatarUploader
   before_save { |user| user.email = user.email.downcase }
   before_save { |user| user.first_name = user.first_name.humanize }

   #Forum section
   has_many :forums, :foreign_key => "user_id", :dependent => :destroy
   has_many :tcontainers, :foreign_key => "user_id", :dependent => :destroy
   has_many :maintopics, :foreign_key => "user_id", :dependent => :destroy
   has_many :subtopics, :foreign_key => "user_id", :dependent => :destroy
   has_many :narratives, :foreign_key => "user_id", :dependent => :destroy

   #Writing section
   has_many :sbooks, :foreign_key => "user_id", :dependent => :destroy
   has_many :books, :foreign_key => "user_id", :dependent => :destroy
   has_many :chapters, :foreign_key => "user_id", :dependent => :destroy

   #key
   has_one :sessionkey, :foreign_key => "user_id", :dependent => :destroy
   has_one :usertype, :foreign_key => "user_id", :dependent => :destroy
   has_one :pouch, :foreign_key => "user_id", :dependent => :destroy

   #Art section
   has_many :mainfolders, :foreign_key => "user_id", :dependent => :destroy
   has_many :subfolders, :foreign_key => "user_id", :dependent => :destroy
   has_many :artworks, :foreign_key => "user_id", :dependent => :destroy

   #Features, Pets and Comments section
   has_many :suggestions, :foreign_key => "user_id", :dependent => :destroy
   has_many :comments, :foreign_key => "user_id", :dependent => :destroy
   has_many :pets, :foreign_key => "user_id", :dependent => :destroy

   #User features
   has_many :petowners, :foreign_key => "user_id", :dependent => :destroy
   has_many :inventories, :foreign_key => "user_id", :dependent => :destroy

   #validates :first_name, presence: true
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   VALID_NAME_REGEX = /\A[a-z][a-z][a-z]+\z/i
   VALID_VNAME_REGEX = /\A[A-Za-z][A-Za-z][A-Za-z][A-Za-z0-9 ]+([-][A-Za-z0-9 ]+)?\z/
   VALID_PASSWORD_REGEX = /\A[A-Za-z0-9!][A-Za-z0-9!][A-Za-z0-9!][A-Za-z0-9!][A-Za-z0-9!][A-Za-z0-9!]+\z/
   validates :first_name, presence: true, format: { with: VALID_NAME_REGEX}
   validates :last_name, presence: true, format: { with: VALID_NAME_REGEX}
   validates :email, presence: true, format: { with: VALID_EMAIL_REGEX}
   validates :login_id, presence: true, format: { with: VALID_VNAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :vname, presence: true, format: { with: VALID_VNAME_REGEX}, uniqueness: { case_sensitive: false}
   validates :password, length: {minimum: 6}, format: { with: VALID_PASSWORD_REGEX}
   validates :password_confirmation, presence: true, format: { with: VALID_PASSWORD_REGEX}

   def to_param
      vname
   end
end
