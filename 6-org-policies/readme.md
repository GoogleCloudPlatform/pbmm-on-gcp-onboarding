1.Org policies are implemented in 1-Org Folder at path - /../TEF-GCP-LZ-HS/1-org/envs/shared/org_policy.tf

2.In total 26 Org Policies have been implemented and details of the same can be found out in the shared TDD under Org Policies section with granular details in the "Security Controls" sheet.

3.Once the policies are implemented at 1-Org level, developer can use the "6-org-policies" package to customize policies whether they are needed or are to be overriden at environment specific level.

4.The sub folder in the directory and their details are as follows-
 -> common:- This is where env agnostic policies can be placed or overriden. In a simple way if there is a requirement to implement or over ride a policy for all env together then that can be done in "common" folder
 
-> development: If there is a requirement to implement a new or over ride an org policy for "development" environment then that can be done in this folder

-> identity: If there is a requirement to implement a new or over ride an org policy for "identity" environment then that can be done in this folder

-> management: If there is a requirement to implement a new or over ride an org policy for "management" environment then that can be done in this folder

-> nonproduction: If there is a requirement to implement a new or over ride an org policy for "nonproduction" environment then that can be done in this folder

-> production: If there is a requirement to implement a new or over ride an org policy for "production" environment then that can be done in this folder

4.1 How to Override a new Organization Policy/constraint which is not available in the main file? a. In the environment specific folder open file org_policy_env.tf and add+update the following template-

     module "org_policies_*relevant_name*_override" {
       source  = "terraform-google-modules/org-policy/google"
       version = "~> 5.1"

       constraint  = "constrain name" #example "constraints/compute.restrictProtocolForwardingCreationForTypes"
       policy_for  = "folder" / "project" #select if you want to override for a completd folder or a particular project
       folder_id   = local.fldr_development
       policy_type = "list" / "boolean" #select whether it is list or boolean policy
       enforce     = false
     }

4.2 How to add new projects/ folders in the override list where the org policy/constraint is already present? a. In the environment specific folder open file org_policy_env.tf look out for the module block which has the constraint that has to be overriden for a new project or folder. b. In the same block look out for local.variable which has the list of folders/project, in the same local variable, add the new project or folder that has to be added or removed.

Example- To add a new network related project in override list of development environment for constraints/compute.disableVpcExternalIpv6

Code snippet-
     module "org_policy_disableVpcExternalIpv6_prj_override" {
         source  = "terraform-google-modules/org-policy/google"
         version = "~> 5.1"

         for_each    = toset(local.list_prj_dev_shared_network_exclude)
         constraint  = "constraints/compute.disableVpcExternalIpv6"
         policy_for  = "project"
         policy_type = "boolean"
         project_id  = each.value
         enforce     = false
     }

In the above code block, local.list_prj_dev_shared_network_exclude contians the list of projects that are to be excluded/overriden for a policy. User needs to add the name of the project in this list(list_prj_dev_shared_network_exclude) and apply terraform 

5.All the environment specific terraform deployment have separate state files to shield them from each other and reduce blast radius in case of human mistake. They are stored in GCP bucket as backend for Terraform

6.remote.tf file is used to recall values of previously deployed resources which were deployed in the preceeding modules

7.The existing setup of Org Policies are done to be in compliance with expected security standards of PBRR, any changes in the production code may result in noncompliance of some controls. It is recommended that you make changes to this codeonly after aligning with a security expert

8.As requested by MCN we have overriden most of the policies at DEV level folder so that it becomes easy for the users to experiment.



