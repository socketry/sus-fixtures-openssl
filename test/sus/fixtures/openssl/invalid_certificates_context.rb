# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'sus/fixtures/openssl/invalid_certificate_context'

describe Sus::Fixtures::OpenSSL::InvalidCertificateContext do
	include Sus::Fixtures::OpenSSL::InvalidCertificateContext
	
	it "has a valid certificate authority" do
		expect(certificate_authority_certificate).to be(:verify, certificate_authority_key)
	end
	
	it "can't validate client certificate" do
		expect(certificate_store).not.to be(:verify, certificate)
	end
end
