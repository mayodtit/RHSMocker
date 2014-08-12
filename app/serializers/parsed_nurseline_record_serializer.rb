class ParsedNurselineRecordSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :consult_id, :phone_call_id, :nurseline_record_id,
             :created_at, :updated_at, :user_full_name

  def attributes
    super.tap do |a|
      a.merge!(text: object.text) if options[:include_text]
    end
  end

  def user_full_name
    object.user.try(:full_name)
  end
end
