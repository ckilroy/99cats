class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :session_token, uniqueness: true
  #validates :password#, length: { minumum: 6, allow_nil: true }
  #need allow_nil because on subsequent calls to database, will keep instantiating new
  #user object that does not call password=

  has_many :cats

  after_initialize :ensure_session_token      # comes BEFORE validation

  attr_reader :password     # need for length validation

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.update_attributes(session_token: session_token)
    # QUESTION: needs to persist to database!!
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def password=(password)
    @password = password #need in instance variable to validate password length
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    self.password_digest.is_password?(password)
  end

  def password_digest
    BCrypt::Password.new(super)     # BCrypt::Password.new(self.password_digest)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?       # added security blanket
    user.is_password?(password) ? user : nil
  end

end
