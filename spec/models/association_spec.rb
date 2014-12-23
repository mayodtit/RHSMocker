require 'spec_helper'

describe Association do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :disabled
  it_has_a 'valid factory', :pending
  it_has_a 'valid factory', :member_associate

  describe 'validations' do
    before do
      described_class.any_instance.stub(:nullify_pair_id)
    end

    it_validates 'presence of', :user
    it_validates 'presence of', :associate
    it_validates 'presence of', :creator
    it_validates 'presence of', :permission
    it_validates 'uniqueness of', :associate_id, :user_id, :association_type_id
    it_validates 'foreign key of', :association_type
    it_validates 'foreign key of', :replacement
    it_validates 'foreign key of', :pair
    it_validates 'foreign key of', :parent
    it 'validates the user is not the associate' do
      user = build_stubbed(:user)
      build_stubbed(:association, user: user, associate: user).should_not be_valid
    end
    it 'validates creator does not change' do
      association = create(:association)
      expect(association.update_attributes(creator: create(:member))).to be_false
      expect(association).to_not be_valid
      expect(association.errors[:creator_id]).to include('cannot be changed')
    end
  end

  describe 'callbacks' do
    describe '#invite!' do
      let(:association) { build(:association, :associate_with_email) }

      context 'invite attribute not set' do
        it 'does not call #invite!' do
          association.should_not_receive(:invite!)
          association.save!
        end
      end

      context 'invite attribute is set' do
        it 'calls #invite!' do
          association.should_receive(:invite!).and_call_original
          expect(association.update_attributes(invite: true)).to be_true
        end
      end
    end

    describe '#create_default_permission' do
      it 'creates defaults on create' do
        expect{ create(:association) }.to change(Permission, :count).by(1)
      end

      it 'creates the permission for the association' do
        association = create(:association)
        permission = association.permission
        expect(permission).to be_persisted
        expect(permission.reload.subject).to eq(association)
        expect(association.reload.permission).to eq(permission)
      end

      context 'with an original with permissions' do
        # TODO - wut. remove test complexity.
        let!(:user) { create(:member) }
        let!(:parent) { create(:member) }
        let!(:parent_association) { create(:association, user: parent, associate: user) }
        let!(:parent_family_member) { create(:user, owner: user) }
        let!(:parent_family_member_association) { create(:association, user: parent_family_member, associate: user) }
        let!(:child) { create(:user, owner: user) }
        let!(:child_association) { create(:association, user: user, associate: child) }
        let!(:original) { create(:association, user: parent_family_member, associate: child) }

        it 'creates permission from the original permissions' do
          original.permission.update_attributes!(basic_info: :view)
          association = create(:association, :skip_permission, user: parent,
                                                               associate: child,
                                                               original: original)
          expect(association.permission.basic_info).to eq(:view)
        end
      end
    end

    describe '#remove_user_default_hcp_if_necessary' do
      context 'user does not have a default HCP' do
        it "should not change the user's default HCP" do
          u = create(:member, default_hcp_association_id: nil)
          u.should_not_receive(:remove_default_hcp)
          a = create(:association, user: u)
          a.destroy
        end
      end

      context 'user has a default HCP' do
        context "association being destroyed matches user's default HCP" do
          it "should remove user's default HCP" do
            u1 = create(:member)
            a1 = create(:association, user: u1)
            u1.set_default_hcp(a1.id)
            u1.should_receive(:remove_default_hcp)
            a1.destroy
          end
        end

        context "association being destroyed isn't user's default HCP" do
          it "should not alter user's default HCP" do
            u2 = create(:member)
            a2 = create(:association, user: u2)
            a3 = create(:association, user: u2)
            u2.set_default_hcp(a2.id)
            u2.should_not_receive(:remove_default_hcp)
            a3.destroy
          end
        end
      end
    end

    describe '#process_default_hcp' do
      context 'user does not have a default HCP' do
        let(:u) {create(:member, default_hcp_association_id: nil)}

        context 'creating an association' do
          context 'with is_default_hcp set to true' do
            it "should set the user's default HCP" do
              u.should_receive(:set_default_hcp).with(9999)
              create(:association, user: u, is_default_hcp: true, id: 9999)
            end
          end

          context 'with is_default_hcp set to false' do
            it "should not set the user's default HCP" do
              u.should_not_receive(:set_default_hcp)
              create(:association, user: u, is_default_hcp: false)
            end
          end

          context 'without setting is_default_hcp' do
            it "should not set the user's default HCP" do
              u.should_not_receive(:set_default_hcp)
              create(:association, user: u)
            end
          end
        end

        context 'updating an association' do
          before { @association = create(:association, user: u) }

          context 'with is_default_hcp set to true' do
            it "should set the user's default HCP" do
              u.should_receive(:set_default_hcp).with(@association.id)
              @association.update_attribute(:is_default_hcp, true)
            end
          end

          context 'with is_default_hcp set to false' do
            it "should not set the user's default HCP" do
              u.should_not_receive(:set_default_hcp)
              @association.update_attribute(:is_default_hcp, false)
            end
          end

          context 'without setting is_default_hcp' do
            it "should not set the user's dfeault HCP" do
              u.should_not_receive(:set_default_hcp)
              @association.update_attribute(:state, 'foobar')
            end
          end
        end
      end

      context 'user has a default HCP' do
        let(:u) {create(:member, default_hcp_association_id: nil)}
        before { @association = create(:association, user: u, is_default_hcp: true) }

        context 'creating an association' do
          context 'with is_default_hcp set to true' do
            it "should set the user's default HCP" do
              u.should_receive(:set_default_hcp).with(9999)
              create(:association, user: u, is_default_hcp: true, id: 9999)
            end
          end

          context 'with is_default_hcp set to false' do
            it "should not set the user's default HCP" do
              u.should_not_receive(:set_default_hcp)
              create(:association, user: u, is_default_hcp: false)
            end
          end

          context 'without setting is_default_hcp' do
            it "should not change the user's default HCP" do
              u.should_not_receive(:set_default_hcp)
              create(:association, user: u)
            end
          end
        end

        context 'updating an association' do
          before { @association2 = create(:association, user: u) }

          context 'with is_default_hcp set to true' do
            context 'for default association' do
              it "should update the user's default HCP" do
                u.should_receive(:set_default_hcp).with(@association.id)
                @association.update_attribute(:is_default_hcp, true)
              end
            end

            context 'for other association' do
              it "should update the user's default HCP" do
                u.should_receive(:set_default_hcp).with(@association2.id)
                @association2.update_attribute(:is_default_hcp, true)
              end
            end
          end

          context 'with is_default_hcp set to false' do
            context 'for default association' do
              it "should remove the user's default HCP" do
                u.should_receive(:remove_default_hcp)
                @association.update_attribute(:is_default_hcp, false)
              end
            end

            context 'for other association' do
              it "should not change the user's default HCP" do
                u.should_not_receive(:remove_default_hcp)
                @association2.update_attribute(:is_default_hcp, false)
              end
            end
          end

          context 'without setting is_default_hcp' do
            context 'for default association' do
              it "should not change the user's default HCP" do
                u.should_not_receive(:remove_default_hcp)
                @association.update_attribute(:state, 'foobar')
              end
            end

            context 'for other association' do
              it "should not change the user's default HCP" do
                u.should_not_receive(:remove_default_hcp)
                @association2.update_attribute(:state, 'foobar')
              end
            end
          end
        end
      end
    end
  end

  describe '#invite!' do
    context 'without a Member' do
      let(:owner) { create(:member) }
      let(:associate) { create(:user, email: 'kyle@test.getbetter.com', owner: owner) }
      let!(:association) { create(:association, user: owner, associate: associate) }

      # TODO - these specs probably reach too far out of this model
      it 'creates a Member' do
        expect{ association.invite! }.to change(Member, :count).by(1)
      end

      it 'invites the Member' do
        expect{ association.invite! }.to change(Invitation, :count).by(1)
      end
    end

    context 'with a Member' do
      let(:owner) { create(:member) }
      let!(:member) { create(:member) }
      let!(:associate) { create(:user, email: member.email, owner: owner) }
      let!(:association) { create(:association, user: owner, associate: associate) }

      it 'creates pending and pair Associations' do
        expect(association.replacement).to be_nil
        expect{ association.invite! }.to change(Association, :count).by(2)
        expect(association.reload.replacement).to be_persisted
        expect(association.replacement.state?(:pending)).to be_true
        expect(association.pair).to be_persisted
        expect(association.pair.state?(:enabled)).to be_true
      end
    end
  end

  describe '#create_pair_association!' do
    let(:association) { create(:association) }

    it 'creates a pair' do
      expect(association.pair).to be_nil
      expect{ association.create_pair_association! }.to change(Association, :count).by(1)
      expect(association.reload.pair).to be_persisted
      expect(association.pair.state?(:enabled)).to be_true
    end

    context 'with an original pair' do
      let!(:original) { create(:association, replacement: association, pair: create(:association)) }

      it "assigns the new association as the original's pair" do
        expect(association.pair).to be_nil
        expect{ association.create_pair_association! }.to change(Association, :count).by(1)
        expect(association.reload.pair).to be_persisted
        expect(association.pair.state?(:enabled)).to be_true
        expect(original.pair.replacement).to eq(association.pair)
      end
    end
  end

  describe 'state_machine' do
    describe 'events' do
      describe 'enable' do
        let(:association) { build(:association, :disabled) }

        it 'sets disabled to enabled' do
          expect(association.enable).to be_true
          expect(association.state?(:enabled)).to be_true
        end

        context 'when pending' do
          let(:association) { create(:association, :pending) }

          it 'creates an enabled pair association' do
            expect(association.enable).to be_true
            expect(association.reload.state?(:enabled)).to be_true
            pair = association.pair
            expect(pair).to be_persisted
            expect(pair.user).to eq(association.associate)
            expect(pair.associate).to eq(association.user)
            expect(pair.state?(:enabled)).to be_true
            expect(pair.pair).to eq(association)
          end

          context 'with an original association' do
            let(:association) { create(:association, :pending, original: create(:association)) }

            it 'disables the original association' do
              expect(association.enable).to be_true
              expect(association.state?(:enabled)).to be_true
              expect(association.original.reload.state?(:disabled)).to be_true
            end
          end
        end
      end

      describe 'disable' do
        let(:association) { build(:association) }

        it 'sets enabled to disabled' do
          expect(association.disable).to be_true
          expect(association.state?(:disabled)).to be_true
        end

        context 'with an original association' do
          let(:association) { create(:association, original: create(:association, :disabled)) }

          it 'enables the original association' do
            expect(association.disable).to be_true
            expect(association.state?(:disabled)).to be_true
            expect(association.original.reload.state?(:enabled)).to be_true
          end
        end

        context 'with an pair association' do
          let(:association) { create(:association, pair: create(:association)) }

          it 'disables the pair association' do
            expect(association.disable).to be_true
            expect(association.state?(:disabled)).to be_true
            expect(association.pair.reload.state?(:disabled)).to be_true
          end
        end
      end
    end
  end
end
