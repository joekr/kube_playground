# Local Cluster

This is just a simple way to launch a local cluster and deploy a hello world. Most of these steps come from 3rd party website, I just don't want to forget the steps I took to launch.

## links
- https://cluster-api.sigs.k8s.io/user/quick-start.html
- https://github.com/kubernetes-sigs/cluster-api/issues/4027#issuecomment-784702753
- https://cluster-api.sigs.k8s.io/clusterctl/developers.html#additional-notes-for-the-docker-provider
- https://kind.sigs.k8s.io/docs/user/local-registry/# Local Cluster

This is just a simple way to launch a local cluster and deploy a hello world. Most of these steps come from 3rd party website, I just don't want to forget the steps I took to launch.

# Steps
make sure to follow the quick start to get prerequisites setup.

1. run `kind-with-registry.sh `
1. `clusterctl init --infrastructure docker`
1. `export SERVICE_CIDR=["10.96.0.0/12"]` `export POD_CIDR=["192.168.0.0/16"]` `export SERVICE_DOMAIN="k8s.test"`
1. ```clusterctl generate cluster capi-quickstart --flavor development \
  --kubernetes-version v1.22.0 \
  --control-plane-machine-count=3 \
  --worker-machine-count=3 \
  > capi-quickstart.yaml
``
1. `kubectl apply -f capi-quickstart.yaml`
1. `kubectl get kubeadmcontrolplane` wait for capi-quickstart-control-plane to be `INITIALIZED`
1. `clusterctl get kubeconfig capi-quickstart > capi-quickstart.kubeconfig`
1. `clusterctl get kubeconfig capi-quickstart > capi-quickstart.kubeconfig`
1. `sed -i -e "s/server:.*/server: https:\/\/$(docker port capi-quickstart-lb 6443/tcp | sed "s/0.0.0.0/127.0.0.1/")/g" ./capi-quickstart.kubeconfig`
1. `sed -i -e "s/certificate-authority-data:.*/insecure-skip-tls-verify: true/g" ./capi-quickstart.kubeconfig`
1. `kubectl --kubeconfig=./capi-quickstart.kubeconfig apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml`
1. `kubectl --kubeconfig=./capi-quickstart.kubeconfig get nodes`
1. `docker build . -t forketyfork/hello-world`
1. `docker tag forketyfork/hello-world localhost:5000/hello-app:1.0`
1. `docker push localhost:5000/hello-app:1.0`
1. `kubectl create -f helloworld.yml`
1. `kubectl get pods`
1. `kubectl logs hello-world-[id]`

Then to take down
1. `kubectl delete cluster capi-quickstart`
1. `kind delete cluster`

## links
- https://cluster-api.sigs.k8s.io/user/quick-start.html
- https://github.com/kubernetes-sigs/cluster-api/issues/4027#issuecomment-784702753
- https://cluster-api.sigs.k8s.io/clusterctl/developers.html#additional-notes-for-the-docker-provider
- https://kind.sigs.k8s.io/docs/user/local-registry/
