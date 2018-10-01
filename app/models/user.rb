class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_many :follows
  has_many :following, through: :follows

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         # Tell Devise to use :login in the authentication_keys
         :authentication_keys => [:login]

  # add validation to check format of username to not allow @ character
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_\.]*\z/
  validates :username, presence: true, 
            uniqueness: { case_sensitive: false }, 
            length: { minimum: 3, maximum: 25 },
            format: { with: VALID_USERNAME_REGEX }

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

  # methods for searching user
  def self.search(param)
    param.strip!
    param.downcase!
    to_send_back = (username_matches(param) + email_matches(param)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.username_matches(param)
    matches('username', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    User.where("#{field_name} like?", "%#{param}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  # use this now in _result.html.erb
  # prevent to add already friends
  def not_following_with?(following_id)
    follows.where(following_id: following_id).count < 1
  end
end
