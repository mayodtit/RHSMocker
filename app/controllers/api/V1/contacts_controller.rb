class Api::V1::ContactsController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    index_resource contacts
  end

  private

  def load_user!
    @user = if params[:user_id] == 'current'
              current_user
            elsif params[:user_id]
              Member.find(params[:user_id])
            else
              current_user
            end
  end

  def contacts
    [
      better_pha_contact,
      mayo_clinic_nurseline_contact
    ]
  end

  def better_pha_contact
    {
      name: 'Better PHA',
      phone: Metadata.pha_phone_number,
      status: Role.pha.on_call? ? :online : :offline,
      image_url: root_url + self.class.helpers.asset_path('Contacts-PHA@2x.png'),
      show_border: false
    }
  end

  def mayo_clinic_nurseline_contact
    {
      name: 'Mayo Clinic Nurse Line',
      phone: Metadata.nurse_phone_number,
      status: :online,
      image_url: root_url + self.class.helpers.asset_path('Contacts-Mayo@2x.png'),
      show_border: true
    }
  end

  def protocol
    Rails.application.routes.default_url_options[:protocol]
  end

  def host
    Rails.application.routes.default_url_options[:host]
  end

  def root_url
    if protocol && host
      protocol + '://' + host
    else
      ''
    end
  end
end
