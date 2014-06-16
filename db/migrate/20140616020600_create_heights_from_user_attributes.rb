class CreateHeightsFromUserAttributes < ActiveRecord::Migration
  def up
    User.reset_column_information
    current_time = Time.now
    User.where('height IS NOT NULL').each do |u|
      u.heights.create(amount: u.read_attribute(:height),
                       taken_at: current_time)
    end
  end

  def down
    User.reset_column_information
    User.joins(:heights).readonly(false).uniq.each do |u|
      u.update_attribute(:height, u.heights.most_recent.amount)
    end
  end
end
