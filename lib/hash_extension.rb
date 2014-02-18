module HashExtension
  extend ActiveSupport::Concern

  def change_key!(old_key, new_key)
    self[new_key] = self[old_key]
    self.except!(old_key)
  end
end

Hash.send(:include, HashExtension)
