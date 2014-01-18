# Create New Private Key
# openssl genrsa 2048 > server.key
# Show server.key
openssl rsa -text < server.key

# Create Certificate Request
openssl req -new -key server.key > server.csr
# Show server.csr
openssl req -text < server.csr

# Create Certificate Key
openssl x509 -days 9999 -req -signkey server.key < server.csr > server.crt
