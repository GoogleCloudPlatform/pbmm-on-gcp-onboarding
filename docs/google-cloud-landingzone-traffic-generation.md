# Traffic Generation for Dynamic Security Controls

## Artifacts
- sh script of gcloud SDK commands for deploy/undeploy of following 
- CSR r/o shadow repo of the github traffic generation repo
- 2 Dockerfile s for NBI and SBI
- cloudbuild.yamls + Cloud Build triggers on NBI (generator) and SBI (backend + ORM database connector)
- Artifact Registry repository (NBI and SBI constainers)
- Cloud Run yamls (NBI and SBI)
- VPC Network
- Postgres SQL DB
- SCC standard


## Create CSR from Github
Using gcp.obrien.services Follow https://cloud.google.com/source-repositories/docs/adding-repositories-as-remotes

<img width="1731" alt="Screen Shot 2022-06-13 at 21 55 16" src="https://user-images.githubusercontent.com/24765473/173476846-42d0e2d8-ad62-42ad-9124-771b7b5c7cfc.png">

```
in Google Cloud Shell
admin_super@cloudshell:~$ mkdir traffic
admin_super@cloudshell:~$ cd traffic
admin_super@cloudshell:~/traffic$ gcloud config set project traffic-os
Updated property [core/project].
admin_super@cloudshell:~/traffic (traffic-os)$ git clone  https://github.com/cloud-quickstart/reference-architecture.git
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

