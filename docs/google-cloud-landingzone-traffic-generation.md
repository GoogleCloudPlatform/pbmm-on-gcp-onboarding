# Traffic Generation for Dynamic Security Controls

## Diagram

<img width="1180" alt="Screen Shot 2022-06-20 at 15 16 10" src="https://user-images.githubusercontent.com/24765473/174665676-b82ac81b-d153-47bd-83d0-e26f7c495c12.png">


## Artifacts
- 2nd restricted permission user - with dev only permissions - see as reference a admin/bus/dev hierarchy in https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md#onboarding-accounts-and-projects-structure  - we will use the dev user to test restricted permission controls like the marketplace
- sh script of gcloud SDK commands for deploy/undeploy of following 
- CSR r/o shadow repo of the github traffic generation repo
- 2 Dockerfile s for NBI and SBI
- cloudbuild.yamls + Cloud Build triggers on NBI (generator) and SBI (backend + ORM database connector)
- Artifact Registry repository (NBI and SBI constainers)
- Cloud Run yamls (NBI and SBI)
- VPC Network
- Postgres SQL DB
- SCC standard

## Option 1: mirror github repo

Run both containers from https://github.com/obriensystems/magellan

fork repo
https://github.com/obrienlabs/magellan


## Option 2: Create CSR from Github
Using gcp.obrien.services Follow https://cloud.google.com/source-repositories/docs/adding-repositories-as-remotes

<img width="1731" alt="Screen Shot 2022-06-13 at 21 55 16" src="https://user-images.githubusercontent.com/24765473/173476846-42d0e2d8-ad62-42ad-9124-771b7b5c7cfc.png">

```
in Google Cloud Shell
admin_super@cloudshell:~$ mkdir traffic
admin_super@cloudshell:~$ cd traffic
admin_super@cloudshell:~/traffic$ gcloud config set project traffic-os
Updated property [core/project].
admin_super@cloudshell:~/traffic (traffic-os)$ git clone https://github.com/obrienlabs/magellan.git
Cloning into 'reference-architecture'...
remote: Total 277 (delta 82), reused 217 (delta 43), pack-reused 0
Receiving objects: 100% (277/277), 52.98 KiB | 3.78 MiB/s, done.
Resolving deltas: 100% (82/82), done.admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git config --global credential.'https://source.developers.google.com'.helper gcloud.sh
admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ gcloud source repos create reference-architecture
Created [reference-architecture].
WARNING: You may be billed for this repository. See https://cloud.google.com/source-repositories/docs/pricing for details.admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git remote add google https://source.developers.google.com/p/traffic-os/r/reference-architectureadmin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git push google main
Total 277 (delta 82), reused 277 (delta 82), pack-reused 0
remote: Resolving deltas: 100% (82/82)
To https://source.developers.google.com/p/traffic-os/r/reference-architecture
* [new branch] main -> main
```
CSR repo now populated from github
https://source.cloud.google.com/traffic-os/reference-architecture/+/main:

<img width="1732" alt="Screen Shot 2022-06-13 at 21 56 11" src="https://user-images.githubusercontent.com/24765473/173476948-b8187f44-e122-4df7-a678-e26864378311.png">

## Enable APIs

```
# get existing APIs enabled
admin_super@cloudshell:~ (traffic-os)$ gcloud services list --enabled --project traffic-os | grep NAME
NAME: artifactregistry.googleapis.com
NAME: bigquery.googleapis.com
NAME: bigquerymigration.googleapis.com
NAME: bigquerystorage.googleapis.com
NAME: cloudapis.googleapis.com
NAME: cloudbuild.googleapis.com
NAME: clouddebugger.googleapis.com
NAME: cloudtrace.googleapis.com
NAME: containerregistry.googleapis.com
NAME: datastore.googleapis.com
NAME: logging.googleapis.com
NAME: monitoring.googleapis.com
NAME: pubsub.googleapis.com
NAME: servicemanagement.googleapis.com
NAME: serviceusage.googleapis.com
NAME: sourcerepo.googleapis.com
NAME: sql-component.googleapis.com
NAME: storage-api.googleapis.com
NAME: storage-component.googleapis.com
NAME: storage.googleapis.com

#IE enable compute
admin_super@cloudshell:~ (traffic-os)$ gcloud services enable compute.googleapis.com
Operation "operations/acf.p2-25019029317-d92a4bf7-833e-49ff-86a7-20e8b7ad7585" finished successfully.
```

## Adjust local code

Configure git
```
admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git config --global user.email "micha..rg"
admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git config --global user.name "Mic..ien"

admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git add Dockerfile
admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git commit -m "move Dockerfile for sbi"
admin_super@cloudshell:~/traffic/reference-architecture (traffic-os)$ git push google main

```


