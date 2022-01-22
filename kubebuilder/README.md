# Kubebuilder

Following along with https://book.kubebuilder.io/quick-start.html#create-a-project

If you are editing the API definitions, generate the manifests such as CRs or CRDs using

```
make manifests
```

## Test It Out

Run cluster with Kind

Install the CRDs into the cluster:

```
make install
```

Run your controller
```
make run
```

install custom resource

```
kubectl apply -f config/samples/
```
