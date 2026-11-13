# Next Gen Firewall

This repo is part of a multi-part guide that shows how to configure and deploy
the example.com reference architecture described in
[Google Cloud security foundations guide](https://cloud.google.com/architecture/security-foundations). The following table lists the parts of the guide.

This repo is used to create a Protected B Medium-Medium (PBMM) compliant Landing Zone on Google Cloud. 

This module deploys a Google Cloud Next Generation Firewall (NGFW) Enterprise configuration within the centralized Hub VPC. This setup ensures that all east-west traffic (between spokes) and north-south traffic (internet/on-prem egress) is subjected to deep packet inspection and advanced threat protection.

## About NGFW 

This solution deploys **Google Cloud Next Generation Firewall (NGFW)**. Unlike traditional firewall appliances that require managing individual VMs or scaling groups, Cloud NGFW is a fully distributed, cloud-native service deeply integrated into the Google Cloud networking fabric.


### Role in Hub & Spoke Architecture
In this architecture, the NGFW acts as the central security enforcer located in the **Hub VPC**.
1.  **Centralized Inspection:** The Firewall Endpoint is associated with the Hub VPC.
2.  **Traffic Flow:** Spoke VPCs peer with the Hub. Traffic moving between Spokes (East-West) or from Spokes to the Internet (North-South) is routed through the Hub.
3.  **Transparent Enforcement:** The NGFW inspects this traffic transparently—no changes to workload IP addresses or complex NAT configurations are required at the Spoke level.

### Key Capabilities
* **Deep Packet Inspection (DPI):** Goes beyond standard Layer 3/4 (IP/Port) filtering to inspect Layer 7 (Application) payloads.
* **Intrusion Prevention System (IPS):** Detects and automatically blocks malware, spyware, and command-and-control attacks using Google-curated threat intelligence.
* **TLS Inspection:** (If configured) Decrypts SSL/TLS traffic to inspect encrypted flows for hidden threats before re-encrypting.
* **Hierarchical Policies:** Utilizes Global Network Firewall Policies to enforce consistent security rules across the entire organization hierarchy.


## Architecture

This solution implements a centralized **Cloud NGFW Enterprise** architecture. It separates the infrastructure definition (Endpoints) from the security logic (Policies), utilizing Terraform remote state from previous stages to bind shared security resources to the specific **Hub VPC**.

See [3-networks-hub-and-spoke](../3-networks-hub-and-spoke/) for more information and reference on hub and spoke architecture. Also see 

### 1. Integration with Shared Services
The architecture relies on a "Shared Services" model. Rather than provisioning new firewall infrastructure from scratch, this module consumes pre-existing resources via `remote.tf`:
* **Firewall Endpoints:** The zonal firewall engines (`firewall_endpoint_1`, `firewall_endpoint_2`) are retrieved from the `cloud_firewall_shared` remote state.
* **Security Profiles:** The Intrusion Prevention System (IPS) logic is defined centrally in a `security_profile_group`, ensuring consistent threat signatures across environments.

### 2. Network Attachment (The "Gluer")
The core function of this module is to "plug" the shared firewall engine into the local Hub network using `main.tf`:
* **Association:** The resource `google_network_security_firewall_endpoint_association` is used to attach the imported Firewall Endpoint IDs to the Base (Hub) VPC (`data.google_compute_network.base_network`).
* **Scope:** This association is zonal, matching the location of the endpoint (e.g., `us-central1-a`) to the subnet topology.

### 3. Hierarchical Security Policy
Security rules are defined in `policy.tf` using a **Hierarchical Firewall Policy** applied at the Folder level:
* **Resource:** `google_compute_firewall_policy` is created and attached to the environment folder (`local.parent_folder`) rather than a specific project. This allows the policy to cascade down to all projects within that folder.
* **Inspection Logic:** The policy includes specific rules (e.g., `primary`) that target Ingress traffic on TCP ports 80 and 443.
* **Action:** Instead of a simple "Allow/Deny," the action `apply_security_profile_group` routes matching traffic (specifically from NAT IP ranges) to the IPS engine for Deep Packet Inspection.

### 4. Traffic Flow Summary
1.  **Ingress:** Traffic enters the network (scoped to NAT IP ranges in the provided configuration).
2.  **Intercept:** The `firewall_endpoint_association` ensures the Cloud NGFW intercepts the flow before it reaches the workload.
3.  **Process:** The `google_compute_firewall_policy_rule` matches the traffic (L3/L4 headers).
4.  **Inspect:** If matched, the traffic is deep-scanned against the `security_profile_group` (L7 payloads) for threats.

## Deployment

### Prerequisites

This step requires successful deployment for [0-bootstrap](../0-bootstrap/README.md), [1-org](../1-org/README.md), and [2-environments](../2-environments/README.md).

This requires to deploy `3-networks-hub-and-spoke` with `enable_hub_and_spoke_transitivity = true` and setting `restricted_enabled = true` in `0-bootstrap`.  This also assumes a restricted networks exists with at least one subnet. 

### Deployment

This deployment uses the networks service account.

```bash
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw networks_step_terraform_service_account_email)
```

1. Copy the Terraform wrapper script and ensure it can be executed.

    ```bash
    cp ../build/tf-wrapper.sh .
    chmod 755 ./tf-wrapper.sh
    ```

1. Rename `common.auto.tfvars.example` to `common.auto.tfvars`.

    ```bash
    mv common.auto.tfvars.example common.auto.tfvars
    ```

1. Update `common.auto.tfvars` file with values from your environment and bootstrap.


1. Run `init` and `plan` and review output for environment shared.

    ```bash
    ./tf-wrapper.sh init shared
    ./tf-wrapper.sh plan shared
    ```

1. Run `apply` shared.

   ```bash
   ./tf-wrapper.sh apply shared
   ```

1. Run `init` and `plan` and review output for environment shared.

    ```bash
    ./tf-wrapper.sh init development
    ./tf-wrapper.sh plan development
    ```

1. Run `apply` shared.

   ```bash
   ./tf-wrapper.sh apply development
   ```

1. Repeat for `nonproduction` and `production`.


## Related Resources

* [Cloud NGFW Enterprise Overview](https://docs.cloud.google.com/firewall/docs/about-firewalls) - High-level details on capabilities (IPS, TLS inspection) and architecture.
* [Hub-and-Spoke Network Architecture](https://docs.cloud.google.com/architecture/deploy-hub-spoke-vpc-network-topology) - Google's reference guide for the network topology used in this deployment.
* [Intrusion Prevention Service (IPS) Overview](https://docs.cloud.google.com/firewall/docs/about-intrusion-prevention) - Details on threat signatures, severity levels, and override logic.
* [Firewall Rules Logging](https://docs.cloud.google.com/firewall/docs/using-firewall-rules-logging) - Guide on interpreting the flow logs and threat logs generated by the firewall.
* [Cloud NGFW Enterprise - Intrusion Prevention Service (without TLS Inspection) Codelab](https://codelabs.developers.google.com/cloud-firewall-plus)

