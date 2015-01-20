class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles
  belongs_to :resource, polymorphic: true

  attr_accessible :name, :resource, :resource_id, :resource_type

  validates :name, presence: true,
                   uniqueness: {scope: %i(resource_id resource_type)}

  def on_call?
    during_on_call? Time.now
  end

  def during_on_call? timestamp
    on_call = false

    case name
      when 'pha'
        t = timestamp.in_time_zone('Pacific Time (US & Canada)')
        on_call = (Metadata.force_phas_on_call? || !(t.wday == 0 || t.wday == 6 || t.hour < ON_CALL_START_HOUR || t.hour > (ON_CALL_END_HOUR - 1))) && !Metadata.force_phas_off_call?
      when 'nurse'
        on_call = true
    end

    on_call
  end

  def self.pha_lead
    find_by_name! 'pha_lead'
  end

  def self.pha
    find_by_name! 'pha'
  end

  def self.nurse
    find_by_name! 'nurse'
  end

  def self.pha_stakeholders
    leads = Role.pha_lead.users.members

    geoff = Member.find_by_email 'geoff@getbetter.com'
    leads.push geoff if geoff

    abhik = Member.find_by_email 'abhik@getbetter.com'
    leads.push abhik if abhik

    kyle = Member.find_by_email 'kyle@getbetter.com'
    leads.push kyle if kyle

    leads
  end
end
