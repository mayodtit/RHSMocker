class User < ActiveRecord::Base
	#height is stored in meters

	attr_accessible :firstName, :lastName, :imageURL, :gender, :birthDate, :install_id, :email, :height

	after_create :default_content

	has_many :user_readings

	has_many :user_weights

	has_many :contents, :through => :user_readings

	has_many :content_authors

	def fullName
		if !firstName.nil? && !lastName.nil?
			fullname = firstName + ' ' + lastName
		else
			fullName = "Not Set"
		end
	end

	#called to create the install message and the welcome message
	#nasty hack based on known ID's that makes me want to puke
	def default_content
		UserReading.create(user:self, content:Content.find(1), read_date: Time.zone.now.iso8601)
		UserReading.create(user:self, content:Content.find(2))
	end

	def readContent
		readingList = Array.new
		self.user_readings.order('read_date DESC').includes(:content).each do |reading|

			if !reading.content.text.nil?
				reading.content.text = reading.content.formatArticle
			end
			readingList << reading
		end

	end

	def markRead(content)
		userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
		if userReadings.size == 1 and userReadings.first.read_date.nil?
			userReading = userReadings.first 
			userReading.read_date = Time.now
			userReading.save!
		else
			#throw an error on the size or skip on the already read
		end
	end

	def markDismissed(content)
		userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
		if userReadings.size == 1 and userReadings.first.dismiss_date.nil? and userReadings.first.read_date.nil?
			userReading = userReadings.first 
			userReading.dismiss_date = Time.now
			userReading.save!
		else
			#throw an error on the size or skip on the already dismissed
		end
	end

	def markReadLater(content)
		userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
		if userReadings.size == 1 and userReadings.first.read_date.nil?
			userReading = userReadings.first 
			userReading.read_later_date, = Time.now
			userReading.read_later_count = userReading.read_later_count + 1 #no ++ incrementor sucks
			userReading.save!
		else
			#throw an error on the size or skip on the already read
		end
	end

	def resetReadingList
		self.user_readings.each do |reading|

			if reading.content_id != 1 #nasty hack to not reset installed message
				reading.read_date 		= nil
				reading.dismiss_date 	= nil
				reading.read_later_count = 0
				reading.read_later_date = nil
				reading.save!
			end
		end
	end

	def updateWeight(new_weight)
		puts "NEW WEIGHT ====>" + new_weight
		UserWeight.create(weight:new_weight, user:self)
	end

end