## Add Artifact Repositories

## Add Cloud Build Triggers

## Add Postgres SQL backend DB

```
Region
northamerica-northeast1 (Montréal)
DB Version
PostgreSQL 14
vCPUs
2 vCPU
Memory
3.75 GB
Storage
10 GB
Network throughput (MB/s) 
500 of 2,000
Disk throughput (MB/s)
Read: 4.8 of 240.0
Write: 4.8 of 144.0
IOPS 
Read: 300 of 15,000
Write: 300 of 9,000
Connections
Public IP
Backup
Automated
Availability
Single zone
Point-in-time recovery
Enabled
```

## Add Cloud Run instance

```
gcloud run deploy traffic-generation-target \
--image=northamerica-northeast1-docker.pkg.dev/traffic-os/traffic-generation-target/traffic-generation-target@sha256:dc34cd9de43dbda8fddce647d54d79a49718391c4032453aa17c28716fc215e5 \
--allow-unauthenticated \
--service-account=25019029317-compute@developer.gserviceaccount.com \
--timeout=30 \
--cpu=2 \
--memory=4Gi \
--execution-environment=gen2 \
--region=northamerica-northeast1 \
--project=traffic-os
```

## Deploy instance to a VPC public subnet

```
gcloud compute instances create traffic-target-public --project=traffic-os --zone=northamerica-northeast1-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=25019029317-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=traffic-target-public,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220519,mode=rw,size=10,type=projects/traffic-os/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```

## VPC private subnet testing via VPC Connector to VMs

