require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:bets) }
  it { should have_many(:games) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
end
