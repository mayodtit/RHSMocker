class ViewSerializer < ActiveModel::Serializer
  self.root = false

  @@controller = nil

  def initialize(object, options={})
    @render_preview = options[:preview]
    @render_body = options[:body]
    @card_actions = options[:card_actions]
    @fullscreen_actions = options[:fullscreen_actions]
    super(object, options)
  end

  def attributes
    hash = super
    hash.merge!(:preview => preview) if render_preview?
    hash.merge!(:body => body) if render_body?
    hash.merge!(:fullscreen_actions => fullscreen_actions) if fullscreen_actions?
    hash.merge!(:card_actions => card_actions) if card_actions?
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

  def card_actions?
    @card_actions || false
  end

  def fullscreen_actions?
    @fullscreen_actions || false
  end
end