| Constraint Name | Constraint Description | Control References |
|-----------------|------------------------|--------------------|
| essentialcontacts.allowedContactDomains                 | This policy limits Essential Contacts to only allow managed user identities in selected domains to receive platform notifications. | AC-2(4) |
| compute.disableNestedVirtualization | This policy disables nested virtualization to decrease security risk due to unmonitored nested instances. | AC-3, AC-6(9), AC-6(10) |
| compute.disableSerialPortAccess | This policy prevents users from accessing the VM serial port which can be used for backdoor access from the Compute Engine API control plane. | AC-3, AC-6(9), AC-6(10) |
| compute.requireOsLogin | This policy requires OS Login on newly created VMs to more easily manage SSH keys, provide resource-level permission with IAM policies, and log user access. | AC-3, AU-12 |
| compute.restrictVpcPeering | Enables you to implement network segmentation and control the flow of information within your GCP environment. | SC-7, SC-7(5), SC-7 (7), SC-7(8), SC-7(18) |
| compute.vmCanIpForward | This permission controls whether a VM instance can act as a network router, forwarding IP packets between different network interfaces. Enabling IP forwarding on a VM essentially turns it into a router, which can have significant security implications. | SC-7, SC-7(5), SC-7 (7), SC-7(8), SC-7(18), SC-8, SC-8(1) |
| compute.restrictLoadBalancerCreationForTypes | This permission allows you to restrict the types of load balancers that can be created in your project. This helps prevent unauthorized or accidental creation of load balancers that could expose your services to unnecessary risks or attacks. | SC-8, SC-8(1) |
| compute.requireTlsForLoadBalancers | This constraint enforces the use of Transport Layer Security (TLS) for communication with load balancers in GCP. It aligns with several key principles and controls outlined in NIST. | SC-8, SC-8(1) |
| compute.skipDefaultNetworkCreation | This policy disables the automatic creation of a default VPC network and default firewall rules in each new project, ensuring that network and firewall rules are intentionally created. | AC-3, AC-6(9), AC-6(10) |
| compute.restrictXpnProjectLienRemoval | This policy prevents the accidental deletion of Shared VPC host projects by restricting the removal of project liens. | AC-3, AC-6(9), AC-6(10) |
| compute.disableVpcExternalIpv6 | This policy prevents the creation of external IPv6 subnets, which can be exposed to incoming and outgoing internet traffic. | AC-3, AC-6(9), AC-6(10) |
| compute.setNewProjectDefaultToZonalDNSOnly | This policy restricts application developers from choosing legacy DNS settings for Compute Engine instances that have lower service reliability than modern DNS settings. | AC-3, AC-6(9), AC-6(10) |
| compute.vmExternalIpAccess | This policy prevents the creation of Compute Engine instances with a public IP address, which can expose them to incoming internet traffic and outgoing internet traffic. | AC-3, AC-6(9), AC-6(10) |
| sql.restrictPublicIp | This policy prevents the creation of Cloud SQL instances with public IP addresses, which can expose them to incoming internet traffic and outgoing internet traffic. | AC-3, AC-6(9), AC-6(10) |
| sql.restrictAuthorizedNetworks | This policy prevents public or non-RFC 1918 network ranges from accessing Cloud SQL databases. | AC-3, AC-6(9), AC-6(10) |
| storage.uniformBucketLevelAccess | This policy prevents Cloud Storage buckets from using per-object ACL (a separate system from IAM policies) to provide access, enforcing consistency for access management and auditing. | AC-3, AC-6(9), AC-6(10) |
| storage.publicAccessPrevention | This policy prevents Cloud Storage buckets from being open to unauthenticated public access. | AC-3, AC-6(9), AC-6(10) |
| iam.disableServiceAccountKeyCreation | This constraint prevents users from creating persistent keys for service accounts to decrease the risk of exposed service account credentials. | AC-2(4) |
| iam.disableServiceAccountKeyUpload | This constraint avoids the risk of leaked and reused custom key material in service account keys. | AC-6(9), AC-6(10) |
| iam.allowedPolicyMemberDomains | This policy limits IAM policies to only allow managed user identities in selected domains to access resources inside this organization. | AC-2(4) |
| compute.disableGuestAttributesAccess | This permission controls whether a user or service account can modify guest attributes on a virtual machine (VM) instance. Guest attributes can contain metadata or configuration data that could potentially impact the security or operation of the VM. | AC-2(4) |
| iam.automaticIamGrantsForDefaultServiceAccounts | This constraint prevents default service accounts from receiving the overly-permissive Identity and Access Management (IAM) role Editor at creation. | AC-3 |
| compute.trustedImageProjects | This constraint helps enforce software and firmware integrity and configuration management. This permission controls which projects can be used as trusted sources for VM images. By limiting this to a select set of projects, you reduce the risk of deploying VMs from untrusted or potentially compromised sources.  | SI-3 (2), SI-3 (7)  |
