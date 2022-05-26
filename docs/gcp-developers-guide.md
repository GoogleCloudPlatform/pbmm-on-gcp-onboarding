# GCP Developers Guide
# CSR - Working with
## Cloning a cloud source repository in google cloud shell
```
# reauthenticate
gcloud init
gcloud source repos clone traffic-generation --project=traffic-generation

git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README.md
        magellan-nbi/
        pom.xml

git add .
git config --global user.email "email"
git config --global user.name "name"
git commit -m "initial push of existing client/server rest api - from magellan"

git push -u origin master
Enumerating objects: 59, done.
...
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

## Setup a cloud build job
https://cloud.google.com/build/docs/building/build-java see https://github.com/GoogleCloudPlatform/cloud-build-samples/blob/main/maven-example/cloudbuild.yaml

update for Java 11 or 17 LTS (java.net.http.HttpClient)
https://github.com/GoogleCloudPlatform/cloud-build-samples/issues/97

using project source
https://github.com/obrienlabs/magellan/blob/master/magellan-nbi/src/main/java/global/packet/magellan/service/ForwardingServiceImpl.java

```
test buld locally
mvn clean install -U

[INFO] magellan-nbi ....................................... SUCCESS [ 32.499 s]
[INFO] magellan ........................................... SUCCESS [  1.743 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  34.786 s

Push cloudbuild.yaml
git push origin master

Your build failed to run: generic::invalid_argument: generic::invalid_argument: if 'build.service_account' is specified, the build must either (a) specify 'build.logs_bucket' (b) use the CLOUD_LOGGING_ONLY logging option, or (c) use the NONE logging option

Switch off the service account override
use the global (us) region

 CB build step gcr.io/cloud-builders/docker expects LC f as in Dockerfile not DockerFile

Create the Artifact Registry repository first to match the names below

Dockerfile
FROM openjdk:11
ARG USERVICE_HOME=/opt/app/
# Build up the deployment folder structure
RUN mkdir -p $USERVICE_HOME
ADD magellan-nbi/target/magellan-nbi-*.jar $USERVICE_HOME/ROOT.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/app/ROOT.jar"]

cloudbuild.yaml
steps:
#  - name: maven:3-jdk-11
#    entrypoint: mvn
#    args: ["test"]
  - name: maven:3-jdk-11
    entrypoint: mvn
    args: ["package", "-Dmaven.test.skip=true -DskipTests=true"]
  - name: gcr.io/cloud-builders/docker
  # gcr.io/
    args: ["build", "-t", "northamerica-northeast1-docker.pkg.dev/$PROJECT_ID/traffic-generation/traffic-generation", "--build-arg=JAR_FILE=magellan-nbi/target/magellan-nbi-0.0.3-SNAPSHOT.jar", "."]
    #args: ['build', '-t', 'LOCATION-docker.pkg.dev/$PROJECT_ID/traffic-generation/magellan-nbi', '.' ]
images: 
 # ["gcr.io/$PROJECT_ID/magellan-nbi:latest"]
  ["northamerica-northeast1-docker.pkg.dev/$PROJECT_ID/traffic-generation/traffic-generation:latest"]
 
```

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
