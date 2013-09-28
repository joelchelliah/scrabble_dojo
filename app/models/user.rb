class User < ActiveRecord::Base
 
  has_many :memos, dependent: :destroy

  before_create :create_remember_token
	before_save { self.email.downcase! }

	validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }

  has_secure_password

	def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


  private

	  def create_remember_token
	    self.remember_token = User.encrypt(User.new_remember_token)
	  end
end
