<div>

[]{.c19 .c3}

</div>

[Integrate FortiGate-VM NGFW HA solution with PBMM Secure Landing
Zone]{.c3 .c11}

[]{.c11 .c3}

[This guide shows you how to deploy a FortiGate NGFW YoppWorks default
reference architecture implementation to your landing zone to protect
your workload applications against cyberattacks.]{.c0 .c3}

[FortiGate is a next-generation firewall (NGFW) with software-defined
wide area network (SD-WAN) capabilities deployed as a network virtual
appliance in Compute Engine. When deployed, FortiGate can help secure
applications by inspecting all inbound traffic originating from the
internet and outbound to internet and internal traffic between
applications and application tiers. You can use the same FortiGate
cluster as a secure web gateway to protect outbound traffic originating
from your workloads.]{.c0 .c3}

[Architecture]{.c1} {#h.55w3og2kd214 .c8}
-------------------

[The following architectural diagram shows the FortiGate NGFW solution
architecture Yoppworks standard variation that consists of an HA cluster
of FortiGate NGFW VMs that uses external and internal load balancers as
next hop to direct traffic to the active FortiGate VM instance.]{.c0
.c3}

[]{.c0 .c3}

[![](images/image2.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 766.67px;"}

[From the above diagram, we can see the North-South traffic connections
from the internet to the workload applications pass through the active
FortiGate instance, as indicated by the blue path. We can also see the
FortiGate NGFWs also inspect internal East-West traffic connections from
client workload applications and other internal services, as indicated
by the pink path.]{.c0 .c3}

[The below is the variation of the above FortiGate architectural diagram
for initial networks of the PBMM landing zone for your reference.]{.c0
.c3}

[![](images/image16.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 589.33px;"}

[Similarly, the above reference architecture feature the following
building blocks:]{.c0 .c3}

-   [Active-Passive HA Cluster]{.c0 .c3}
-   [Peering-based hub and spokes]{.c0 .c3}
-   [Supported user-cases]{.c0 .c3}

```{=html}
<!-- -->
```
-   [Protecting public services - Ingress North-South Inspection]{.c0
    .c3}
-   [Secure NAT Gateway - Egress NorthSouth Inspection]{.c0 .c3}
-   [Multi-Tier Infrastructure Segregation - East-West Inspection]{.c0
    .c3}
-   [Secure Hybrid Cloud - IPS for InterConnect]{.c0 .c3}
-   [Private Service Connect]{.c0 .c3}
-   [SD-WAN and Remote Access]{.c0}

[Design Consideration]{.c22} {#h.lxgeynbvgx48 .c8}
----------------------------

[There are a few design limitations that led to the current design.]{.c0
.c3}

-   [GCP requires the use of instance groups to be able to use load
    balancers on]{.c0 .c3}

[interfaces other than nic0. Each virtual appliance has unique metadata
that is]{.c0 .c3}

[used for the startup configuration, so static instances were used to
accomplish this.]{.c0 .c3}

-   [The On-Demand image requires the appliance be able to access the
    internet on]{.c0 .c3}

[it\'s default port (nic0). In the example the appliances a GCP Cloud
NAT is]{.c0 .c3}

[created to provide internet access without giving the instance a public
IP]{.c0 .c3}

-   [Currently the \`nic3\` (connected to the mgmt vpc) is open to
    management because \`Identity Aware Proxy (IAP)\` requires
    connecting to \`nic0\` on the instance. This can and should be
    locked down in the appliance to only allow the IAP IP address range
    on this port.]{.c0 .c3}

[Cost]{.c1} {#h.zg6mbsedgmy1 .c8}
-----------

[FortiGate VM for Google Cloud supports both on-demand pay-as-you-go
(PAYG) licensing and bring-your-own-license (BYOL) models.]{.c0 .c3}

[PAYG is the most flexible type of licensing available for FortiGates in
the public cloud. PAYG licensing is linked to the machine type used to
run FortiGate VMs. License fee is calculated per hour of instance
running based on the below pricing sheet and added to the Google Cloud
invoice. To stop charges it is enough to stop the instances. ]{.c0 .c3}

[![](images/image8.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 446.50px; height: 340.60px;"}

[The above FortiGate PAYG license price may be changed. Please visit the
pricing tab of the GCP marketplace product ]{.c0}[[FortiGate
Next-Generation Firewall
(PAYG)](https://www.google.com/url?q=https://console.cloud.google.com/marketplace/product/fortigcp-project-001/fortigate-payg?organizationId%3D0%26supportedpurview%3Dproject&sa=D&source=editors&ust=1709660657494280&usg=AOvVaw32qikgu9lBfG0FgfefdJzJ){.c7}]{.c4}[ for
latest prices.]{.c0}

[As for BYOL license prices, you can obtain the information from any of
below ways:]{.c0 .c3}

-   [GCP marketplace product ]{.c0}[[FortiGate Next-Generation Firewall
    (BYOL)](https://www.google.com/url?q=https://console.cloud.google.com/marketplace/product/fortigcp-project-001/fortigate?organizationId%3D0%26supportedpurview%3Dproject&sa=D&source=editors&ust=1709660657494827&usg=AOvVaw0AU0tkXDdIe0O-PBCBbdoJ){.c7}]{.c4}
-   [[FortiGate-VM on GCP Order
    Type](https://www.google.com/url?q=https://docs.fortinet.com/document/fortigate-public-cloud/7.0.0/gcp-administration-guide/451056/order-types&sa=D&source=editors&ust=1709660657495126&usg=AOvVaw2sWhfprhwdBHMDTCc7SCyz){.c7}]{.c4}
-   [[FortiGate
    Support](https://www.google.com/url?q=https://www.fortinet.com/support/contact&sa=D&source=editors&ust=1709660657495381&usg=AOvVaw09FV3KqQmSWfF5Ey-JOnqF){.c7}]{.c4}

[Note that besides FortiGate license fees you will have to cover the
costs of the following GCP infrastructure:]{.c0 .c3}

-   [2 VM instances supporting 4 or more NICs]{.c0 .c3}
-   [Forwarding rules]{.c0 .c3}
-   [inter-zonal heartbeat traffic]{.c0 .c3}
-   [VM disk storage]{.c0 .c3}

[Use Google ]{.c0}[[Cloud Pricing
Calculator](https://www.google.com/url?q=https://cloud.google.com/products/calculator/%23id%3D41ff2e84-f518-4b22-a396-71effe7682db&sa=D&source=editors&ust=1709660657495988&usg=AOvVaw1PJKjNKwyEXU7XFkqUluWl){.c7}]{.c4}[ for
cost estimates.]{.c0}

[License]{.c1} {#h.kd0kqr1i7pdm .c8}
--------------

[For BYOL model, you need to obtain your license from FortiGate or its
local reseller first and then upload the license files to the below
terraform folder and these files are referenced when deploying instances
for license provisioning. ]{.c0 .c3}

[![](images/image10.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 277.01px; height: 354.50px;"}[\
\
To obtain your production-ready or evaluation licenses, contact your
local Fortinet reseller.]{.c0 .c3}

[For PAYG mode,  special PAYG boot images published by Fortinet are
required to be used. All images with names containing \"ondemand\" or
family name including \"payg\" published in
]{.c0}[fortigcp-project-001]{.c23}[ project are PAYG images. ]{.c0 .c3}

[![](images/image14.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 257.33px;"}

[To deploy a cluster with PAYG licensing, set a proper value for
image\_name or family\_name variables. By default the FortiGate module
deploys the newest firmware in PAYG licensing.]{.c0 .c3}

[(TODO: Figure out the image with the FortiGate cluster license)]{.c0}

[Terraform]{.c1} {#h.2hom8036b337 .c8}
----------------

[The FortiGate module is integrated with the Yoppworks PBMM secure
landing zone at the common root module. As shown from the above standard
architecture diagram,  four VPC networks will be required to build such
a landing zone with the FortiGate NGFW solution. To enable the FortiGate
solution, we need to follow the below steps.]{.c0 .c3}

[Step1: Plan networks and IP addresses.]{.c15 .c3} {#h.kgpuijbj0nio .c8 .c13}
--------------------------------------------------

[It is recommended by FortiGate to use the IP range 172.16.0.0/16 for
the FortiGate Firewall hub VPCs.]{.c0 .c3}

[It must be ensured that there is not any IP address overlapping between
Fortigate hub VPCs and workload VPCs.]{.c0 .c3}

[In the best practice, for enterprise clients, it is recommended to use
10.0.0.0/8 for your workload VPCs.]{.c0 .c3}

[Please refer to the above architecture diagram for networking
topology.]{.c0 .c3}

[The below IP tools can be used to plan your IP addresses for those
networks.]{.c0 .c3}

-   [[Visual Subnet
    Calculator](https://www.google.com/url?q=https://www.davidc.net/sites/default/subnets/subnets.html&sa=D&source=editors&ust=1709660657497451&usg=AOvVaw2ZiwTkzCF9r6sGL9bblhKS){.c7}]{.c16}
-   [[Advanced Subnet
    Calculator](https://www.google.com/url?q=https://www.solarwinds.com/free-tools/advanced-subnet-calculator&sa=D&source=editors&ust=1709660657497736&usg=AOvVaw18LI4U0ekKu-tbXPqg2XMB){.c7}]{.c16}

[Step2: Define network project]{.c15 .c3} {#h.n63ryv22ahrn .c8 .c13}
-----------------------------------------

[In the common module, you can define a GCP project for network hub VPCs
used for the Fortigate NGFW solution as shown in the below
screenshot.]{.c0 .c3}

[![](images/image17.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 292.00px;"}

[Step3: Define perimeter hub VPCs]{.c15 .c3} {#h.48lqqatehchl .c8 .c13}
--------------------------------------------

[In command module, the below four VPCs need to be defined for FortiGate
NGFW solution deployment:]{.c0 .c3}

-   [Public(External) perimeter VPC]{.c0 .c3}
-   [Private(Internal) perimeter VPC]{.c0 .c3}
-   [HA Sync perimeter VPC]{.c0 .c3}
-   [HA Management perimeter VPC]{.c0 .c3}

[In the main.tf,  the network module can be used to define the above
VPCs as shown below.]{.c0 .c3}

[![](images/image9.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 625.33px;"}

[And then, in the file perimeter-network.auto.tfvars,  provide variable
values for each of those VPCs like below.]{.c0 .c3}

[![](images/image13.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 553.33px;"}

[Step4: Define the Fortigate module instance]{.c15 .c3} {#h.tukkl9sylvko .c8 .c13}
-------------------------------------------------------

[To enable the FortiGate solution, we need to make sure the
fortigate-appliance module is used to define the given Fortigate
Active-Passive HA solution in the main.tf of the common root module.
]{.c0 .c3}

[The below shown module instance is commented out by default so you need
to uncomment it when you need such a FortiGate solution.]{.c0 .c3}

[![](images/image11.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 586.50px; height: 455.85px;"}

[![](images/image12.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 410.67px;"}

[Step5: Define variable for the Fortigate module instance]{.c3 .c15} {#h.af2ay5qfsl11 .c8 .c13}
--------------------------------------------------------------------

[We also need to add the variable parameter into the variable.tf under
the common root module as shown below first.]{.c0 .c3}

[![](images/image3.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 301.33px;"}

[]{.c0 .c3}

[]{.c0 .c3}

[Step6: Provide variable values for the Fortigate module instance]{.c15 .c3} {#h.os550ddmkids .c8 .c13}
----------------------------------------------------------------------------

[You need to provide variable values in a separated auto.tfvars file,
like "]{.c0}[fortigate-ngfw-firewall.auto.tfvars]{.c0 .c21}[".]{.c0 .c3}

[![](images/image18.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 305.33px;"}

[Please note that, in the practice, for devtest purpose, you may want to
deploy or only destroy this FortiGate solution instance. You can just
comment out selected firewall groups to destroy deployed resources of
the FortiGate solution. If you want to deploy it again, just uncomment
it and then apply changes.]{.c0 .c3}

[Deployment]{.c1} {#h.y0uts5vhpro4 .c8}
-----------------

[Please follow the standard terraform deployment procedure to deploy the
command.You just need to submit the code changes to the CSR repository
to trigger the cloud build jobs for root module deployments.]{.c0 .c3}

[You can validate your code change by the below commands before you
submit it to your CSR repository: ]{.c0}[terraform init; terraform
validate;]{.c9 .c21}

[Validation and ]{.c22}[Configuration]{.c1} {#h.2ug9m9c3zilq .c8}
-------------------------------------------

[Once the common root module is deployed successfully, you should be
able to see the FortiGate GCE VMs from the GCP console as shown below.
]{.c0 .c3}

[![](images/image15.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 210.67px;"}

[Then you can connect to each of the GCE VMs to obtain the FortiGate
product serial number like below. The product serial number will be used
to request a BYOL license from Fortigate company.]{.c0 .c3}

[![](images/image1.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 509.50px; height: 338.85px;"}

[![](images/image5.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 510.50px; height: 336.87px;"}

[Then you can open the custom metadata section and find the login
password from the instruction about set password as shown below. ]{.c0
.c3}

[![](images/image7.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 229.33px;"}

[You can also open the FortiGate web GUI at the public ip address of
each GCE VMs if your network firewall policy allows the incoming
internet traffic to those VMs. The login GUI will look like the screen
below. You can then login with admin as username and the above found
password as password.]{.c0 .c3}

[![](images/image6.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 438.50px; height: 328.27px;"}

[Then you will see the FortiGate web GUI homepage like below.]{.c0 .c3}

[![](images/image4.png)]{style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 458.49px; height: 270.50px;"}

[By the way, once we can manage and operate FortiGate VMs by FortiOS
provider from terraform solution, we may not need to login to the web
GUI to manage the firewall config and rules at most of the time.]{.c3
.c9}

[Known Issues]{.c1} {#h.7yt7lzxi7vhf .c8}
-------------------

[The current FortiGate NGFW module is originally from GCP PBMM landing
zone under the below path:]{.c0 .c3}

[[pbmm-on-gcp-onboarding/modules/fortigate-appliance at main ·
GoogleCloudPlatform/pbmm-on-gcp-onboarding
(github.com)](https://www.google.com/url?q=https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/tree/main/modules/fortigate-appliance&sa=D&source=editors&ust=1709660657501079&usg=AOvVaw0Eu_6lDfEkFUZcz2wWi37N){.c7}]{.c4}

[We are using the local copy of the above module at the Yoppworks repo
under below path:]{.c0 .c3}

[[pbmm-on-gcp-secure-onboarding/modules/fortigate-appliance at main ·
yw-liftandshift/pbmm-on-gcp-secure-onboarding
(github.com)](https://www.google.com/url?q=https://github.com/yw-liftandshift/pbmm-on-gcp-secure-onboarding/tree/main/modules/fortigate-appliance&sa=D&source=editors&ust=1709660657501428&usg=AOvVaw07R40jxQNIsUgDoeGZ9Uuc){.c7}]{.c4}[ ]{.c0
.c3}

[The below issues had been found from the the above modules:]{.c0 .c3}

-   [Random string does not include any numbers required by vm
    naming.]{.c0 .c3}
-   [Fortigate-appliance module validation error caused by virtual
    machine module error.]{.c0 .c3}
-   [Naming conflict issue of FortiGate VM osdisk and datadisk.]{.c0
    .c3}
-   [Path and Virtual-machine module used by fortigate-appliance
    module.]{.c0 .c3}
-   [Hardcoded port issue from fortigate-appliance module.]{.c0 .c3}
-   [FortiGate module virtual machine zone argument issue (not
    parameterized).]{.c0 .c3}
-   [FortiGate firewall image project and name variable issue from
    fortigate-appliance module.]{.c0 .c3}
-   [Network and subnet data are unavailable from outputs of network and
    subnet modules.]{.c0 .c3}
-   [Fortigate firewall configuration is not managed by terraform.]{.c0
    .c3}

[Completed Changes]{.c1} {#h.yv3c04apgksf .c8}
------------------------

[The below issues have been fixed for FortiGate solution modules at the
YoppWorks repo: ]{.c0 .c3}

-   [Fixed the issue that the random string does not include any numbers
    required by naming.]{.c0 .c3}
-   [Fixed the virtual machine module errors.]{.c0 .c3}
-   [Fixed name patterns for vm osdisk and datadisk.]{.c0 .c3}
-   [Fixed the virtual-machine module path issue in the
    fortigate-appliance module.]{.c0 .c3}
-   [Refactored the zone variable used by fortigate-appliance virtual
    machines.]{.c0 .c3}
-   [Refactored the port variable used by fortigate-appliance virtual
    machines.]{.c0 .c3}
-   [Refactored the image location and image variable used by
    fortigate-appliance virtual machines.]{.c0 .c3}
-   [Duplicated the FortiGate VM image to the restricted location.]{.c0
    .c3}
-   [Exported network and subnets values from outputs of module network
    and subnets.]{.c0 .c3}
-   [Completed FortiGate NGFW Firewall standard solution architecture
    for Yoppworks PBMM landing zone standard enterprise-level network
    topology]{.c0 .c3}
-   [Completed FortiGate NGFW Firewall solution architecture for GCP
    PBMM landing zone default networks.]{.c0 .c3}
-   [Integrated the fortigate-appliance module with the default networks
    from the GCP PBMM common root module.]{.c0 .c3}
-   [Whitelist organizational policies required by FortiGate NGFW at the
    network perimeter project level.]{.c0 .c3}
-   [Build next hop network balancers for Fortigate firewall vms
    backends.]{.c0 .c3}
-   [Document ]{.c0}[FortiGate]{.c0}[ solution user guide.]{.c0}

[Planned Changes]{.c1} {#h.a5jzqfmd4h9 .c8}
----------------------

[The below issues have been planned to be done for the FortiGate NGFW
solution at the YoppWorks repo: ]{.c0}

-   [Build Fortigate NGFW Firewall cluster with auto-scaling.]{.c0 .c3}
-   [Connect to FortiGate VMs by FortiOS provider.]{.c0 .c3}
-   [Automate the FortiGate Firewall password generation from GCP Secret
    Manager.(Optional)]{.c0 .c3}
-   [Externalize and load BYOL license from GCP Secret Manager.
    (Optional)]{.c0 .c3}
-   [Design and build use-case-based FortiGate firewall rule modules.
    ]{.c0 .c3}
-   [Build Fortigate module to support YoppWorks standard PBMM networks
    and workload.]{.c0 .c3}
-   [Build FortiGate rules for basic security
    ]{.c0}[scenarios]{.c0}[.]{.c0 .c3}
-   [Build FortiGate rules for standard security
    ]{.c0}[scenarios]{.c0}[.(Optional)]{.c0 .c3}
-   [Build FortiGate rules for enterprise-level security
    ]{.c0}[scenarios]{.c0}[. (Optional)]{.c0 .c3}
-   [Enhanced FortiGate NGFW solution to support 8 NICs.]{.c0}

[]{.c0 .c3}

[]{.c0 .c3}
