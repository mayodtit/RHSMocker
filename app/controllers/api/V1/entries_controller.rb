class Api::V1::EntriesController < Api::V1::ABaseController
  before_filter :load_member!

  def index
    authorize! :read, Entry
    entries = @member.entries.order('created_at ASC')
    index_resource entries.serializer, name: :entries
  end


end
