# GCP Developers Guide

## VPC Networks
### VPC Network Options

```
# vpc creation for GKE autopilot cluster
gcloud compute networks create fmo-gke-ap --project=fmichaelobrien-gke --description=fmo-gke-ap --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create fmo-gke-ap-snet1 --project=fmichaelobrien-gke --description=fmo-gke-ap-snet1 --range=10.0.0.0/24 --stack-type=IPV4_ONLY --network=fmo-gke-ap --region=northamerica-northeast1 --enable-private-ip-google-access --enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=0.5 --logging-metadata=include-all

# GKE autopilot cluster
gcloud container --project "fmichaelobrien-gke" clusters create-auto "fmichaelobrien-dev-gke-ap" --region "northamerica-northeast1" --release-channel "regular" --network "projects/fmichaelobrien-gke/global/networks/fmo-gke-ap" --subnetwork "projects/fmichaelobrien-gke/regions/northamerica-northeast1/subnetworks/fmo-gke-ap-snet1" --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"

```
