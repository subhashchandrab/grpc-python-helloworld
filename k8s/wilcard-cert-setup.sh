#Create a root certificate and private key to sign the certificates for your services
mkdir example_certs1
cd example_certs1
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=example.com' -keyout istio-ca.key -out istio-ca.crt

#Generate a wildcard certificate and a private key for *.istio-example.com
openssl req -out istio-example.com.csr -newkey rsa:2048 -nodes -keyout istio-example.com.key -subj "/CN=istio-example.com/O=istio-example organization" 
>"istio-example.ext" cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = istio-example.com
DNS.2 = *.istio-example.com
EOF

openssl x509 -req -sha256 -extfile istio-example.ext -days 365 -CA istio-ca.crt -CAkey istio-ca.key -set_serial 0 -in istio-example.com.csr -out istio-example.com.crt

#Create the k8s secret using the crt and key files from above step to be attached to the istio-gateway for ssl termination
kubectl create -n istio-system secret tls istio-example-credential --key=istio-example.com.key  --cert=istio-example.com.crt