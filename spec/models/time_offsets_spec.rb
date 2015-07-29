require "spec_helper"

describe TimeOffset do
  it_has_a "valid factory"

  describe "valdations" do
    it_validates "presence of", :direction
    it_validates "presence of", :offset_type

    [:before, :after].each do |dir|
      it "#{dir} is a valid direction" do
        expect(build_stubbed(:time_offset, direction: dir)).to be_valid
      end
    end

    [:fixed, :relative].each do |type|
      it "#{type} is a valid offset_type" do
        expect(build_stubbed(:time_offset, offset_type: type)).to be_valid
      end
    end

    describe "#fixed_offsets_require_fixed_time_and_num_days" do
      context "valid data" do
        let(:ten_am) { Time.at(60*60*10) }
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
        let(:three_hours) { Time.at(60*60*3) }
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

end
