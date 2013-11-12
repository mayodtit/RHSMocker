class ContentSerializer < ViewSerializer
  self.root = false

  def initialize(object, options={})
    @raw_body = options[:raw_body]
    @raw_preview = options[:raw_preview]
    super object, options
  end

  attributes :id, :title, :content_type, :content_updated_at, :document_id,
             :created_at, :updated_at, :content_type_display, :abstract,
             :contentID, :contents_type

  def attributes
    hash = super
    hash.merge!(raw_body: raw_body) if raw_body?
    hash.merge!(raw_preview: raw_preview) if raw_preview?
    hash
  end

  delegate :show_call_option?, to: :object
  alias_method :contentID, :id
  alias_method :contents_type, :content_type

  def body
    controller.render_to_string(template: 'api/v1/contents/show',
                                layout: 'serializable',
                                formats: :html,
                                locals: {content: self})
  end

  def raw_body
    object.body
  end

  def preview
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, resource: self})
  end

  def raw_preview
    object.body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "")
  end

  def share_url
    nil
  end

  def card_actions
    [
      {normal: {title: 'Save', action: :save}},
      {normal: {title: 'Dismiss', action: :dismiss}},
      {normal: {title: 'Share', action: :share}}
    ]
  end

  def full_actions
    [
      {normal: {title: 'Save', action: :save}, selected: {title: 'Dismiss', action: :dismiss}},
      {normal: {title: 'Like', action: :like}, selected: {title: 'Unlike', action: :like}},
      {normal: {title: 'Share', action: :share}},
      {normal: {title: 'Add User', action: :adduser}}
    ]
  end

  private

  def raw_body?
    @raw_body || false
  end

  def raw_preview?
    @raw_preview || false
  end
end
