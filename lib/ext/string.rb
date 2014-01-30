class String
  def event_actor
    return 'assignor' if self == 'assign'
    return 'transferrer' if self == 'transfer'
    return "#{self}r" if self[-1] == 'e'
    "#{self}er"
  end

  def event_actor_id
    "#{event_actor}_id"
  end

  def event_state
    return 'transferred' if self == 'transfer'
    return "#{self}d" if self[-1] == 'e'
    "#{self}ed"
  end

  def event_timestamp
    "#{event_state}_at"
  end
end