class User < ActiveRecord::Base
	Pusher.app_id = '36367'
	Pusher.key = 'f93e7c2a2a407ef7747b'
	Pusher.secret = '513445887ae45c985287'

	#height is stored in meters
	attr_accessible :firstName, :lastName, :imageURL, :gender, :birthDate, :install_id, :email, :height, :phone, :generic_call_time
	
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
    :message => "%{value} is not a call time" }


	#DEMOGRAPHIC and PHR Related methods
	#+++++++++++++++++++++++++++++++++++

	def fullName
		if !firstName.nil? && !lastName.nil?
			fullname = firstName + ' ' + lastName
		else
			fullName = "Not Set"
		end
	end

	def updateWeight(new_weight)
		UserWeight.create(weight:new_weight, user:self)
	end

	#CONTENT Related methods
	#+++++++++++++++++++++++++++++++++++

	#called to create the install message and the welcome message
	#nasty hack based on known ID's that makes me want to puke
	def default_content
		UserReading.create(user:self, content:Content.find(1), read_date: Time.zone.now.iso8601)
		UserReading.create(user:self, content:Content.find(2))
	end

	def readContent
		readingList = Array.new
		self.user_readings.order('read_date DESC').includes(:content).each do |reading|

			if !reading.content.body.nil?
				reading.content.body = reading.content.formatArticle
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
