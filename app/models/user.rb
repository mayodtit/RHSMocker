class User < ActiveRecord::Base
  authenticates_with_sorcery!

	attr_accessible :first_name, :last_name, :image_url, :gender, :height, :birth_date, :install_id, :email, :phone,\
	                :generic_call_time, :password, :password_confirmation

	after_create :default_content

	#Things the user has read
	has_many :user_readings, :order => 'read_date DESC'

	has_many :messages

  has_many :user_diseases
  has_many :diseases, :through=> :user_diseases

	#Weight Readings
	has_many :user_weights

	has_many :user_locations

	#All of the content assigned to this user
	has_many :contents, :through => :user_readings

	has_many :content_authors

	has_many :associations, :dependent => :destroy
  has_many :associates, :through=>:associations

  has_and_belongs_to_many :institutions

  has_many :feedbacks

	#Validations
	#++++++++++++++
	validates :install_id, :presence => true, :uniqueness => true

	validates :generic_call_time, :inclusion => { :in => %w(Morning Afternoon Evening),
    :message => "%{value} is not a call time" }, :allow_nil => true

  validates_length_of :phone, :in => 7..11, :allow_blank => true

  validates_length_of :password, :minimum => 8, :message => "must be at least 8 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password



	def full_name
		return "Not Set" if first_name.empty? || last_name.empty?
		"#{first_name} #{last_name}".strip
	end

	def login
		update_attribute :auth_token, Base64.urlsafe_encode64(SecureRandom.base64(36))
	end

	#Keywords (aka search history)
	def keywords
		["Diabetes", "Weight Loss", "Low Sugar Diet", "Exercise"]
	end


	#CONTENT Related methods
	#+++++++++++++++++++++++++++++++++++

	#called to create the install message and the welcome message
	#nasty hack based on known ID's that makes me want to puke
	def default_content
		#if for some reason, the content was not created yet, then there is no default content
		if !Content.where("title = 'Installed RHS'").empty?
			UserReading.create(user:self, content:Content.where("title = 'Installed RHS'").first, read_date: Time.zone.now.iso8601)
		end
		if !Content.where("title = 'Welcome'").empty?
			UserReading.create(user:self, content:Content.where("title = 'Welcome'").first)
		end
	end



	def allowed_to_edit_user? user_id
		associates.map(&:id).include? user_id
  end

end