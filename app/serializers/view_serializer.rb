class ViewSerializer < ActiveModel::Serializer
  self.root = false

  @@controller = nil

  def initialize(object, options={})
    @render_preview = options[:preview]
    @render_body = options[:body]
    @raw_preview = options[:raw_preview]
    @raw_body = options[:raw_body]
    super(object, options)
  end

  def attributes
    hash = super
    hash.merge!(:preview => preview) if render_preview?
    hash.merge!(:body => body) if render_body?
    hash.merge!(raw_preview: raw_preview) if raw_preview?
    hash.merge!(raw_body: raw_body) if raw_body?
    hash
  end

  def partial_name
    object.class.to_s.underscore
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

  def raw_preview?
    @raw_preview || false
  end

  def raw_body?
    @raw_body || false
  end

  def default_card_actions
    [
      {normal: {title: 'Save', action: :save}},
      {normal: {title: 'Dismiss', action: :dismiss}},
    ]
  end
end
