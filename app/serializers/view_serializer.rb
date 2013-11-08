class ViewSerializer < ActiveModel::Serializer
  @@controller = nil

  def initialize(object, options={})
    @render_preview = options[:preview]
    @render_body = options[:body]
    super(object, options)
  end

  def attributes
    hash = super
    hash.merge!(:preview => preview) if render_preview?
    hash.merge!(:body => body) if render_body?
    hash
  end

  def partial_name
    object.class.to_s.downcase
  end

  protected

  def controller
    @@controller ||= ActionController::Base.new
  end

  def render_preview?
    @render_preview || false
  end

  def render_body?
    @render_body || false
  end
end
