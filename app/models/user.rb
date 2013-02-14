class User < ActiveRecord::Base
	Pusher.app_id = '36367'
	Pusher.key = 'f93e7c2a2a407ef7747b'
	Pusher.secret = '513445887ae45c985287'

	#height is stored in meters
	attr_accessible :firstName, :lastName, :imageURL, :gender, :birthDate, :install_id, :email, :phone, :generic_call_time
	after_create :default_content

	#Things the user has read
	has_many :user_readings

	#Weight Readings
	has_many :user_weights

	#All of the content assigned to this user
	has_many :contents, :through => :user_readings

	has_many :content_authors

	#Validations
	#++++++++++++++
	validates :install_id, :presence => true

	validates :generic_call_time, :inclusion => { :in => %w(Morning Afternoon Evening),
    :message => "%{value} is not a call time" }, :allow_nil => true

    validates_length_of :phone, :in => 7..11, :allow_blank => true

	#DEMOGRAPHIC and PHR Related methods
	#+++++++++++++++++++++++++++++++++++

	def fullName
		if !firstName.nil? && !lastName.nil?
			fullname = firstName + ' ' + lastName
		else
			fullName = "Not Set"
		end
	end

	def height(uom)
		if !uom.nil? || !uom == "in"
			height = inchesForMeters(:height/100)
		else
			height = :height/100
	end

	def updateWeight(new_weight)
		UserWeight.create(weight:new_weight, user:self)
	end

	def addLocation(lat, long)
		UserLocation.create(user:self, lat:lat, long:long)
	end

	#Keywords (aka search history)
	#+++++++++++++++++++++++++++++++++++
	def keywords
		keywords = []
		#Has this user done any searches

		#count < 7 and recently added anything to PHR

		#count > 5 return, else add in two trending things

		#count = 0, return default list
		keywords = ContentKeywords.where(:default => true)

	end


	#CONTENT Related methods
	#+++++++++++++++++++++++++++++++++++

	#called to create the install message and the welcome message
	#nasty hack based on known ID's that makes me want to puke
	def default_content
		#if for some reason, the content was not created yet, then there is no default content
		if !Content.where("headline = 'Installed RHS'").empty?
			UserReading.create(user:self, content:Content.where("headline = 'Installed RHS'").first, read_date: Time.zone.now.iso8601)
		end
		if !Content.where("headline = 'Welcome'").empty?
			UserReading.create(user:self, content:Content.where("headline = 'Welcome'").first)
		end
	end

	def readContent
		readingList = Array.new

		if !self.user_readings.empty?

			self.user_readings.order('read_date DESC').includes(:content).each do |reading|
					puts reading.content.id
					puts reading.content.headline
					puts reading.content.body
			if !reading.content.body.nil?
				reading.content.body = reading.content.formatArticle
			end
			readingList << reading
		end

		end
	end

	def markRead(content)
		userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
		if userReadings.size == 1 and userReadings.first.read_date.nil?
			userReading = userReadings.first 
			userReading.read_date = Time.now
			userReading.save!
			notifyContentChange('read', content.id, content.contentsType)

		else
			#throw an error on the size or skip on the already read
		end
		#TESTCODE
		checkForNewContent
	end

	def markDismissed(content)
		userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
		if userReadings.size == 1 and userReadings.first.dismiss_date.nil? and userReadings.first.read_date.nil?
			userReading = userReadings.first 
			userReading.dismiss_date = Time.now
			userReading.save!
			notifyContentChange('dismissed', content.id, content.contentsType)

		else
			#throw an error on the size or skip on the already dismissed
		end
		#TESTCODE
		checkForNewContent
	end

	def markReadLater(content)
		userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
		if userReadings.size == 1 and userReadings.first.read_date.nil?
			userReading = userReadings.first 
			userReading.read_later_date, = Time.now
			userReading.read_later_count = userReading.read_later_count + 1 #no ++ incrementor sucks
			userReading.save!
			notifyContentChange('readLater', content.id, content.contentsType)
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

	def notifyContentChange(type, contentID, contentType)
		Pusher['RHS_'+self.id.to_s].trigger(type, {:content_id => contentID, :content_type => contentType})
	end

	def checkForNewContent
		#create something, add to user_Reading, push it out
		if !hasMaxContent
			fakeArticleID = Content.createFakeArticle()
			fakeArticle = Content.find(fakeArticleID)
			UserReading.create(user:self, content:fakeArticle)
			Pusher['RHS_'+self.id.to_s].trigger('newcontent', {:content_id => fakeArticle.id, :content_type => fakeArticle.contentsType})
		end
	end

	def hasMaxContent
		self.user_readings.where(:read_date => nil, :dismiss_date => nil, :read_later_count => 0).count >= 7
	end

end
