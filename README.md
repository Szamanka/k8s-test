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

## minikube installation (MacOs)
1. brew install hyperkit (or virtualbox)
2. command to install using curl

```js
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

3. minikube start --driver=hyperkit

