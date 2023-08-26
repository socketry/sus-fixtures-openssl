# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require_relative 'certificate_authority_context'

module Sus
	module Fixtures
		module OpenSSL
			module ValidCertificateContext
				include CertificateAuthorityContext
				
				# The private key to use on the server side:
				def key
					@key ||= ::OpenSSL::PKey::RSA.new(2048)
				end
				
				def certificate_name
					::OpenSSL::X509::Name.parse("O=Test/CN=localhost")
				end
				
				# The certificate used for actual communication:
				def certificate
					@certificate ||= ::OpenSSL::X509::Certificate.new.tap do |certificate|
						certificate.subject = certificate_name
						certificate.issuer = certificate_authority_certificate.subject
						
						certificate.public_key = key.public_key
						
						certificate.serial = 2
						certificate.version = 2
						
						# The certificate is valid for one hour:
						certificate.not_before = Time.now
						certificate.not_after = Time.now + 3600
						
						extension_factory = ::OpenSSL::X509::ExtensionFactory.new()
						extension_factory.subject_certificate = certificate
						extension_factory.issuer_certificate = certificate_authority_certificate
						certificate.add_extension extension_factory.create_extension("keyUsage", "digitalSignature", true)
						certificate.add_extension extension_factory.create_extension("subjectKeyIdentifier", "hash")
						
						certificate.sign certificate_authority_key, ::OpenSSL::Digest::SHA256.new
					end
				end
			end
		end
	end
end
