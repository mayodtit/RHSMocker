require 'spec_helper'

describe Message do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_content
  it_has_a 'valid factory', :with_phone_call
  it_has_a 'valid factory', :with_scheduled_phone_call
  it_has_a 'valid factory', :with_phone_call_summary
  it_validates 'presence of', :user
  it_validates 'presence of', :consult
  it_validates 'inclusion of', :off_hours
  it_validates 'foreign key of', :content
  it_validates 'foreign key of', :symptom
  it_validates 'foreign key of', :condition
  it_validates 'foreign key of', :phone_call
  it_validates 'foreign key of', :scheduled_phone_call
  it_validates 'foreign key of', :phone_call_summary
  it_validates 'foreign key of', :user_image
  it_validates 'foreign key of', :service

  describe 'callbacks' do
    describe '#fix_bad_markdown_links' do
      context 'with spaces before' do
        let(:message) { described_class.new(text: '[Bad message]( www.google.com)') }

        it 'strips the spaces' do
          message.valid?
          expect(message.text).to eq('[Bad message](www.google.com)')
        end
      end

      context 'with spaces after' do
        let(:message) { described_class.new(text: '[Bad message](www.google.com )') }

        it 'strips the spaces' do
          message.valid?
          expect(message.text).to eq('[Bad message](www.google.com)')
        end
      end

      context 'with spaces before and after' do
        let(:message) { described_class.new(text: '[Bad message]( www.google.com )') }

        it 'strips the spaces' do
          message.valid?
          expect(message.text).to eq('[Bad message](www.google.com)')
        end
      end
    end
  end

  describe '::with_bad_markdown_links' do
    before do
      Message.any_instance.stub(:fix_bad_markdown_links)
    end

    let!(:pha) { create(:pha) }
    let!(:member) { create(:member, :premium, pha: pha) }
    let!(:consult) { member.master_consult }
    let!(:pre) { consult.messages.create(user: pha, text: '[Bad message]( www.google.com)') }
    let!(:post) { consult.messages.create(user: pha, text: '[Bad message](www.google.com )') }
    let!(:both) { consult.messages.create(user: pha, text: '[Bad message]( www.google.com )') }

    it 'returns messages with spaces before, after, or both' do
      expect(described_class.with_bad_markdown_links).to include(pre, post, both)
    end
  end

  describe '#fix_bad_markdown_links!' do
    context 'with spaces before' do
      let(:message) { create(:message, text: '[Bad message]( www.google.com)') }

      it 'strips the spaces' do
        message.fix_bad_markdown_links!
        expect(message.reload.text).to eq('[Bad message](www.google.com)')
      end
    end

    context 'with spaces after' do
      let(:message) { create(:message, text: '[Bad message](www.google.com )') }

      it 'strips the spaces' do
        message.fix_bad_markdown_links!
        expect(message.reload.text).to eq('[Bad message](www.google.com)')
      end
    end

    context 'with spaces before and after' do
      let(:message) { create(:message, text: '[Bad message]( www.google.com )') }

      it 'strips the spaces' do
        message.fix_bad_markdown_links!
        expect(message.reload.text).to eq('[Bad message](www.google.com)')
      end
    end
  end

  describe 'publish' do
    let(:message) { build_stubbed(:message) }

    it 'publishes that a message was created' do
      PubSub.should_receive(:publish).with(
        "/users/#{message.consult.initiator_id}/consults/#{message.consult_id}/messages/new",
        {id: message.id}, nil
      )
      message.publish
    end

    context 'consult is master consult' do
      before do
        message.consult.stub(:master?) { true }
      end

      it 'publishes that a message was created to two channels' do
        PubSub.should_receive(:publish).with(
          "/users/#{message.consult.initiator_id}/consults/#{message.consult_id}/messages/new",
          {id: message.id}, nil
        )
        PubSub.should_receive(:publish).with(
          "/users/#{message.consult.initiator_id}/consults/current/messages/new",
          {id: message.id}, nil
        )
        message.publish
      end
    end
  end

  describe 'create_task' do
    let(:message) { build(:message) }

    before do
      message.stub(:scheduled_phone_call_id) { nil }
      message.stub(:phone_call_id) { nil }
    end

    context 'user message' do
      it 'creates a message task' do
        MessageTask.should_receive(:create_if_only_opened_for_consult!).with(message.consult, message)
        message.create_task
      end
    end

    context 'is a phone call message' do
      it 'doesn\'t publish' do
        message.stub(:phone_call_id) { 1 }
        MessageTask.should_not_receive(:create_if_only_opened_for_consult!)
        message.create_task
      end
    end

    context 'is a scheduled phone call message' do
      it 'doesn\'t publish' do
        message.stub(:scheduled_phone_call_id) { 1 }
        MessageTask.should_not_receive(:create_if_only_opened_for_consult!)
        message.create_task
      end
    end

    context 'is a note' do
      it 'doesn\'t publish' do
        message.stub(:note?) { true }
        MessageTask.should_not_receive(:create_if_only_opened_for_consult!)
        message.create_task
      end
    end
  end

  describe 'update_initiator_last_contact_at' do
    let(:message) { build :message }

    context 'message is for a phone call summary' do
      let(:phone_call_summary) { build :phone_call_summary }

      before do
        message.stub(:phone_call_summary) { phone_call_summary }
      end

      it 'doesn\'t set the last contact at' do
        message.consult.initiator.should_not_receive(:update_attributes!)
        message.update_initiator_last_contact_at
      end
    end

    context 'message is for a phone call summary' do
      before do
        message.stub(:note?) { true }
      end

      it 'doesn\'t set the last contact at' do
        message.consult.initiator.should_not_receive(:update_attributes!)
        message.update_initiator_last_contact_at
      end
    end

    context 'phone call message' do
      let(:phone_call) { build :phone_call }

      before do
        message.stub(:phone_call) { phone_call }
      end

      context 'phone call is not for a nurse' do
        before do
          phone_call.stub(:to_nurse?) { false }
        end

        it 'sets the consults initiator to last contact at' do
          message.consult.initiator.should_receive(:update_attributes!).with(last_contact_at: message.created_at)
          message.update_initiator_last_contact_at
        end
      end

      context 'phone call is for a nurse' do
        before do
          phone_call.stub(:to_nurse?) { true }
        end

        it 'doesn\'t set the last contact at' do
          message.consult.initiator.should_not_receive(:update_attributes!)
          message.update_initiator_last_contact_at
        end
      end
    end

    context 'message is from or to a PHA' do
      it 'sets the consults initiator to last contact at' do
        message.consult.initiator.should_receive(:update_attributes!).with(last_contact_at: message.created_at)
        message.update_initiator_last_contact_at
      end
    end

    context 'message is sent by user' do
      before do
        message.stub(:user) { message.consult.initiator }
      end

      it 'doesn\'t set the last contact at' do
        message.consult.initiator.should_not_receive(:update_attributes!)
        message.update_initiator_last_contact_at
      end
    end
  end

  describe '#attach_user_image' do
    let!(:user_image) { create(:user_image, client_guid: 'GUID') }

    it 'sets user_image before validations and saves successfully' do
      message = build(:message, user_id: user_image.user_id,
                                user_image_client_guid: user_image.client_guid)
      expect(message.user_image).to be_nil
      message.save!
      expect(message.reload.user_image).to eq(user_image)
    end
  end

  describe '#activate_consult' do
    let(:consult) { build_stubbed :consult }
    let(:message) { build_stubbed :message, consult: consult }

    before do
      consult.stub(:lock!) { consult }
    end

    context 'message is off_hours' do
      before do
        message.stub(:off_hours?) { true }
      end

      it 'does nothing' do
        consult.should_not_receive :activate!
        Consult.should_not_receive :delay
        message.activate_consult
      end
    end

    context 'message is not off_hours' do
      before do
        message.stub(:off_hours?) { false }
      end

      context 'message is system' do
        before do
          message.stub(:system?) { true }
        end

        it 'does nothing' do
          consult.should_not_receive :activate!
          Consult.should_not_receive :delay
          message.activate_consult
        end
      end

      context 'message is not system' do
        before do
          message.stub(:system?) { false }
        end

        context 'message is automated' do
          before do
            message.stub(:automated?) { true }
          end

          it 'does nothing' do
            consult.should_not_receive :activate!
            Consult.should_not_receive :delay
            message.activate_consult
          end
        end

        context 'message is not automated' do
          before do
            message.stub(:automated?) { false }
          end

          context 'message is note' do
            before do
              message.stub(:note?) { true }
            end

            it 'does nothing' do
              consult.should_not_receive :activate!
              Consult.should_not_receive :delay
              message.activate_consult
            end
          end

          context 'message is not note' do
            before do
              message.stub(:note?) { false }
              Timecop.freeze
            end

            after do
              Timecop.return
            end

            context 'message has no text' do
              before do
                message.stub(:text) { nil }
              end

              it 'message' do
                consult.should_not_receive :activate!
                Consult.should_not_receive :delay
                message.activate_consult
              end
            end

            context 'message has text' do
              before do
                message.stub(:text) { 'poo' }
                message.stub(:img) { nil }
              end

              context 'message is not from the user' do
                before do
                  message.stub(:user) { build_stubbed :pha }
                  consult.stub(:activate!)
                end

                it 'activates the consult' do
                  consult.should_receive(:activate!).with message
                  message.activate_consult
                end
              end

              context 'message is from the user' do
                before do
                  message.stub(:user) { consult.initiator }
                end

                context 'consult needs response' do
                  before do
                    consult.stub(:needs_response?) { true }
                  end

                  it 'doesn\'t flag the consult' do
                    consult.should_not_receive :flag!
                    message.activate_consult
                  end
                end

                context 'consult doesn\'t need response' do
                  before do
                    consult.stub(:needs_response?) { false }
                  end

                  it 'flags the consult' do
                    consult.should_receive :flag!
                    message.activate_consult
                  end
                end
              end
            end

            context 'message has image' do
              before do
                message.stub(:text) { nil }
                message.stub(:image) { 'img' }
              end

              context 'message is not from the user' do
                before do
                  message.stub(:user) { build_stubbed :pha }
                  consult.stub(:activate!)
                end

                it 'activates the consult' do
                  consult.should_receive(:activate!).with message
                  message.activate_consult
                end
              end

              context 'message is from the user' do
                before do
                  message.stub(:user) { consult.initiator }
                end

                context 'consult needs response' do
                  before do
                    consult.stub(:needs_response?) { true }
                  end

                  it 'doesn\'t flag the consult' do
                    consult.should_not_receive :flag!
                    message.activate_consult
                  end
                end

                context 'consult doesn\'t need response' do
                  before do
                    consult.stub(:needs_response?) { false }
                  end

                  it 'flags the consult' do
                    consult.should_receive :flag!
                    message.activate_consult
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
