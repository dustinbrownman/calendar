require 'spec_helper'

describe Todo do
  it { should validate_presence_of :description }

  it { should have_many :notes }
end
