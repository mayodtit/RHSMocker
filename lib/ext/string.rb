class String
  def event_actor
    return 'assignor' if self == 'assign'
    "#{self}er"
  end

  def event_actor_id
    "#{event_actor}_id"
  end

  def event_state
    "#{self}ed"
  end

  def event_timestamp
    "#{event_state}_at"
  end
end