TOC

# PBMM Landing Zone - Architecture
This is a work in progress from 20220731.
## Purpose
Create a PBMM secure landing zone for the Google Cloud Environment. 
### Why Landing Zones
Expand on https://cloud.google.com/architecture/landing-zones/decide-network-design#option-2 in https://cloud.google.com/architecture/landing-zones#what-is-a-google-cloud-landing-zone

# Definitions
- Day 1 vs Day 2 - (Day 1 is setup of the LZ usually the IT/Ops personnel, Day 2 is application owners during normal operations)
- L1 vs L2 (in terms of GCP folders - L1 is the top level division)

## Requirements
### R1: L7 Packet Inspection required
### R2: Workload separation
### R3: Centralized IP space management
### R4: Security Command Center
Security Command Center (Standard and Premium) is what Google uses to secure Google.


## Overview

## Onboarding
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-onboarding.md

## Installation
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/README.md

### Installation - SOP - Standard Operating Procedure


### Upstream Repo Update - SOP

### Modification - SOP

### Deletion - SOP

## Updates

## Post Install Day 1 Operations





## Diagrams
### High Level Organizational Structure
<img width="1007" alt="pbmm_lz_organizational_structure" src="https://user-images.githubusercontent.com/94715080/186010982-c767581b-f347-4283-9de2-bf7c4bd78a10.png">


### CI/CD Pipelines

### High Level Network Diagram

<img width="2023" alt="pbmm-landingzone-sys-comms" src="https://user-images.githubusercontent.com/94715080/188962949-7ab8de5a-e325-452f-b881-d997b386123d.png">


### Low Level Network Diagram 
20220802 - integrating 2 sets if Fortigate HA-active-passive VMs (for GC-CAP and GC-TIP) https://github.com/fortinetsolutions/terraform-modules/tree/master/GCP/examples/ha-active-passive-lb-sandwich see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/146 and ITSG-22 ITSG-38 compliance https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/161


<img width="1343" alt="pbmm_sv-1-landingzone-sys-interface" src="https://user-images.githubusercontent.com/94715080/186494058-ff4f8169-682a-4c73-b05a-20f508045ea9.png">


## Design

### Naming Standard
- see https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/132
- Follow https://cloud.google.com/architecture/best-practices-vpc-design#naming

#### Discussion
The current naming standard in the PBMM LZ uses a slightly modified version of the original CDK at https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/tree/main/modules/naming-standard

As you can see in the LZ we have distributed the keys among the environment tfvars in common, bootstrap and prod/non-prod. In particular each of the VPC's, subnets, log sinks have customized local names - not every name is generated from a central API.

We will need to add 30 char validation - it would be ideal if this validation was part of name generation and not a hard stop warning during terraform plan/apply.

We have multiple optional dept/domain/org id;s throughout
(org)-(domain)-(env = prod/stg..)-vpc
using domain cloudnuage.dev
cpde-cnd-audit-cne
cnpe-cnd-prd-perim

Discuss required vs optional and additions such as region/dept
Discuss multi- organization option


### Backups
Trusted image policies can be setup using organization policies in IAM - see https://cloud.google.com/compute/docs/images/restricting-image-access
GCP services configurations and snapshots can be configured for scheduled automated snapshots to Google Cloud Storage using four tiers of short to long term storage.

Notes:
define a naming standard and schedule for automated snapshots 

### Configuration Management
All services, roles and artifacts inside the GCP organization are tracked in IAM Asset Inventory and Security Command Center - both change tracking.

