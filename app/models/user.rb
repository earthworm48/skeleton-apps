class User < ActiveRecord::Base
	# after save and before create
	before_create :create_activation_digest
	before_save :downcase_email
	# in the model, self is optional in the right-hand-side
	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: {maximum: 240},  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    message: "invalid email address" }, uniqueness: {case_sensitive: false}
    # case_sensitive: to prevent the email of different case (but same content) to pass the validation

    has_secure_password
    # has_secure_password includes a separate presence validation that specifically catches nil passwords. 
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    # for storage in the cookies without storing it in the database
    attr_accessor :remember_token, :activation_token, :reset_token

    # for the use to create BCrypt password:
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
    def authenticated?(attribute, token)
    	# Use 'send' to sends a message to an object instance (User in this case)
    	digest = self.send("#{attribute}_digest")
    	return false if digest.nil?
    	BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
			update_attribute(:remember_digest, nil)    	
    end

    # to be used in the user controller #create method
    def send_activation_email
    	UserMailer.account_activation(self).deliver_now
    end

    # to be used in account_activation_controller
    def activate
			update_attribute(:activated, true)
			update_attribute(:activated_at, Time.zone.now)
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_send_at, Time.zone.now)
    end  

    def send_reset_email
        UserMailer.password_reset(self).deliver_now
    end  

    def password_reset_expired?
        # is password sent earlier than 2 hours ago?
        reset_send_at < 2.hours.ago
    end

    private
    	def create_activation_digest
    		self.activation_token = User.new_token
    		# remember tokens and digests are created for users that already exist in the database, 
    		# whereas the before_create callback happens before the user has been created
    		self.activation_digest = User.digest(activation_token)
    		# update_attribute(:activation_digest, User.digest(activation_token))
    	end

    	def downcase_email
    		self.email = email.downcase
    	end

end