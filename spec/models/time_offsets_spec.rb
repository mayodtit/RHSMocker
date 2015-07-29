require "spec_helper"

describe TimeOffset do
  it_has_a "valid factory"
  let(:ten_am) { Time.at(60*60*10) }
  let(:three_hours) { Time.at(60*60*3) }
  let(:base_time) { Time.zone.local(2015, 7, 25, 12, 0) }

  describe "valdations" do
    it_validates "presence of", :direction
    it_validates "presence of", :offset_type

    TimeOffset::VALID_DIRECTIONS.each do |dir|
      it "#{dir} is a valid direction" do
        expect(build_stubbed(:time_offset, direction: dir)).to be_valid
      end
    end

    TimeOffset::VALID_OFFSET_TYPES.each do |type|
      it "#{type} is a valid offset_type" do
        expect(build_stubbed(:time_offset, offset_type: type)).to be_valid
      end
    end

    describe "#fixed_offsets_require_fixed_time_and_num_days" do
      context "valid data" do
        let(:valid_offset) { build_stubbed(:time_offset, offset_type: :fixed, num_days: 2, fixed_time: ten_am) }
        it "is valid" do
          expect(valid_offset).to be_valid
        end
        it "has a num_days" do
          expect(valid_offset.num_days).to eq 2
        end
        it "has a fixed_time" do
          expect(valid_offset.fixed_time).to eq ten_am
        end
      end

      context "invalid cases" do
        let(:invalid_offset) do
          build_stubbed(:time_offset, offset_type: :fixed, num_days: nil, fixed_time: nil).tap{|io| io.valid?}
        end
        it "is invalid" do
          expect(invalid_offset).to_not be_valid
        end
        it "has an error message for num_days" do
          expect(invalid_offset.errors[:num_days]).to eq ["must be provided when offset_type == :fixed"]
        end
        it "has an error message for fixed_time" do
          expect(invalid_offset.errors[:fixed_time]).to eq ["must be provided when offset_type == :fixed"]
        end
      end
    end

    describe "#relative_offsets_require_relative_time" do
      context "valid data" do
        let(:valid_offset) { build_stubbed(:time_offset, offset_type: :relative, relative_time: three_hours) }
        it "is valid" do
          expect(valid_offset).to be_valid
        end
        it "has a relative_time" do
          expect(valid_offset.relative_time).to eq three_hours
        end
      end

      context "invalid cases" do
        let(:invalid_offset) do
          build_stubbed(:time_offset, offset_type: :relative, relative_time: nil).tap{|io| io.valid?}
        end
        it "is invalid" do
          expect(invalid_offset).to_not be_valid
        end
        it "has an error message for relative_time" do
          expect(invalid_offset.errors[:relative_time]).to eq ["must be provided when offset_type == :relative"]
        end
      end
    end
  end

  describe "#calculate" do
    context "fixed offset_types" do
      let(:fixed_offset_params) { { offset_type: :fixed, fixed_time: three_hours } }
      let(:three_hours_before) { build_stubbed(:time_offset, fixed_offset_params.merge({direction: :before})) }
      let(:three_hours_after) { build_stubbed(:time_offset, fixed_offset_params.merge({direction: :after})) }

      it "works for before directions" do
        expect(three_hours_before.calculate(base_time)).to eq Time.zone.local(2015,7,25,9,0)
      end
      it "works for after directions" do
        expect(three_hours_after.calculate(base_time)).to eq Time.zone.local(2015,7,25,15,0)
      end
    end

    context "relative offset_types" do
      let(:relative_offset_params) { { offset_type: :relative, relative_time: ten_am, num_days: 2 } }
      let(:two_days_before) { build_stubbed(:time_offset, relative_offset_params.merge({direction: :before})) }
      let(:two_days_after)  { build_stubbed(:time_offset, relative_offset_params.merge({direction: :after})) }

      it "works for before directions" do
        expect(two_days_before.calculate(base_time)).to eq Time.zone.local(2015, 7, 23, 10, 0)
      end
      it "works for after directions" do
        expect(two_days_after.calculate(base_time)).to eq Time.zone.local(2015, 7, 27, 10, 0)
      end
    end
  end
end
