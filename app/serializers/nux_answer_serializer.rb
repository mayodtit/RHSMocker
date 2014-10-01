class NuxAnswerSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :text, :sign_up_text

  def sign_up_text
    "Create an account to meet your Personal Health Assistant (PHA)."
  end
end
