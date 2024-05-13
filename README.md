# k8s-test
exploring Kubernetes local development

## SSH Configuration for github
### Steps to create ssh key for GitHub

1. ssh-keygen -t ed25519 -C "virginiaxxxxx@gmail.com"
2. Enter a file in which to save the key (/Users/YOU/.ssh/id_ALGORITHM): [Press enter]
/Users/virginiahamra/.ssh/id_szam
3. Passphrase: XXXX
4. eval "$(ssh-agent -s)"
5. cat ~/.ssh/config
6. ssh-add --apple-use-keychain ~/.ssh/id_szam
7. pbcopy < /Users/virginiahamra/.ssh/id_szam.pub (public key to add to github)
8. git clone _git@github.com:Szamanka/k8s-test.git_

### If there are any problems with ssh key and access to repository:

#### Troubleshooting commands:

1. Shows keys being evaluated by agent:
    `ssh-add -l`   
2. Shows all existent ssh keys:
    `ls -al ~/.ssh`
3. Shows me the fingerprint of selected ssh key:

    `ssh-keygen -l -f /Users/virginiahamra/.ssh/id_szam`
4. Add the key to the agent that is evaluating it:

   `eval "$(ssh-agent -s)"`

   `ssh-add --apple-use-keychain ~/.ssh/id_szam`


## minikube installation (MacOs)
1. brew install hyperkit (or virtualbox)
2. command to install using curl

```js
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

3. `minikube start --driver=hyperkit`
4. Enable Docker Environment: Run the following command to set up the Docker environment variables for the Minikube VM: `eval $(minikube docker-env)`
5. Access Docker Commands: `docker ps`
6. Access Docker inside VM Hyperlink with ssh (Optional):
    `minikube ip`

    `ssh docker@<minikube-ip>`

_Exit Docker Environment: `eval $(minikube docker-env -u)`_

_`docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"`_

8. Build docker image from your app inside minikube: `docker build -t simple-flask-app .`
9. Apply k8s deployment: `kubectl apply -f minikube/deploy/k8s.yaml`
10. Expose the service: `kubectl expose deployment simple-flask-app --type=NodePort --port=5000`
11. check: 
    `minikube service list` 
    `kubectl get svc`
    `kubectl get pods`
12. logs: `kubectl logs <podname>`


#### iterative development (redeploy after code change)

1. make change in app.py
2. ensure you're pointing to minikube's Docker using: `minikube docker-env`
3. Delete deployment and image:
    `kubectl delete -f minikube/deploy/k8s.yaml`
    `docker rmi simple-flask-app`
4. Rebuild image and re-deploy:
    `docker build -t simple-flask-app .`
    `kubectl apply -f minikube/deploy/k8s.yaml`

```
kubectl delete -f minikube/deploy/k8s.yaml;docker rmi simple-flask-app;docker build -t simple-flask-app .;kubectl apply -f minikube/deploy/k8s.yaml
```
#### Extra troubleshooting:
- If working with VPN, or vm hyperkit not connection to internet:
1. `minikube stop` and disconnect from VPN
2. `export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.39.0/24,$(minikube ip)`
3. listen adress from dockerhost
    `minikube start --listen-address=192.168.64.3 --driver=hyperkit --memory 4000 --cpus 2 container-runtime=docker`


_`kubectl get nodes`_

#### upload docker image to registry before deployment

1. Build image.
2. `docker tag simple-flask-app localhost:5000/simple-flask-app:latest`
3. `docker push localhost:5000/simple-flask-app:latest`
4. change deployment specs `image: localhost:5000/simple-flask-app:latest`

# Node App simple

1. In your terminal, folder project run:
```js
npm init -y # Generate package.json
npm i express # Install express
touch index.js # Create a new index.js file
```

2. for this app example run:
```js
npm i unique-names-generator
```

3. in `package.json` add:
```js
"scripts": {
    "start": "node index.js"
 }
 ```

 4. Create Dockerfile
 5. `minikube start`
 6. Create Image inside Minikube:
```js

 eval $(minikube docker-env)
docker build -t starwars-node .
```
```js
# Additionally you can check to see if starwars-node Docker image is in minikube by

minikube ssh

docker@minikube:~$ docker images
# You should see starward-node docker image
```

7. Create K8s Deployment:

`kubectl apply -f minikube/deploy/sw-deployment.yaml`

8. Check creation of pod/s
`kubectl get pod`
`kubectl describe pod <podname>`
if any shows **ErrImagePull** or **ImagePullBackOff** add this to sw-deployment:
```js
ports:
  - containerPort: 3000
imagePullPolicy: Never # Image should not be pulled
```

9. Re-Deploy:
```js
kubectl get deployment
# You'll see star-wars-deployment 
kubectl delete deployment star-wars-deployment
# deployment.apps "star-wars-deployment" deleted
kubectl get deployment
# You should not see star-wars-deployment
kubectl apply -f minikube/deploy/sw-deployment.yaml
# deployment.apps/star-wars-deployment created
kubectl get pod
# You should see two pods in "Running" STATUS
```

10. Add Service to expose the node app to external ip:

```js
kubectl apply -f minikube/deploy/sw-service.yaml
# service/sw-service created
kubectl get service
# Observe that sw-service created
minikube service sw-service --url
# http://<external_service_ip>:31000
```

11. add _ConfigMap_ and _env_ section in deployment, ConfigMap can be used to handle ENVs related to a container:


```js
kubectl apply -f minikube/deploy/envs.yaml
kubectl apply -f minikube/deploy/sw-deployment.yaml
```

12. `minikube service sw-service --url`

13. Finish lab:
- Delete all pods from the deployment
`kubectl delete deployment star-wars-deployment` 

- `minikube stop`