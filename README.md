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