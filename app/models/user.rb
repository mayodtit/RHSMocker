class User < ActiveRecord::Base
	attr_accessible :firstName, :lastName, :imageURL, :gender, :birthDate, :install_id

	after_create :default_content

	has_many :user_readings

	has_many :contents, :through => :user_readings

	has_many :content_authors

	#called to create the install message and the welcome message
	def default_content
		UserReading.create(user:self, content:Content.find(1), read_date: Time.zone.now.iso8601)
		UserReading.create(user:self, content:Content.find(2))
	end

	def readContent
		readingList = Array.new
		self.user_readings.includes(:content).each do |reading|

			if !reading.content.text.nil?
				reading.content.text = reading.content.formatArticle
			end
			readingList << reading
		end

		readingList 
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

end
