class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	# in the model, self is optional in the right-hand-side
	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: {maximum: 240},  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    message: "invalid email address" }, uniqueness: {case_sensitive: false}
    # case_sensitive: to prevent the email of different case (but same content) to pass the validation

    has_secure_password
    # has_secure_password includes a separate presence validation that specifically catches nil passwords. 
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    # for storage in the cookies without storing it in the database
    attr_accessor :remember_token

    # Returns the hash digest of the given string so that we can use it in the fixture.yml file
    def self.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    	# Noted that the 'BCrypt', 'BC' is uppercase
    	BCrypt::Password.create(string, cost: cost)
    end

    def self.new_token
    	SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
    	self.remember_token = User.new_token
    	update_attribute(:remember_digest, User.digest(remember_token))
    end

    # to convert the hash to password string '.new'
    def authenticated?(remember_token)
    	return false if remember_digest.nil?
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
		update_attribute(:remember_digest, nil)    	
    end
end