require 'rails_helper'

RSpec.describe Product, type: :model do

  describe 'validation' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_numericality_of(:price_in_cents).is_greater_than(0).only_integer }
  end

end
