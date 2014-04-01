class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles
  belongs_to :resource, polymorphic: true

  attr_accessible :name, :resource, :resource_id, :resource_type

  validates :name, presence: true,
                   uniqueness: {scope: %i(resource_id resource_type)}

  def on_call?
    on_call = false

    case name
      when 'pha'
        t = Time.now.in_time_zone('Pacific Time (US & Canada)')
        on_call = !(t.wday == 0 || t.wday == 6 || t.hour < 9 || t.hour > 17) && !Metadata.force_phas_off_call?
      when 'nurse'
        on_call = true
    end

    on_call
  end
end
