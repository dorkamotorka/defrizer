# Commands

	helm upgrade openfaas --install openfaas/openfaas --namespace openfaas -f faas-values.yml

	PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
	env | grep PASSWORD
	echo -n $PASSWORD | faas-cli login --username admin --password-stdin

	kubectl port-forward -n openfaas svc/gateway 8080:8080 &
	kubectl port-forward -n openfaas svc/prometheus 9090:9090 &

	faas-cli new --lang python3 hello-python
	faas-cli build -f hello-python.yml
	faas-cli push -f hello-python.yml
	faas-cli deploy -f hello-python.yml
	echo "My name is Teo" | faas-cli invoke hello-python

## UI 

To view the OpenFaaS UI on a local machine, use SSH port-forwarding:

	ssh -L 127.0.0.1:8080:127.0.0.1:8080 -N ubuntu@88.200.23.239

and then you should be able to view it in browser `http://localhost:8080/ui/`.

You can retrieve the credentials using:

	kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo

while the username is `admin`. 
