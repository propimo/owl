require 'spec_helper'
require 'owl'

describe Location do
  describe '#distance_to' do
    it 'calculates correct distance in kms' do
      expect(Location.new(0, 0).distance_to(Location.new(0, 0))).to eq(0.0)
      expect(Location.new(1, 2).distance_to(Location.new(3, 4)).to_i).to eq(314)
    end
  end

  describe '#==' do
    it 'is equal to the location with the same latitude and longitude' do
      expect(Location.new(1, 3)).to eq(Location.new(1, 3))
    end

    it 'is not equal to different location' do
      expect(Location.new(1,2)).not_to eq(Location.new(3, 4))
    end

    it 'is not equal to object of another class' do
      expect(Location.new(0, 0)).not_to eq('test')
    end
  end

  describe '#to_s' do
    it 'returns string representation of location' do
      expect(Location.new(0, 1).to_s).to eq('0.0, 1.0')
    end
  end

  describe '#to_a' do
    it 'returns array of latitude and longitude' do
      expect(Location.new(3, 4).to_a).to eq([3.0, 4.0])
    end
  end
end
