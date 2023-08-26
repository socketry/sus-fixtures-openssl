# Sus::Fixtures::OpenSSL

Provides a convenient fixture for setting up client and server SSL sockets.

[![Development Status](https://github.com/ioquatix/sus-fixtures-openssl/workflows/Test/badge.svg)](https://github.com/ioquatix/sus-fixtures-openssl/actions?workflow=Test)

## Installation

``` bash
$ bundle add sus-fixtures-openssl
```

## Usage

``` ruby
include Sus::Fixtures::OpenSSL::HostCertificatesContext

it 'can create a secure connection' do
	# Use `server_context` to create a server socket:
	server_socket = OpenSSL::SSL::SSLSocket.new(socket, server_context)
	
	# Use `client_context` to create a client socket:
	client_socket = OpenSSL::SSL::SSLSocket.new(socket, client_context)
end
```

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

This project uses the [Developer Certificate of Origin](https://developercertificate.org/). All contributors to this project must agree to this document to have their contributions accepted.

### Contributor Covenant

This project is governed by [Contributor Covenant](https://www.contributor-covenant.org/). All contributors and participants agree to abide by its terms.
