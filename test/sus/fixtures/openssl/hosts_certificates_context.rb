# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'sus/fixtures/openssl/hosts_certificates_context'

describe Sus::Fixtures::OpenSSL::HostsCertificatesContext do
	include Sus::Fixtures::OpenSSL::HostsCertificatesContext
	
	it 'defaults to no hosts' do
		expect(hosts).to be(:empty?)
	end
	
	with 'a host name' do
		def hosts
			["suspicious.localhost"]
		end
		
		it "can establish a connection" do
			tcp_server = TCPServer.new("localhost", 0)
			ssl_server = OpenSSL::SSL::SSLServer.new(tcp_server, server_context)
			
			server_thread = Thread.new do
				peer = ssl_server.accept
				peer.puts peer.gets
			end
			
			tcp_client = TCPSocket.new("localhost", tcp_server.local_address.ip_port)
			ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client, client_context)
			
			# You must specify the host name that the client will provide to the server:
			ssl_client.hostname = hosts.first
			
			ssl_client.connect
			ssl_client.puts "Hello World"
			expect(ssl_client.gets).to be == "Hello World\n"
			
		ensure
			ssl_client&.close
			server_thread&.join
			ssl_server&.close
		end
	end
end
