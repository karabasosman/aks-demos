# Scaling demos with AKS

## HPA and cluster autoscaler demo

Contact osman.karabas@microsoft.com if you need help!

### Part 1 Prerequisites

In order to run this demo, you will need the following:

- An active [Microsoft Azure](https://azure.microsoft.com/en-us/free "Microsoft Azure") Subscription
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/overview?view=azure-cli-latest "Azure CLI") installed
- [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/tasks/tools/install-kubectl/ "Kubernetes CLI (kubectl)") installed

### Part 2 Setup
Replace `<myResourceGroup>` with your expected and run following command to create resource group. Then remember the created resource group name.

```
$ az group create --name <myResourceGroup> --location eastus
```

Replace `<myResourceGroup>`,`<myK8sCluster>` with your expected and run following command to create the AKS. Then remember the AKS name.

```
$ az aks create --resource-group <myResourceGroup> --name <myK8sCluster> --node-count 3 --generate-ssh-keys
```

Replace `<myResourceGroup>`, `<myK8sCluster>` with your created in previous steps and run following command to set the AKS as your current connected cluster.

```
$ az aks get-credentials --resource-group <myResourceGroup> --name <myK8sCluster>
```

Make sure you're connected.

```
$ kubectl get nodes
```
### Part 3 Deploy voting app

Clone this repo
```
git clone https://github.com/karabasosman/aks-demos.git 
```

Change the folder
```
$ cd aci-demo/hpa
```

Deploy the app with all-in-one-azure-voting YAML file

```
kubectl apply -f all-in-one-azure-voting.yaml
```

Scale the app manually

```
kubectl autoscale deployment azure-vote-front --cpu-percent=50 --min=2 --max=10
```

Create a busybox container app to make load

```
kubectl run -it --rm load-generator --image=busybox /bin/sh

while true; do wget -q -O- http://azure-vote-front.hpa-demo.svc.cluster.local; done

```

Enable cluster autoscaler on your AKS cluster

```
az aks nodepool update   --resource-group <myResourceGroup>   --cluster-name <myK8sCluster>   --name agentpool --enable-cluster-autoscaler   --min-count 3 --max-count 15
```

Scale your app to trigger cluster autoscaling

```
kubectl scale deploy azure-vote-front --replicas=20
```

Disable cluster autoscaler on your AKS cluster

```
az aks nodepool update   --resource-group <myResourceGroup>  --cluster-name <myK8sCluster>   --name agentpool --disable-cluster-autoscaler   --node-count 3
```