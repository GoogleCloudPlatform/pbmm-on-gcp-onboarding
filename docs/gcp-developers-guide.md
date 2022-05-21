# GCP Developers Guide

## VPC Networks
### VPC Network Options

```
# vpc creation for GKE autopilot cluster
gcloud compute networks create fmo-gke-ap --project=fmichaelobrien-gke --description=fmo-gke-ap --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create fmo-gke-ap-snet1 --project=fmichaelobrien-gke --description=fmo-gke-ap-snet1 --range=10.0.0.0/24 --stack-type=IPV4_ONLY --network=fmo-gke-ap --region=northamerica-northeast1 --enable-private-ip-google-access --enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=0.5 --logging-metadata=include-all

# GKE autopilot cluster - public
gcloud container --project "fmichaelobrien-gke" clusters create-auto "fmichaelobrien-dev-gke-ap" --region "northamerica-northeast1" --release-channel "regular" --network "projects/fmichaelobrien-gke/global/networks/fmo-gke-ap" --subnetwork "projects/fmichaelobrien-gke/regions/northamerica-northeast1/subnetworks/fmo-gke-ap-snet1" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"

# GKE autopilot cluster - private
gcloud container --project "fmichaelobrien-gke" clusters create-auto "gke-dev-ap1" --region "northamerica-northeast1" --release-channel "regular" --enable-private-nodes --master-ipv4-cidr "10.0.1.0/28" --network "projects/fmichaelobrien-gke/global/networks/fmo-gke-ap" --subnetwork "projects/fmichaelobrien-gke/regions/northamerica-northeast1/subnetworks/fmo-gke-ap-snet1" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"

or
admin_@cloudshell:~$ gcloud config set project fmichaelobrien-gke
Updated property [core/project].
admin_@cloudshell:~ (fmichaelobrien-gke)$ gcloud container --project "fmichaelobrien-gke" clusters create-auto "gke-ap-priv2" --region "northamerica-northeast1" --release-channel "regular" --enable-private-nodes --master-ipv4-cidr "10.0.2.0/28" --network "projects/fmichaelobrien-gke/global/networks/fmo-gke-ap" --subnetwork "projects/fmichaelobrien-gke/regions/northamerica-northeast1/subnetworks/fmo-gke-ap-snet1" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"
Note: This cluster has private nodes. If you need connectivity to the public internet, for example to pull public containers, you must configure Cloud NAT. To enable NAT for the network of this cluster, run the following commands:
gcloud compute routers create my-router --region northamerica-northeast1 --network default --project=fmichaelobrien-gke
gcloud beta compute routers nats create nat --router=my-router --region=northamerica-northeast1 --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --project=fmichaelobrien-gke
Note: The Pod address range limits the maximum size of the cluster. Please refer to https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr to learn how to optimize IP address allocation.
Creating cluster gke-ap-priv2 in northamerica-northeast1... Cluster is being configured...working..
Creating cluster gke-ap-priv2 in northamerica-northeast1... Cluster is being health-checked (master is healthy)...working.  
Created [https://container.googleapis.com/v1/projects/fmichaelobrien-gke/zones/northamerica-northeast1/clusters/gke-ap-priv2].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/northamerica-northeast1/gke-ap-priv2?project=fmichaelobrien-gke
kubeconfig entry generated for gke-ap-priv2.
NAME: gke-ap-priv2
LOCATION: northamerica-northeast1
MASTER_VERSION: 1.21.11-gke.900
MASTER_IP: 34.n.n.44
MACHINE_TYPE: e2-medium
NODE_VERSION: 1.21.11-gke.900
NUM_NODES: 3
STATUS: RUNNING



```
Setup cloudNAT https://cloud.google.com/nat/docs/gke-example?_gl=1*u5wfl6*_ga*NjMzNDAxMy4xNjM3ODY3NzY5*_ga_WH2QY8WWF5*MTY1MzE1NjIzMC41LjEuMTY1MzE1NjI2Ny4w&_ga=2.100146265.-6334013.1637867769
