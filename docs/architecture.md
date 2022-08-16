# PBMM Landing Zone - Architecture
## Purpose
Create a PBMM secure landing zone for the Google Cloud Environment. 

## Requirements
### R1: L7 Packet Inspection required
### R2: Workload separation
### R3: Centralized IP spece management

## Design Issues
The design of the landing zone follows GCP best practices and architecture principles at the following references.

- https://cloud.google.com/architecture/landing-zones
- https://cloud.google.com/architecture/framework
- 
### Decide on Shared VPC or Hub-and-spoke Network Topologies
The requirements of the landing zone involve a managed IP space and use of L7 packet inspection - which leans more towards use of Shared VPC's for each dev/stg/uat/prod environment.   See decision references in https://cloud.google.com/architecture/landing-zones/decide-network-design

https://cloud.google.com/architecture/best-practices-vpc-design#multi-nic

## Overview

## Onboarding

## Installation

## Updates

## Post Install Day 1 Operations


This is a work in progress from 20220731.


## Diagrams

### CI/CD Pipelines

### High Level Network Diagram

### Low Level Network Diagram 
20220802 - integrating Fortigate HA-active-passive https://github.com/fortinetsolutions/terraform-modules/tree/master/GCP/examples/ha-active-passive-lb-sandwich

<img width="1340" alt="Screen Shot 2022-08-16 at 7 38 54 AM" src="https://user-images.githubusercontent.com/94715080/184870971-f82ee191-2057-47e6-8fc9-72d3d3f9310f.png">


### GCP Services in use
https://cloud.google.com/products


 Category | Type | Tech | Description
