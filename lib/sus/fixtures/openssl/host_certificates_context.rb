# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require_relative 'certificate_authority_context'

module Sus
	module Fixtures
		module OpenSSL
			module HostCertificatesContext
				include CertificateAuthorityContext
			
				def keys
					@keys ||= Hash[
						hosts.collect{|name| [name, ::OpenSSL::PKey::RSA.new(2048)]}
					]
				end
				
				# The certificate used for actual communication:
				def certificates
					@certificates ||= Hash[
						hosts.collect do |name|
							certificate_name = ::OpenSSL::X509::Name.parse("O=Test/CN=#{name}")
							
							certificate = ::OpenSSL::X509::Certificate.new
							certificate.subject = certificate_name
							certificate.issuer = certificate_authority_certificate.subject
							
							certificate.public_key = keys[name].public_key
							
							certificate.serial = 2
							certificate.version = 2
							
							certificate.not_before = Time.now
							certificate.not_after = Time.now + 3600
							
							extension_factory = ::OpenSSL::X509::ExtensionFactory.new
							extension_factory.subject_certificate = certificate
							extension_factory.issuer_certificate = certificate_authority_certificate
							certificate.add_extension extension_factory.create_extension("keyUsage", "digitalSignature", true)
							certificate.add_extension extension_factory.create_extension("subjectKeyIdentifier", "hash")
							
							certificate.sign certificate_authority_key, ::OpenSSL::Digest::SHA256.new
							
							[name, certificate]
						end
					]
				end
				
				def server_context
					@server_context ||= ::OpenSSL::SSL::SSLContext.new.tap do |context|
						context.servername_cb = Proc.new do |socket, name|
							if hosts.include? name
								socket.hostname = name
								
								::OpenSSL::SSL::SSLContext.new.tap do |context|
									context.cert = certificates[name]
									context.key = keys[name]
								end
							end
						end
					end
				end
				
				def client_context
					@client_context ||= ::OpenSSL::SSL::SSLContext.new.tap do |context|
						context.cert_store = certificate_store
						context.verify_mode = ::OpenSSL::SSL::VERIFY_PEER
					end
				end
			end
		end
	end
end
