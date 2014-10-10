class ConsultConversationStateTransition < ActiveRecord::Base
  belongs_to :consult
  attr_accessible :created_at, :event, :from, :to
end
