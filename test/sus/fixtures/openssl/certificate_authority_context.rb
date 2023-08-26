# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'sus/fixtures/openssl/certificate_authority_context'

describe Sus::Fixtures::OpenSSL::CertificateAuthorityContext do
	include Sus::Fixtures::OpenSSL::CertificateAuthorityContext
	
	it "has a valid certificate authority" do
		expect(certificate_authority_certificate).to be(:verify, certificate_authority_key)
	end
end
