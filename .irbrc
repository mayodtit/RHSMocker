def kyle
  @kyle ||= Member.find_by_email('kyle@getbetter.com')
end

def clare
  @clare ||= Member.find_by_email('clare@getbetter.com')
end

def lauren
  @lauren ||= Member.find_by_email('lauren@getbetter.com')
end

def meg
  @meg ||= Member.find_by_email('meg@getbetter.com')
end

def ninette
  @ninette ||= Member.find_by_email('ninette@getbetter.com')
end

def jenn
  @jenn ||= Member.find_by_email('jenn@getbetter.com')
end
