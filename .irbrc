def kyle
  @kyle ||= Member.find_by_email('kyle@getbetter.com')
end
