require 'spec_helper'

describe Consult do
  it_has_a 'valid factory'
  it_validates 'presence of', :initiator
  it_validates 'presence of', :subject
  it_validates 'presence of', :state
  it_validates 'presence of', :title
  it_validates 'foreign key of', :symptom
  it_validates 'inclusion of', :master

  it 'validates uniqueness of active per initiator' do
    current_consult = create(:consult, master: true)
    new_consult = build_stubbed(:consult, initiator: current_consult.initiator,
                                          master: true)
    expect(new_consult).to_not be_valid
    expect(new_consult.errors[:master]).to include("has already been taken")
  end

  describe 'callbacks' do
    describe '#send_initial_message' do
      context 'with a PHA' do
        let!(:pha) { create(:pha).tap{|p| p.create_pha_profile} }
        let!(:member) { create(:member, :premium, pha: pha, signed_up_at: Time.now) }
        let(:consult) { create(:consult, initiator: member) }
        let(:message_template) { create :message_template }

        it 'creates a message from a template' do
          MessageTemplate.stub(:find_by_name).with('New Premium Member OLD') { message_template }
          message_template.should_receive(:create_message).and_call_original
          consult = create :consult, initiator: member
          consult.reload
          consult.messages.count.should == 1
        end

        it 'does not attach a message if there is already a message' do
          c = create(:consult, initiator: member, messages_attributes: [{user: member, text: 'hello world'}])
          expect(c.messages.count).to eq(1)
          expect(c.messages.first.text).to eq('hello world')
        end

        it 'does not attach a message if consult initiator is not signed up' do
          member.stub(signed_up?: false)
          expect(consult.messages.count).to eq(0)
        end

        context 'we\'re using the new onboarding flow' do
          let!(:message_template) { create :message_template }

          before do
            Metadata.stub(:new_onboarding_flow?) { true }
            MessageTemplate.stub(:find_by_name) { nil }
          end

          context 'member answered a nux question' do
            let!(:nux_answer) { create :nux_answer }

            before do
              member.nux_answer = nux_answer
              member.save!
            end

            context 'phas on call' do
              before do
                Role.stub(:pha) do
                  o = Object.new
                  o.stub(:on_call?) { true }
                  o
                end
                Timecop.freeze()
              end

              after do
                Timecop.return()
              end

              it 'creates a message from a template' do
                MessageTemplate.stub(:find_by_name).with("New Premium Member Part 1: #{nux_answer.name}") { message_template }
                message_template.should_receive(:create_message).with(pha, instance_of(Consult), true, false, true).and_call_original
                consult = create :consult, initiator: member
                consult.reload
                consult.messages.count.should == 1
              end

              it 'creates a delayed job to create a second message' do
                Metadata.stub(:new_signup_second_message_delay) { 10 }
                MessageTemplate.stub(:find_by_name).with("New Premium Member Part 2: #{nux_answer.name}") { message_template }
                message_template.should_receive(:delay).with(run_at: 10.seconds.from_now) do
                  o = Object.new
                  o.should_receive(:create_message).with(pha, instance_of(Consult), false, false, true)
                  o
                end
                consult = create :consult, initiator: member
              end
            end

            context 'phas not on call' do
              before do
                Role.stub(:pha) do
                  o = Object.new
                  o.stub(:on_call?) { false }
                  o
                end
              end

              it 'creates a message from a template' do
                MessageTemplate.stub(:find_by_name).with("New Premium Member Off Hours: #{nux_answer.name}") { message_template }
                message_template.should_receive(:create_message).with(pha, instance_of(Consult), true, true, true).and_call_original
                consult = create :consult, initiator: member
                consult.reload
                consult.messages.count.should == 1
              end
            end
          end

          context 'member didn\'t answer a nux question' do
            context 'phas on call' do
              before do
                Role.stub(:pha) do
                  o = Object.new
                  o.stub(:on_call?) { true }
                  o
                end
                Timecop.freeze()
              end

              after do
                Timecop.return()
              end

              it 'creates a message from a template' do
                MessageTemplate.stub(:find_by_name).with("New Premium Member Part 1: something else") { message_template }
                message_template.should_receive(:create_message).with(pha, instance_of(Consult), true, false, true).and_call_original
                consult = create :consult, initiator: member
                consult.reload
                consult.messages.count.should == 1
              end

              it 'creates a delayed job to create a second message' do
                Metadata.stub(:new_signup_second_message_delay) { 10 }
                MessageTemplate.stub(:find_by_name).with("New Premium Member Part 2: something else") { message_template }
                message_template.should_receive(:delay).with(run_at: 10.seconds.from_now) do
                  o = Object.new
                  o.should_receive(:create_message).with(pha, instance_of(Consult), false, false, true)
                  o
                end
                consult = create :consult, initiator: member
              end
            end

            context 'phas not on call' do
              before do
                Role.stub(:pha) do
                  o = Object.new
                  o.stub(:on_call?) { false }
                  o
                end
              end

              it 'creates a message from a template' do
                MessageTemplate.stub(:find_by_name).with("New Premium Member Off Hours: something else") { message_template }
                message_template.should_receive(:create_message).with(pha, instance_of(Consult), true, true, true).and_call_original
                consult = create :consult, initiator: member
                consult.reload
                consult.messages.count.should == 1
              end
            end
          end
        end
      end

      context 'without a PHA' do
        let!(:member) { create(:member, :premium, signed_up_at: Time.now) }
        let(:consult) { create(:consult, initiator: member) }

        it 'does not attach a message if the member is not assigned a pha' do
          expect(consult.messages.count).to eq(0)
        end
      end
    end
  end

  describe 'state machine' do
    describe 'states' do
      it 'sets the initial state to :open' do
        expect(described_class.new.state?(:open)).to be_true
      end
    end

    describe 'events' do
      describe ':close' do
        let(:consult) { build(:consult) }

        it 'changes :open to :closed' do
          expect(consult.state?(:open)).to be_true
          expect(consult.close).to be_true
          expect(consult.state?(:closed)).to be_true
        end
      end
    end
  end

  describe 'message associations' do
    let!(:consult) { create(:consult) }
    let!(:old_message) { create(:message, consult: consult, created_at: 2.days.ago) }
    let!(:new_message) { create(:message, consult: consult) }
    let!(:note) { create(:message, consult: consult, created_at: 1.day.ago, note: true) }

    describe '#messages' do
      it 'only returns messages that have note set to false' do
        consult.reload.messages.include?(old_message).should be_true
        consult.messages.include?(new_message).should be_true
        consult.messages.include?(note).should be_false
      end

      it 'returns messages ordered by created at' do
        consult.reload.messages.should == [old_message, new_message]
      end
    end

    describe '#messages_and_notes' do
      it 'returns all messages' do
        consult.messages_and_notes.include?(old_message).should be_true
        consult.messages_and_notes.include?(new_message).should be_true
        consult.messages_and_notes.include?(note).should be_true
      end

      it 'returns messages ordered by created at' do
        consult.messages_and_notes.should == [old_message, note, new_message]
      end
    end
  end

  describe '#deactivate_if_last_message' do
    context 'message is missing' do
      it 'throws an exception' do
        expect { Consult.deactivate_if_last_message(100) }.to raise_error
      end
    end

    context 'message is present' do
      let!(:consult) { create :consult }
      let!(:message) { create :message, consult: consult }

      context 'consult is inactive' do
        before do
          consult.conversation_state = 'inactive'
          consult.save!
        end

        it 'does nothing' do
          Consult.any_instance.should_not_receive :deactivate!
          Consult.deactivate_if_last_message message.id
        end
      end

      context 'consult is active' do
        before do
          message
          consult.conversation_state = 'active'
          consult.save!
        end

        context 'no messages were added since' do
          it 'deactivates the consult' do
            Consult.deactivate_if_last_message message.id
            consult.reload.should be_inactive
          end
        end

        context 'some messages were added since' do
          context 'messages are automated' do
            before do
              create :message, automated: true, created_at: 5.minutes.from_now
              create :message, automated: true, created_at: 10.minutes.from_now
            end

            it 'deactivates the consult' do
              Consult.deactivate_if_last_message message.id
              consult.reload.should be_inactive
            end
          end

          context 'messages are after hours' do
            before do
              create :message, off_hours: true, created_at: 5.minutes.from_now
              create :message, off_hours: true, created_at: 10.minutes.from_now
            end

            it 'deactivates the consult' do
              Consult.deactivate_if_last_message message.id
              consult.reload.should be_inactive
            end
          end

          context 'messages are system' do
            before do
              create :message, system: true, created_at: 5.minutes.from_now
              create :message, system: true, created_at: 10.minutes.from_now
            end

            it 'deactivates the consult' do
              Consult.deactivate_if_last_message message.id
              consult.reload.should be_inactive
            end
          end

          context 'messages are notes' do
            before do
              create :message, note: true, created_at: 5.minutes.from_now
              create :message, note: true, created_at: 10.minutes.from_now
            end

            it 'deactivates the consult' do
              Consult.deactivate_if_last_message message.id
              consult.reload.should be_inactive
            end
          end
        end
      end
    end
  end

  describe '#activate' do
    let!(:consult) { create :consult }
    let!(:message) { create :message, consult: consult }
    let!(:other_message) { create :message, consult: consult }

    before do
      consult.conversation_state = :inactive
      consult.save!
      consult.reload
      message_task.priority = -1
      message_task.save!
    end

    context 'message for task is last consult message' do
      let!(:message_task) { create(:message_task, message: other_message, consult: consult) }

      it 'does nothing' do
        consult.activate!
        message_task.reload.priority.should == -1
      end
    end

    context 'message for task is not last consult message' do
      let!(:message_task) { create(:message_task, message: message, consult: consult) }

      it 'updates the priority of all message tasks that are open' do
        consult.activate!
        message_task.reload.priority.should == MessageTask::ACTIVE_CONVERSATION_PRIORITY
      end
    end
  end

  describe '#deactivate' do
    let!(:consult) { create :consult }
    let!(:message) { create :message, consult: consult }
    let!(:other_message) { create :message, consult: consult }
    let!(:message_task) { create(:message_task, message: message, consult: consult) }

    before do
      consult.conversation_state = :active
      consult.save!
      consult.reload
      message_task.priority = -1
      message_task.save!
    end

    context 'message for task is last consult message' do
      let!(:message_task) { create(:message_task, message: other_message, consult: consult) }

      it 'does nothing' do
        consult.deactivate!
        message_task.reload.priority.should == -1
      end
    end

    context 'message for task is not last consult message' do
      let!(:message_task) { create(:message_task, message: message, consult: consult) }

      it 'updates the priority of all message tasks that are open' do
        consult.deactivate!
        message_task.reload.priority.should == MessageTask::INACTIVE_CONVERSATION_PRIORITY
      end
    end
  end

  describe '#flag' do
    let!(:consult) { create :consult }
    let!(:message) { create :message, consult: consult }
    let!(:other_message) { create :message, consult: consult }
    let!(:message_task) { create(:message_task, message: message, consult: consult) }

    before do
      consult.conversation_state = :active
      consult.save!
      consult.reload
      message_task.priority = -1
      message_task.save!
    end

    context 'message for task is last consult message' do
      let!(:message_task) { create(:message_task, message: other_message, consult: consult) }

      it 'does nothing' do
        consult.flag!
        message_task.reload.priority.should == -1
      end
    end

    context 'message for task is not last consult message' do
      let!(:message_task) { create(:message_task, message: message, consult: consult) }

      it 'updates the priority of all message tasks that are open' do
        consult.flag!
        message_task.reload.priority.should == MessageTask::NEEDS_RESPONSE_PRIORITY
      end
    end
  end
end
