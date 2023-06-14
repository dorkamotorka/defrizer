## Dependencies

Install `faas-cli` to interact with the OpenFaaS gateway.

	curl -sSL https://cli.openfaas.com | sudo -E sh	

## Commands

	microk8s helm repo add openfaas https://openfaas.github.io/faas-netes/
	microk8s kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
	microk8s helm upgrade openfaas --install openfaas/openfaas --namespace openfaas -f faas-values.yml

	PASSWORD=$(microk8s kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
	env | grep PASSWORD

	microk8s kubectl port-forward -n openfaas svc/gateway 8080:8080 &
	microk8s kubectl port-forward -n openfaas svc/prometheus 9090:9090 &
	echo -n $PASSWORD | faas-cli login --username admin --password-stdin

	faas-cli new --lang python3 hello-python
	faas-cli build -f hello-python.yml
	faas-cli push -f hello-python.yml
	faas-cli deploy -f hello-python.yml
	echo "My name is Teo" | faas-cli invoke hello-python

## UI 

To view the OpenFaaS UI on a local machine, use SSH port-forwarding:

	ssh -L 127.0.0.1:8080:127.0.0.1:8080 -N ubuntu@88.200.23.156

and then you should be able to view it in browser `http://localhost:8080/ui/`.

You can retrieve the credentials using:

	microk8s kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo

while the username is `admin`. 
