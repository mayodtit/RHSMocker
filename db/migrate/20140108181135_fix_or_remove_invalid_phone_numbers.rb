require './lib/utils/phone_number_util'

class FixOrRemoveInvalidPhoneNumbers < ActiveRecord::Migration
  def fix_phone_number(old_phone_number)
    fixed_phone_number = PhoneNumber.prep_phone_number_for_db old_phone_number
    fixed_phone_number = fixed_phone_number[1..-1] if fixed_phone_number && fixed_phone_number[0] == '1'
    fixed_phone_number = nil unless PhoneNumberUtil::VALIDATION_REGEX =~ fixed_phone_number
    fixed_phone_number
  end

  def up
    Member.all.each do |member|
      member.update_attribute(:phone, fix_phone_number(member.phone))
    end

    PhoneCall.all.each do |phone_call|
      phone_call.destination_phone_number = fix_phone_number phone_call.destination_phone_number
      phone_call.destination_phone_number = '8553270607' if phone_call.destination_phone_number.nil?
      phone_call.origin_phone_number = fix_phone_number phone_call.origin_phone_number

      # phone_call.save! spits out "stack level too deep", so using straight up sql.
      updates = ActiveRecord::Base.send(:sanitize_sql_array, ["origin_phone_number = ?, destination_phone_number= ? ", phone_call.origin_phone_number, phone_call.destination_phone_number])
      execute "UPDATE phone_calls SET #{updates} WHERE id='#{phone_call.id}'"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
