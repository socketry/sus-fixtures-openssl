# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'sus/fixtures/openssl'

describe Sus::Fixtures::OpenSSL do
	it "has a version" do
		expect(Sus::Fixtures::OpenSSL::VERSION).to be =~ /^\d+\.\d+\.\d+$/
	end
end
