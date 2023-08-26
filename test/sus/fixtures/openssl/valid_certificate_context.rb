# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'sus/fixtures/openssl/valid_certificate_context'

describe Sus::Fixtures::OpenSSL::ValidCertificateContext do
	include Sus::Fixtures::OpenSSL::ValidCertificateContext
	
	it "has a valid certificate authority" do
		expect(certificate_authority_certificate).to be(:verify, certificate_authority_key)
	end
	
	it "can validate client certificate" do
		expect(certificate_store).to be(:verify, certificate)
	end
end
