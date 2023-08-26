# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require_relative 'certificate_authority_context'

module Sus
	module Fixtures
		module OpenSSL
			module HostCertificatesContext
				include CertificateAuthorityContext
				
				def server_context
					::OpenSSLSSL::SSLContext.new.tap do |context|
						context.cert = certificate
						context.key = key
					end
				end

				def client_context
					::OpenSSLSSL::SSLContext.new.tap do |context|
						context.cert_store = certificate_store
						context.verify_mode = ::OpenSSLSSL::VERIFY_PEER
					end
				end
			end
		end
	end
end