--- | --- | --- | ---
App Modernization |	CI/CD |	SaaS |	Cloud Build |	Build, test, and deploy on Google Cloud serverless CI/CD platform	
App modernization |	Multi-cloud |	IaaS |	Container-Optimized OS |	Efficiently and securely run Docker containers on Compute Engine VMs.	
App modernization |	Multi-cloud |	IaaS |	Hybrid Connectivity |	Connect your infrastructure to Google Cloud on your terms, from anywhere.	
App modernization |	Service mesh |	IaaS |	Cloud Router |	Dynamically exchange routes between your Virtual Private Cloud (VPC) and on-premises networks by using Border Gateway Protocol (BGP).	
App modernization |	Service mesh |	PaaS |	Istio on Google Kubernetes Engine |	Quickly create GKE clusters with all the components you need to create and run an Istio service mesh in a single step.	
Compute	Core compute |	IaaS |	Compute Engine |	Accelerate your digital transformation with high-performance VMs.	
Compute	Core compute |	IaaS |	Compute Engine Autoscaler |	Automatically add or delete VM instances from a managed instance group (MIG) based on increases or decreases in load.	
Compute	Core compute |	SaaS |	OS Login |	Manage SSH access to your instances using IAM without having to create and manage individual SSH keys.	
Compute	Core compute |	IaaS |	Persistent Disk| 	Reliable, high-performance block storage for VM instances.	
Compute	Core compute |	IaaS |	SSH from the browser |	Connect to a Compute Engine virtual machine (VM) instance using SSH with the Google Cloud console in your web browser.	
Compute |	FaaS |	PaaS |	Cloud Functions |	Run your code with zero server management with this scalable, pay-as-you-go functions-as-a-service (FaaS) offering.	
Compute |	PaaS |	PaaS |	App Engine |	Build highly scalable applications on a fully managed serverless platform.	
Compute	VMware connectivity |	IaaS |	VMware Engine |	Migrate and run your VMware workloads on Google Cloud.	
Containers |	CaaS |	PaaS |	Google Kubernetes Engine |	Secured and managed Kubernetes service with four-way autoscaling and multi-cluster support.	
Containers |	Container registry |	SaaS |	Artifact Registry |	Store, manage, and secure your container images.	
Containers |	Container Security |	PaaS |	Binary Authorization |	Require images to be signed by trusted authorities during the development process and then enforce signature validation when deploying.	
Containers |	Containers without infrastructure |	PaaS |	Cloud Run |	Develop and deploy highly scalable containerized applications on a fully managed serverless platform.	
Data analytics |	Data warehouse |	PaaS |	BigQuery |	Serverless, highly scalable, and cost-effective multi-cloud data warehouse designed for business agility.	
Data analytics |	Messaging |	SaaS |	Pub/Sub |	Messaging and ingestion for event-driven systems and streaming analytics.	
Data analytics |	Messaging |	SaaS	Pub/Sub Lite |	Send and receive messages between independent applications using this zonal, real-time messaging service.	
Database |	RDBMS |	IaaS |	Cloud SQL |	Manage relational data for MySQL, PostgreSQL, and SQL Server for workloads under 64 TB.	
Developer tools |	Client libraries | 	SaaS |	Cloud SDK |	Tools and libraries for interacting with Google Cloud products and services.	
Developer tools |	Cloud-based IDE |	SaaS |	Cloud Shell |	Manage your infrastructure and develop your applications from any browser.	
Developer tools |	Command-line interface (CLI) |	SaaS |	Cloud SDK |	Tools and libraries for interacting with Google Cloud products and services.	
Developer tools| 	Error handling |	SaaS |	Error Reporting |	Real-time exception monitoring and alerting for your applications.	
Developer tools |	Job scheduling |	SaaS |	Cloud Scheduler |	Fully managed cron job service.	
Developer tools |	Git Repositories |	SaaS |	Cloud Source Repositories |	Access fully featured, private Git repositories hosted on Google Cloud.	
Enterprise |	Abuse prevention |	SaaS |	reCAPTCHA Enterprise |	Help protect your website from fraudulent activity, spam, and abuse without creating friction.	
Enterprise |	Marketplace	SaaS |	Marketplace |	Scale procurement for your enterprise via online discovery, purchasing, and fulfillment of enterprise-grade cloud solutions.	
Enterprise |	Solutions catalog |	SaaS |	Private Catalog	Control internal enterprise solutions and make them easily discoverable.	
Government services |	Regulated services |	SaaS |	Assured Workloads	Run more secure and compliant workloads on Google Cloud.	
Management tools |	API management |	SaaS |	API Gateway |	Develop, deploy, secure, and manage APIs with a fully managed gateway.	
Management tools |	Cost management |	SaaS |	Cost Management |	Tools for monitoring, controlling, and optimizing your Google Cloud costs.	
Migration |	SQL database migration |	SaaS |	Database Migration Service|	Migrate databases to Cloud SQL from on-premises, Compute Engine, and other clouds.	
Migration |	Storage migration |	SaaS |	Storage Transfer Service |	Complete large-scale online data transfers from online and on-premises sources to Cloud Storage.	
Migration |	Storage migration |	SaaS |	Transfer Appliance |	Securely migrate large volumes of data (from hundreds of terabytes up to one petabyte) to Google Cloud without disrupting business operations.	
Networking |	CDN |	SaaS |	Cloud CDN |	Serve web and video content globally, efficiently, and reliably.	
Networking |	Connectivity Management |	SaaS |	Network Connectivity Center |	Reimagine how you deploy, manage, and scale your networks on Google Cloud and beyond.	
Networking |	Domains and DNS |	IaaS |	Cloud DNS | 	Publish your zones and records in DNS without the burden of managing your own DNS servers and software.	
Networking |	Domains and DNS |	IaaS |	Cloud Domains |	Register and configure a domain in Google Cloud.	
Networking |	Load balancer |	IaaS |	Cloud Load Balancing |	Efficiently distribute network traffic across Compute Engine VMs.	
Networking |	Network monitoring |	SaaS |	Network Intelligence Center |	Centralize your network monitoring functions to verify network configurations, optimize network performance, increase network security, and reduce troubleshooting time.	
Networking |	Network security |	IaaS |	Cloud VPN |	Connect your peer network to your Virtual Private Cloud (VPC) network through an IPsec VPN connection.	
Networking |	Premium networking |	IaaS |	Network Service Tiers |	Optimize your network for performance or cost.	
Networking |	Services |	SaaS |	Service Directory |	Publish, discover, and connect services from a single directory.	
Networking |	Virtual networks |	IaaS |	Cloud NAT |	Send and receive packets using Google Cloud private GKE clusters or Compute Engine VM instances with no external IP address.	
Networking |	Virtual networks |	IaaS |	Virtual Private Cloud (VPC) |	Provide managed networking functionality for your cloud-based services running on Compute Engine VM instances, Google Kubernetes Engine, App Engine flexible environment instances, and other Google Cloud products built on Compute Engine VMs.	
Networking |	Web application firewall |	SaaS |	Google Cloud Armor |	Help protect your applications and websites against denial of service and web attacks.	
Operations |	Audit logging |	SaaS |	Cloud Audit Logs |	Log all user activity on Google Cloud.	
Operations |	Logging | 	SaaS |	Cloud Logging |	Manage logging and analysis in real time at scale.	
Operations |	Monitoring |	SaaS |	Cloud Monitoring |	Monitor the performance, availability, and health of your applications and infrastructure.	
Security & identity |	Certificate management | 	SaaS |	Certificate Authority Service |	Simplify the deployment and management of private certificate authorities without managing infrastructure.	
Security & identity |	Cloud provider access management |	SaaS |	Access Transparency and Access Approval| 	Help expand visibility and control over your cloud provider with admin access logs and approval controls.	
Security & identity |	Container security |	SaaS |	Artifact Registry |	Deploy only trusted containers on GKE.	
Security & identity |	Container security |	SaaS |	Container Analysis |	Perform vulnerability scans on container images in Artifact Registry and Container Registry, and monitor vulnerability information to keep it up to date.	
Security & identity |	Container security |	SaaS |	Container Security |	Secure your container environment on Google Cloud, GKE, or Anthos.	
Security & identity |	Data loss prevention (DLP) |	SaaS |	Cloud Data Loss Prevention |	Discover, classify, and help protect your most sensitive cloud data.	
Security & identity |	Encryption |	IaaS |	Confidential Computing |	Encrypt data in-use with Confidential Computing and Confidential GKE Nodes.	
Security & identity |	Exfiltration prevention | 	IaaS |	VPC Service Controls |	Isolate resources of multi-tenant Google Cloud services to help mitigate data exfiltration risks.	
Security & identity |	Hardware security module (HSM) |	SaaS | 	Cloud HSM |	Host encryption keys and perform cryptographic operations in a cluster of FIPS 140-2 Level 3 certified hardware security modules (HSMs).	
Security & identity |	IAM| 	SaaS |	Cloud Identity |	Centrally manage users and groups, federate identities between Google and other identity providers, such as Active Directory and Azure Active Directory.	
Security & identity |	IAM |	SaaS |	Identity and Access Management |	Provide fine-grained access control and visibility for centrally managing resources.	
Security & identity |	IAM |	SaaS |	Identity-Aware Proxy (IAP) |	Use identity and context to guard access to your applications and VMs.	
Security & identity |	IAM |	SaaS |	Managed Service for Microsoft Active Directory |	Use a highly available, hardened service running actual Microsoft Active Directory (AD).	
Security & identity |	Resource monitoring |	SaaS |	Cloud Asset Inventory |	View, monitor, and analyze all your Google Cloud and Anthos assets across projects and services using this metadata inventory service.	
Security & identity |	Resource monitoring |	SaaS |	Resource Manager |	Hierarchically manage resources by project, folder, and organization.	
Security & identity |	Secret management |	SaaS |	Secret Manager |	Store API keys, passwords, certificates, and other sensitive data.	
Security & identity |	Security administration |	SaaS |	Cloud Key Management Service |	Manage encryption keys on Google Cloud.	
Security & identity |	Security and risk management |	SaaS |	Security Command Center |	Security and risk management platform for Google Cloud.	
Security & identity |	Zero trust |	SaaS |	BeyondCorp Enterprise |	Enable secure access to critical applications and services, with integrated threat and data protection.	
Storage |	Block storage |	IaaS |	Persistent Disk	Store | data from VM instances running in Compute Engine or GKE, Google Cloud's state-of-the-art block storage offering.	
Storage |	File storage |	SaaS |	Filestore |	Provide fully managed NFS file servers on Google Cloud for applications running on Compute Engine VMs (VMs) instances or GKE clusters.	
Storage |	Infrequently accessed object storage |	SaaS |	Cloud Storage Archive |	Store infrequently accessed data using Google Cloud's ultra low-cost, highly durable, highly available archival storage.	
Storage |	Object storage |	SaaS |	Cloud Storage |	Store any amount of data and retrieve it as often as you'd like, using Google Cloud's object storage offering.	

### Landing Zone Dev Instances
The following environments are used for landing zone development. 
- A console/api sbx environment to work out the architecture and artifacts
- A dev environment to work out the deployment automation code
- A stg environment to dev-trigger deployments prior to PR merging
- a uat environment to keep a CI/CD repository triggered environment up that doubles for client demos 

```mermaid
graph LR;
    style Landing-Zones fill:#44f,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
    %% mapped and documented
    sbx-->obrienlabs.dev
    dev-->obrien.services
    stg-->cloudnuage.dev
    uat-->gcp.zone
    
```






