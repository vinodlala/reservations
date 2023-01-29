require 'rails_helper'

RSpec.describe Reservation, type: :model do
  it { is_expected.to validate_presence_of(:contact_email) }
  it { is_expected.to validate_presence_of(:contact_phone) }
  it { is_expected.to validate_presence_of(:party_name) }
  it { is_expected.to validate_presence_of(:party_size) }
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_presence_of(:ends_at) }
end