### Logging
[Logging](https://console.cloud.google.com/logs) (part of the [Cloud Operations Suite](https://cloud.google.com/products/operations)) has its own dashboard.
The logging agent (ops - based on FluentD / OpenTelemetry) is on each VM - out of the box it captures OS logs (and optionally - application logs - which is configurable in the agent).  Log sources include service, vm, vpc flow and firewall logs.

#### Log Sinks
Google Cloud Logs can be routed using log sinks (with optional aggregation) to destinations like Cloud Storage (object storage), PubSub (message queue) or BigQuery (serverless data warehouse) with 4 levels of tiering for long term storage or auditing.

#### Audit Logging Policy
GCP provides for audit logging of admin, data access, system event and policy denied logs for the following [services](https://cloud.google.com/logging/docs/audit/services) - in addition to [access transparency logs](https://cloud.google.com/logging/docs/view/available-logs). Redacted user info is included in the audit log entries.  

### Network Zoning
Ref: ITSG-22: https://cyber.gc.ca/sites/default/files/cyber/publications/itsp80022-e.pdf - see ZIP (Zone Interface Points)
Ref: https://cloud.google.com/architecture/landing-zones

  The GCP PBMM Landing Zone architecture provides an automated and pluggable framework to help secure enterprise workloads using a governance model for services and cost distribution.

  The network zoning architecture is implemented via virtual SDN (software defined networking) in GCP via the [Andromeda framework](https://cloud.google.com/blog/products/networking/google-cloud-networking-in-depth-how-andromeda-2-2-enables-high-throughput-vms).  Physical and virtual zoning between the different network zones is the responsibility of GCP.  The physical networking and hosting infrastructure within and between the two canadian regions is the responsibility of GCP as per [PE-3](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-security-controls.md#3830pe-3physical-access-control)

  This PBMM architecture supports all the common network level security controls that would be expected within a zoned network around routing, firewall rules and access control.  The GCP PBMM Landing Zone will support the ITSG-22 Baseline Security Requirements for Network Security Controls.  Information flow is controlled between each network segment/zone via VPC networks, VPC Service Controls, Shared VPCs or VPC Peering for network connections.  The network design currently includes a PAZ/Perimeter public access zone/VPC, a management zone on the perimeter, an internal production zone in either shared VPC for PaaS workloads or Peered VPC for IaaS workloads.  As part of the PAZ/Perimeter zone we deploy a Fortigate cluster between a front facing L7 public load balancer and an internal L7 private load balancer.  All messaging traverses the PAZ where the Fortigate cluster packet inspects ingress and egress traffic.  GCP deploys Cloud Armor in front of the PAZ zone for additional default protection in the form of ML based L7 DDoS attack mitigation, OWASP top 10, LB attacks and Bot management via reCAPTCHA  
  
  All ingress traffic traverses the perimeter public facing Layer 7 Load Balancer and firewall configured in the Perimeter project/VPC.  All egress internet traffic is packet inspected as it traverses the Firewall Appliance cluster in the perimeter VPC. All internal traffic inside the GCP network is default encrypted at the L3/L4 level. Public IP’s cannot be deployed in the client/workload VPC’s due to deny setting in the “Define allowed external IPs for VM instances” IAM Organization Policy.  Public IP's are only permitted specifically in the public perimeter VPC hosting the public facing L7 Load Balancer in front of the Firewall Appliance cluster. 
  All network operations are centrally managed by the customer operations team on a least privilege model - using the GCP Cloud Operations Suite in concert with IAM accounts and roles.
  Logging and network event monitoring are provided by the centralized GCP Logging Service and associated Log Agents.


### Vulnerability Management
#### Container Analysis

Static analysis of container images is provided by [Artifact Registry](https://cloud.google.com/artifact-registry/docs/analysis) | Container Analysis and Vulnerability Scanning - including automatic [Vulnerability Scanning](https://cloud.google.com/container-analysis/docs/os-overview) (per container image build)  

#### Cloud Armor
Proactive threat detection also occurs at the perimeter of customer networks via Cloud Armor https://cloud.google.com/armor.  Google Cloud Armor provides DDoS (Distributed Denial of Service) and WAF (Web Application Firewall) protection in addition to Bot, OWASP and adaptive ML based layer 7 DDoS capabilities.   Cloud Armor integrates with our Cloud CDN and Apigee API Management front end services.  Detection can be customized by adding rules - the following is in place by default
- ML based layer 7 DDoS attacks
- OWASP top 10 for hybrid
- Load Balancer attacks
- Bot management via reCAPTCHA 

GCP Compute and GKE (Google Kubernetes Engine) benefit from secure [Shielded VMs](https://cloud.google.com/shielded-vm)

#### Intrusion Detection System
GCP IDS (Intrusion Detection System Service) (based on the Palo Alto security appliance) - https://cloud.google.com/intrusion-detection-system handles Malware, Spyware and Command-and-Control attacks. Intra- and inter-VPC communication is monitored. Network-based threat data for threat investigation and correlation can be generated including intrusion tracking and response.

In addition for Chrome based clients we have BeyondCorp zero trust capabilities.

#### Security Command Center
Security Command Center Premium includes Vulnerability scanning, Findings, Container Threat Detection, Event Threat Detection, Virtual Machine Threat Detection, Web Security Scanner - application discovery/scanning
Security Command Center Premium - Threat Detection - https://cloud.google.com/security-command-center/docs/concepts-event-threat-detection-overview detects threats using logs running in Google Cloud at scale including container attacks involving suspicious binary, suspicious library, and reverse shell vectors.

GCP provides trusted image scanning to reject unsanctioned public image downloads through a organizational policy called trusted image policy https://cloud.google.com/compute/docs/images/restricting-image-access 



## Design Issues
The design of the landing zone follows GCP best practices and architecture principles detailed in the following references.

- https://cloud.google.com/architecture/landing-zones
- https://cloud.google.com/architecture/framework
- 
### DI 0: GCP Secure Landing Zones - Best Practices

### DI 1: Decide on Shared VPC or Hub-and-spoke Network Topologies
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/146

The requirements of the landing zone involve a managed IP space and use of L7 packet inspection - which leans more towards use of Shared VPC's for each dev/stg/uat/prod environment.   See decision references in https://cloud.google.com/architecture/landing-zones/decide-network-design

https://cloud.google.com/architecture/best-practices-vpc-design#multi-nic

### DI 2: Multi Organization and/or Folder Resource separation for dev/prod Multitenant Environments

Add isssue on shared/peered VPCs
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/164 
Requirements

- 1: Shared VPC (with service projects) - PaaS + shared FaaS
- all tenants share a shared VPC host subnet
- some tenants share a particular shared VPC host subnet
- single tenants get their own 1:1 shared VPC host subnet
- 2: Mix Shared VPC + Peered VPCs
- some tenants have a mix of shared
- 3: Peered VPCs (single tenant PaaS, IaaS, FaaS)
- some tenants want their own distinct VPC with their own servless VPC endpoints

### DI 3: Network Traffic Flows
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/149

Table with details on all possible flows in and out of the GCP Landing Zone.
Flow ID | Direction | Source | Location | Target | Protocols | Notes | Code/Evidence
---|---|---|---|---|---|---|---
 1 | in | public | CA | public LB | https | with/without IP inspection appliance | 
 
### DI 4: Cloud Identity Federation
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/99

See Identity Onboarding and Federation options at https://cloud.google.com/architecture/landing-zones/decide-how-to-onboard-identities
- using Option 2  
- using https://cloud.google.com/architecture/identity/federating-gcp-with-azure-active-directory
- https://cloud.google.com/architecture/identity/reference-architectures#using_an_external_idp

### DI 5: IaaS/PaaS/SaaS Application Security
Determine list of services to help enable applicaton security firewalls, vulnerability, OS protections.  SCC Threat detection handles what is going on inside the IaaS/PaaS systems where Armor/IDS handle ingress/egress traffic and Shielded VMs handle IaaS.

https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/158

### DI 6: Landing Zone Network Topology Design
- Reference: https://cloud.google.com/architecture/landing-zones/decide-network-design#option-2
- We will be focusing on option 2 - a network topology with a mix of shared VPCs and Hub-and-scope network peering that involve Firewall Appliances
- see Fortigate design in https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/45

Going through GC-CAP, GC-TIP architecture as part of SCED/SC2G https://gc-cloud-services.canada.ca/s/article/What-is-Secure-Cloud-Enablement-and-Defense-SCED-EN?language=en_US

I recommend we deploy 2 sets of 2-VM fortigate clusters - for pbmm GoC/DC C2G GC-TIP and public GC-CAP

## Work Items
Scrum Work Items and Priority in https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/124

### Review ITSG-22 and ITSG-38 Network Zoning Compliance
https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/issues/78 and https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/161 

We have been focused on ITSG-33 security controls until 202208 - we need to verify our compliance with Network Zoning.

ITSG-22 https://cyber.gc.ca/en/guidance/baseline-security-requirements-network-security-zones-version-20-itsp80022

ITSG-38 Placement of Services with Zones - https://open.canada.ca/data/en/dataset/7ef76a62-bb53-4e9c-b2a4-03e5c53570a1 and
https://cyber.gc.ca/en/guidance/network-security-zoning-design-considerations-placement-services-within-zones-itsg-38
SSC 2020 https://wiki.gccollab.ca/images/9/9d/Network_Security_Zoning_Reference_Architecture.pdf

Notes:
  Google Front End Service (reverse proxy) - https://cloud.google.com/docs/security/infrastructure/design#google_front_end_service

## GCP PBMM Landing Zone - Deployments
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/architecture.md#landing-zone-dev-instances
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/deployments.md

## GCP Secure Landing Zone - Alternatives
### GCP Landing Zone Design in GCP
https://cloud.google.com/architecture/landing-zones

### GCP Anthos Config Management
The Anthos Config Management Landing zone using KPT to transform blueprints and deploy using Config Connector

https://cloud.google.com/anthos-config-management/docs/tutorials/landing-zone

### GCP Blueprints - Google Cloud Architecture Framework
- https://cloud.google.com/architecture/security-foundations
- https://github.com/GoogleCloudPlatform/blueprints/blob/main/catalog/landing-zone/policies/folder-naming-constraint-template.yaml#L22

### PubSec Declarative Toolkit
https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit

The PubSec Declarative Toolkit contains a PBMM compliant Landing Zone solution based on KPT transformations deployed using Config Controller at https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/tree/main/solutions/landing-zone




## Landing Zone Dev Instances
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/deployments.md

The following environments are used for landing zone development -  10 environments
- (3)  A console/api sbx environment to work out architecture components and artifacts manually first (2 organizations with a peered VPC) (wip)
- (3) A console/api dev environment to work out the full architecture (2 organizations with a peered VPC) (stable)
- (1) A dev environment to work out the deployment automation code (terraform) (wip)
- (1) A dev environment to work out the deployment automation code (kcc/k8s) (wip)
- (1) A stg environment to dev-trigger deployments prior to PR merging (stable)
- (1) a uat environment to keep an automated CI/CD repository triggered environment up that doubles for client demos 



#### Deployments
[deployments.md](deployments.md)

## GCP Services in use
- https://cloud.google.com/products
- The landing zone is currently running in the Montreal NA1 region - we can use the NA2 region as well with caveats https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/156

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
Containers |	Container Security |	PaaS |	[Binary Authorization](https://cloud.google.com/binary-authorization) |	Require images to be signed by trusted authorities during the development process and then enforce signature validation when deploying.	
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
Enterprise |	_Marketplace_ |	SaaS |	_Marketplace_ |	Scale procurement for your enterprise via online discovery, purchasing, and fulfillment of enterprise-grade cloud solutions - use Private Catalog instead.	
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

# Architecture/Design Pending
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/124
- add billing heatmap overlay on architecture diagram

# References
- [Google Cloud ITSG-33 Security Controls Coverage](docs/google-cloud-security-controls.md)
- Google Public Sector - https://cloud.google.com/blog/topics/public-sector/announcing-google-public-sector
- Google Cybersecurity Action Team - https://cloud.google.com/security/gcat
- GoC Guideline on Service and Digital - https://www.canada.ca/en/government/system/digital-government/guideline-service-digital.html
- CVE DB - https://nvd.nist.gov/general/nvd-dashboard





