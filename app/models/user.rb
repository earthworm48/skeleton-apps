class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	# in the model, self is optional in the right-hand-side
	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: {maximum: 240},  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    message: "invalid email address" }, uniqueness: {case_sensitive: false}
    # case_sensitive: to prevent the email of different case (but same content) to pass the validation
    validates :password, presence: true, length: {minimum: 6}
    has_secure_password
end