```

Test public VM first

get image from cloud run
northamerica-northeast1-docker.pkg.dev/traffic-os/traffic-generation/traffic-generation@sha256:5a8ba156be1baa972eb49d90a69ee97e3984aae75d783e1e132db5275f392781


gcloud compute instances create-with-container traffic-generation-target2 --project=traffic-os --zone=northamerica-northeast1-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=public --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=25019029317-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server,https-server --image=projects/cos-cloud/global/images/cos-stable-97-16919-29-40 --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=traffic-generation-target2 --container-image=northamerica-northeast1-docker.pkg.dev/traffic-os/traffic-generation/traffic-generation@sha256:5a8ba156be1baa972eb49d90a69ee97e3984aae75d783e1e132db5275f392781 --container-restart-policy=always --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=container-vm=cos-stable-97-16919-29-40

firewall 22 to allow for ssh and 8080


gcloud compute --project=traffic-os firewall-rules create target-allow-ssh2 --direction=INGRESS --priority=65534 --network=target --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0 --enable-logging
gcloud compute --project=traffic-os firewall-rules create target-allow-8080 --direction=INGRESS --priority=65534 --network=target --action=ALLOW --rules=tcp:8080 --source-ranges=0.0.0.0/0 --enable-logging

specified target = all instances in network

http://35.203.30.93:8080/nbi/api

source

curl -X GET "https://traffic-generation-magellan-3kihlp5xlq-nn.a.run.app/nbi/forward/traffic?chaosPercentage=0.0&client=1&delay=1000&dns=http%3A%2F%2F35.203.30.93&iterations=10&region=1&to=8080&useCaseNumber=1" -H "accept: */*"

target
2022-06-20 16:23:45.447 DEBUG 1 --- [nio-8080-exec-6] o.s.web.servlet.DispatcherServlet        : GET "/nbi/api?usecasename=uc1&client=1&requestnumber=9&timestamp=1655742225439&loadGeneratorRegionName=1", parameters={masked}
2022-06-20 16:23:45.449 DEBUG 1 --- [nio-8080-exec-6] s.w.s.m.m.a.RequestMappingHandlerMapping : Mapped to global.packet.magellan.controller.ApiController#process(String, HttpServletRequest)
2022-06-20 16:23:45.452  INFO 1 --- [nio-8080-exec-6] g.p.magellan.controller.ApiController    : PASS remoteAddr: 35.203.252.142 localAddr: 10.0.0.2 remoteHost: 35.203.252.142 serverName: 35.203.30.93
2022-06-20 16:23:45.454 DEBUG 1 --- [nio-8080-exec-6] m.m.a.RequestResponseBodyMethodProcessor : Using 'application/json', given [*/*] and supported [application/json, application/*+json, application/json, application/*+json, application/x-jackson-smile, application/cbor]
2022-06-20 16:23:45.454 DEBUG 1 --- [nio-8080-exec-6] m.m.a.RequestResponseBodyMethodProcessor : Writing [global.packet.magellan.controller.Api@5d227503]
2022-06-20 16:23:45.457 DEBUG 1 --- [nio-8080-exec-6] o.s.web.servlet.DispatcherServlet        : Completed 200 OK


Test private vm

gcloud compute instances create-with-container traffic-generation-target-private --project=traffic-os --zone=northamerica-northeast1-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=private --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=25019029317-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server,https-server --image=projects/cos-cloud/global/images/cos-stable-97-16919-29-40 --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=traffic-generation-target-private --container-image=northamerica-northeast1-docker.pkg.dev/traffic-os/traffic-generation/traffic-generation@sha256:5a8ba156be1baa972eb49d90a69ee97e3984aae75d783e1e132db5275f392781 --container-restart-policy=always --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=container-vm=cos-stable-97-16919-29-40


admin_super@traffic-generation-target-private ~ $ docker ps
CONTAINER ID   IMAGE                                                                                     COMMAND                  CREATED          STATUS          PORTS     NAMES
c1698d7f484e   northamerica-northeast1-docker.pkg.dev/traffic-os/traffic-generation/traffic-generation   "java -Djava.securit…"   23 seconds ago   Up 22 seconds             klt-traffic-generation-target-private-djen
efc51a04cb2d   gcr.io/stackdriver-agents/stackdriver-logging-agent:1.9.4                                 "/entrypoint.sh /usr…"   38 seconds ago   Up 35 seconds             stackdriver-logging-agent

notice the logging agent


admin_super@traffic-generation-target-private ~ $ curl http://127.0.0.1:8080/nbi/api
{"id":1,"content":"PASS remoteAddr: 127.0.0.1 localAddr: 127.0.0.1 remoteHost: 127.0.0.1 serverName: 127.0.0.1"

enable serverless VPC access API

https://console.cloud.google.com/networking/connectors/add?project=traffic-os

gcloud compute networks vpc-access connectors create traffic-generation-priv \
--region=northamerica-northeast1 \
--network=target \
--range=10.0.3.0/28 \
--min-instances=2 \
--max-instances=10 \
--machine-type=e2-micro

cloud run

gcloud run deploy traffic-generation-magellan-private \
--image=northamerica-northeast1-docker.pkg.dev/traffic-os/traffic-generation/traffic-generation@sha256:5a8ba156be1baa972eb49d90a69ee97e3984aae75d783e1e132db5275f392781 \
--allow-unauthenticated \
--service-account=25019029317-compute@developer.gserviceaccount.com \
--timeout=30 \
--cpu=2 \
--memory=2Gi \
--vpc-connector=projects/traffic-os/locations/northamerica-northeast1/connectors/traffic-generation-privat \
--execution-environment=gen2 \
--region=northamerica-northeast1 \
--project=traffic-os

setup traffic
https://traffic-generation-magellan-private-3kihlp5xlq-nn.a.run.app/nbi/swagger-ui.html

curl -X GET "https://traffic-generation-magellan-private-3kihlp5xlq-nn.a.run.app/nbi/forward/traffic?chaosPercentage=0.0&client=1&delay=1000&dns=http%3A%2F%2F10.0.1.2&iterations=2&region=1&to=8080&useCaseNumber=1" -H "accept: */*"

2022-06-20 16:42:03.285 DEBUG 1 --- [nio-8080-exec-5] o.s.web.servlet.DispatcherServlet        : GET "/nbi/api?usecasename=uc1&client=1&requestnumber=1&timestamp=1655743322782&loadGeneratorRegionName=1", parameters={masked}
2022-06-20 16:42:03.286 DEBUG 1 --- [nio-8080-exec-5] s.w.s.m.m.a.RequestMappingHandlerMapping : Mapped to global.packet.magellan.controller.ApiController#process(String, HttpServletRequest)
2022-06-20 16:42:03.287  INFO 1 --- [nio-8080-exec-5] g.p.magellan.controller.ApiController    : PASS remoteAddr: 10.0.2.3 localAddr: 10.0.1.2 remoteHost: 10.0.2.3 serverName: 10.0.1.2
2022-06-20 16:42:03.288 DEBUG 1 --- [nio-8080-exec-5] m.m.a.RequestResponseBodyMethodProcessor : Using 'application/json', given [*/*] and supported [application/json, application/*+json, application/json, application/*+json, application/x-jackson-smile, application/cbor]
2022-06-20 16:42:03.289 DEBUG 1 --- [nio-8080-exec-5] m.m.a.RequestResponseBodyMethodProcessor : Writing [global.packet.magellan.controller.Api@665d01ad]
2022-06-20 16:42:03.291 DEBUG 1 --- [nio-8080-exec-5] o.s.web.servlet.DispatcherServlet        : Completed 200 OK

```

