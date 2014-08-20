class NuxAnswerSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :text, :sign_up_text

  def sign_up_text
    "Just one last step, before you get to meet your Personal Health Assistant and they can start #{object.phrase}."
  end
end