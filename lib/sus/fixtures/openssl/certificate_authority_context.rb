# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'openssl'

module Sus
	module Fixtures
		module OpenSSL
			module CertificateAuthorityContext
				# This key size is generally considered insecure, but it's fine for testing.
				def certificate_authority_key
					@certificate_authority_key ||= ::OpenSSL::PKey::RSA.new(2048)
				end
				
				def certificate_authority_name
					@certificate_authority_name ||= ::OpenSSL::X509::Name.parse("O=TestCA/CN=localhost")
				end
				
				# The certificate authority is used for signing and validating the certificate which is used for communciation:
				def certificate_authority_certificate
					@certificate_authority_certificate ||= ::OpenSSL::X509::Certificate.new.tap do |certificate|
						certificate.subject = certificate_authority_name
						# We use the same issuer as the subject, which makes this certificate self-signed:
						certificate.issuer = certificate_authority_name
						
						certificate.public_key = certificate_authority_key.public_key
						
						certificate.serial = 1
						certificate.version = 2
						
						certificate.not_before = Time.now - 10
						certificate.not_after = Time.now + 3600
						
						extension_factory = ::OpenSSL::X509::ExtensionFactory.new
						extension_factory.subject_certificate = certificate
						extension_factory.issuer_certificate = certificate
						certificate.add_extension extension_factory.create_extension("basicConstraints", "CA:TRUE", true)
						certificate.add_extension extension_factory.create_extension("keyUsage", "keyCertSign, cRLSign", true)
						certificate.add_extension extension_factory.create_extension("subjectKeyIdentifier", "hash")
						certificate.add_extension extension_factory.create_extension("authorityKeyIdentifier", "keyid:always", false)
						
						certificate.sign certificate_authority_key, ::OpenSSL::Digest::SHA256.new
					end
				end
				
				def certificate_store
					@certificate_store ||= ::OpenSSL::X509::Store.new.tap do |certificates|
						certificates.add_cert(certificate_authority_certificate)
					end
				end
			end
		end
	end
end
