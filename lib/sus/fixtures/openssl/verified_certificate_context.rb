# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require_relative 'certificate_authority_context'

module Sus
	module Fixtures
		module OpenSSL
			module VerifiedCertificateContext
				def server_context
					::OpenSSL::SSL::SSLContext.new.tap do |context|
						context.cert = certificate
						context.key = key
					end
				end

				def client_context
					::OpenSSL::SSL::SSLContext.new.tap do |context|
						context.cert_store = certificate_store
						context.verify_mode = ::OpenSSL::SSL::VERIFY_PEER
					end
				end
			end
		end
	end
end
