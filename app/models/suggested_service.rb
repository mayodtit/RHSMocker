class SuggestedService < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :suggested_service_template

  attr_accessible :user, :user_id, :suggested_service_template,
                  :suggested_service_template_id

  validates :user, :suggested_service_template, presence: true

  delegate :title, :description, :message, to: :suggested_service_template

  private

  state_machine initial: :unoffered do
    event :offer do
      transition :unoffered => :offered
    end

    event :accept do
      transition all - :accepted => :accepted
    end

    event :reject do
      transition all - :rejected => :rejected
    end

    event :expire do
      transition %i(unoffered offered) => :expired
    end
  end
end
