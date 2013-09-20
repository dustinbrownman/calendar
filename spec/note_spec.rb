require 'spec_helper'

describe Note do 
	it { should validate_presence_of :body }

	it { should belong_to :notable }

end