require 'spec_helper'

describe Todo do
  it { should validate_presence_of :description }
end
