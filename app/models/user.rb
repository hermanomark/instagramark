class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_many :follows
  has_many :followers, through: :follows
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         # Tell Devise to use :login in the authentication_keys
         :authentication_keys => [:login]

  # validation for username
  validates :username, presence: true, 
            uniqueness: { case_sensitive: false }, 
            length: { minimum: 3, maximum: 25 }

  # add validation to check format of username to not allow @ character
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  # to even more secure for the validation above
  validate :validate_username
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
  
  # Create a login virtual attribute in the User model
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  # Overwrite Devise's find_for_database_authentication method in User model
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
