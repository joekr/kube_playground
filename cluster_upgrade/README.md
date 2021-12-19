# Cluster Upgrade

Simple playground to have a cluster that can be upgarded. We are going to do this pretty manaully. No real scripts right now... for fun.

This assumes you have kind setup and you can create a cluster `kind create cluster --config kind-config.yaml`. Where I got the Pod setup https://kind.sigs.k8s.io/docs/user/configuration/

Also, lets make sure we have a pod running we can check `kubectl apply -f replicas.yaml`

https://v1-21.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

If you want feel free to run `./foo-watch.sh` which will run curl commands against the cluster to make sure the application continues to run during the upgrade.


## Commands

*NOTE:* for this the commands will use 1.21.8 but that might not be the latest version

- get the running control-plane `docker ps`
- "login" `docker exect -it <id> bash` since we can't really SSH to nodes locally

### Control-Plane

Now you are on the control-plane node
- update kubeadm to 1.21.x-00
  - `apt update`
  - `apt install -y gnupg vim`
  - `curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -`
  - `vim /etc/apt/sources.list.d/kubernetes.list` and add `deb http://apt.kubernetes.io/ kubernetes-xenial main`
  - `apt-get update`
  - get the new 1.21 version`apt-cache madison kubeadm`
  - `apt install -y kubeadm=1.21.8-00`
  - make sure you have the new version `kubeadm version`
  - check the plan `kubeadm upgrade plan`
  - lets do this! `kubeadm upgrade apply v1.21.8`
  - now update kubelet `apt-get update && apt-get install -y --allow-change-held-packages kubelet=1.21.8-00 kubectl=1.21.8-00`
  - `systemctl daemon-reload`
  - `systemctl restart kubelet`
  - `exit`

### Worker nodes

We will be upgrading each worker node now. So we will repeat the follow steps for each worker node.

- drain the node `kubectl drain <node-to-drain> --ignore-daemonsets`

Connect to each worker and do the following

  - `apt update`
  - `apt install -y gnupg vim`
  - `curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -`
  - `vim /etc/apt/sources.list.d/kubernetes.list` and add `deb http://apt.kubernetes.io/ kubernetes-xenial main`
  - `apt-get update`
  - `kubeadm upgrade node`
  - now update kubelet `apt-get update && apt-get install -y --allow-change-held-packages kubelet=1.21.8-00 kubectl=1.21.8-00`
  - `systemctl daemon-reload`
  - `systemctl restart kubelet`
  - `exit`

After each upgrade

- `kubectl uncordon <node>`
