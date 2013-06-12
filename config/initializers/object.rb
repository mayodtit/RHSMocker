class Object
  # attempts to call a method only if the object responds to it, nil otherwise
  def try_method(method=nil, *args, &block)
    if method == nil && block_given?
      yield self
    elsif respond_to?(method)
      __send__(method, *args, &block)
    else
      nil
    end
  end
end
