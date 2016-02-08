module UsersHelper

	def gravatar_for(user)
		# Gravatar URLs are based on an MD5 hash of the user’s email address
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		# return image tag
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end

end
