require "spec_helper"

describe TimeOffset do
  it_has_a "valid factory"
  it_has_a "valid factory", :fixed
  it_has_a "valid factory", :relative

  let(:ten_am) { 10 * 60 }
  let(:three_hours) { 3 * 60 }
  let(:base_time) { Time.zone.local(2015, 7, 25, 12, 0) }

  describe "valdations" do
    it_validates "presence of", :direction
    it_validates "presence of", :offset_type

    TimeOffset::VALID_DIRECTIONS.each do |dir|
      it "#{dir} is a valid direction" do
        expect(build_stubbed(:time_offset, :fixed, :relative, direction: dir)).to be_valid
      end
    end

    TimeOffset::VALID_OFFSET_TYPES.each do |type|
      it "#{type} is a valid offset_type" do
        expect(build_stubbed(:time_offset, :fixed, :relative, offset_type: type)).to be_valid
      end
    end

    describe "#fixed_offsets_require_absolute_minutes" do
      context "valid data" do
        let(:valid_offset) { build_stubbed(:time_offset, offset_type: :fixed, absolute_minutes: three_hours) }

        it "is valid" do
          expect(valid_offset).to be_valid
        end

        it "has absolute_minutes" do
          expect(valid_offset.absolute_minutes).to eq three_hours
        end
      end

      context "invalid cases" do
        let(:invalid_offset) do
          build_stubbed(:time_offset, offset_type: :fixed, absolute_minutes: nil).tap{|io| io.valid?}
        end

        it "is invalid" do
          expect(invalid_offset).to_not be_valid
        end

        it "has an error message for absolute_minutes" do
          expect(invalid_offset.errors[:absolute_minutes]).to eq ["must be provided when offset_type == :fixed"]
        end
      end
    end

    describe "#relative_offsets_require_relative_days_and_relative_minutes_after_midnight" do
      context "valid data" do
        let(:valid_offset) { build_stubbed(:time_offset, offset_type: :relative, relative_days: 3, relative_minutes_after_midnight: three_hours) }

        it "is valid" do
          expect(valid_offset).to be_valid
        end

        it "has a relative_days" do
          expect(valid_offset.relative_days).to eq 3
        end

        it "has a relative_minutes_after_midnight" do
          expect(valid_offset.relative_minutes_after_midnight).to eq three_hours
        end
      end

      context "invalid cases" do
        let(:invalid_offset) do
          build_stubbed(:time_offset, offset_type: :relative, relative_days: nil, relative_minutes_after_midnight: nil).tap{|io| io.valid?}
        end

        it "is invalid" do
          expect(invalid_offset).to_not be_valid
        end

        it "has an error message for relative_days" do
          expect(invalid_offset.errors[:relative_days]).to eq ["must be provided when offset_type == :relative"]
        end

        it "has an error message for relative_minutes_after_midnight" do
          expect(invalid_offset.errors[:relative_minutes_after_midnight]).to eq ["must be provided when offset_type == :relative"]
        end
      end
    end
  end

  describe "#calculate" do
    context "fixed offset_types" do
      let(:fixed_offset_params) { { offset_type: :fixed, absolute_minutes: three_hours } }
      let(:three_hours_before) { build_stubbed(:time_offset, fixed_offset_params.merge!(direction: :before)) }
      let(:three_hours_after) { build_stubbed(:time_offset, fixed_offset_params.merge!(direction: :after)) }

      it "works for before directions" do
        expect(three_hours_before.calculate(base_time)).to eq Time.zone.local(2015,7,25,9,0)
      end

      it "works for after directions" do
        expect(three_hours_after.calculate(base_time)).to eq Time.zone.local(2015,7,25,15,0)
      end
    end

    context "relative offset_types" do
      let(:relative_offset_params) { { offset_type: :relative, relative_days: 2, relative_minutes_after_midnight: ten_am } }
      let(:two_days_before) { build_stubbed(:time_offset, relative_offset_params.merge!(direction: :before)) }
      let(:two_days_after) { build_stubbed(:time_offset, relative_offset_params.merge!(direction: :after)) }

      it "works for before directions" do
        expect(two_days_before.calculate(base_time)).to eq Time.zone.local(2015, 7, 23, 10, 0)
      end

      it "works for after directions" do
        expect(two_days_after.calculate(base_time)).to eq Time.zone.local(2015, 7, 27, 10, 0)
      end
    end
  end
end
