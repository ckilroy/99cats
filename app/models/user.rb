class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :session_token, uniqueness: true
  validates :password, length: { minumum: 6, allow_nil: true }
  #need allow_nil because on subsequent calls to database, will keep instantiating new
  #user object that does not call password=

  after_initialize :reset_session_token!

  attr_reader :password     # need for length validation

  def self.reset_session_token!
    self.session_token = SecureRandom.base64(16)
  end

  def password=(password)
    @password = password #need in instance variable to validate password length
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_user_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
  # can also override password_digest method with Bcrypt.new to return the
  # encryption object, as helper method

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name)
    return nil if user.nil?       # added security blanket
    user.is_user_password?(password) ? user : nil
  end

end
