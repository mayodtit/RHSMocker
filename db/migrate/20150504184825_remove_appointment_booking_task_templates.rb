class RemoveAppointmentBookingTaskTemplates < ActiveRecord::Migration
  def up
    TaskTemplate.find_by_name("appointment booking - calander invite").try(:destroy)
    TaskTemplate.find_by_name("appointment booking - add doctor").try(:destroy)
  end

  def down
  end
end
