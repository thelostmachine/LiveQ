require 'jwt'

payload = { data: 'test' }

ecdsa_key = OpenSSL::PKey::EC.new 'prime256v1'
ecdsa_key.generate_key
ecdsa_public = OpenSSL::PKey::EC.new ecdsa_key
ecdsa_public.private_key = "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgQBrLQ60S4TlWguRBoXLRmYUL6pqxDt/gtfXHivxH0qCgCgYIKoZIzj0DAQehRANCAARYxJjvueLnqHqHGbAtPsfp9pY6UWnAAEJhojEx6OtaKjSgxDRJdE6nXFsaCzLxf0NWk2wYVF/pvI9pyTFWYi8K"

token = JWT.encode payload, ecdsa_key, 'ES256'

# eyJhbGciOiJFUzI1NiJ9.eyJkYXRhIjoidGVzdCJ9.AlLW--kaF7EX1NMX9WJRuIW8NeRJbn2BLXHns7Q5TZr7Hy3lF6MOpMlp7GoxBFRLISQ6KrD0CJOrR8aogEsPeg
puts token

decoded_token = JWT.decode token, ecdsa_public, true, { algorithm: 'ES256' }

# Array
# [
#    {"test"=>"data"}, # payload
#    {"alg"=>"ES256"} # header
# ]








