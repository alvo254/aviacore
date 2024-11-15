# Docs

This Terraform configuration creates an AWS Virtual Private Cloud (VPC) with public and private subnets and deploys a sample SAP workload. It includes frontend-facing applications in the public subnets and backend services in the private subnets, along with appropriate routing and security configurations.

## Overview

This setup aims to simulate a basic SAP workload, with:

- **Frontend applications** in public subnets for user-facing access.
- **Backend services** in private subnets, securely connected to the frontend applications.
- **Aviatrix Spoke Gateways** to enable communication between the private subnets and external networks.

## Why Use Aviatrix Spoke Gateways?

Aviatrix Spoke Gateways provide a secure, scalable, and high-performance solution for private connections in hybrid and multi-cloud environments. Key benefits include:

1. **Enhanced Security**:  
    Spoke Gateways enforce security policies at the subnet level, ensuring that private workloads cannot directly access the internet while maintaining controlled outbound connectivity. Can also be use as insertion point for NGFWs.
    
2. **Optimized Performance**:  
    The gateways optimize traffic flow between private subnets, on-premises data centers, and other VPCs or cloud regions, leveraging Aviatrix’s intelligent routing capabilities.
    
3. **Centralized Management**:  
    Through the Aviatrix Controller, you gain a unified view and centralized control over network policies, eliminating the complexity of managing separate configurations across environments.
    
4. **Simplified Hybrid Connectivity**:  
    Aviatrix Spoke Gateways seamlessly connect private subnets to on-premises networks or external services via VPN or Direct Connect, reducing the need for additional network appliances.
    
5. **Scalability and High Availability**:  
    The spoke gateway architecture supports elastic scaling to handle increasing workloads and ensures redundancy through active-active configurations.
    
6. **Visibility and Troubleshooting**:  
    Aviatrix’s topology visualization and traffic monitoring tools provide deep insights into network traffic, making it easier to diagnose and resolve connectivity issues.
    

In this configuration, Aviatrix Spoke Gateways are used to:

- Securely route traffic between private subnets and external resources.
- Provide an abstraction layer that simplifies hybrid and multi-cloud connectivity.
- Enforce granular security policies at the network edge.

## Resources Created

### VPC and Subnets

- **VPC**: Custom VPC with DNS hostname enabled.
- **Subnets**:
    - **Public Subnets**:
        - `aviacore-pub-sub1`: Primary subnet for frontend applications (e.g., SAP Fiori, web portal).
        - `aviacore-pub-sub2`: Secondary subnet for frontend application redundancy.
    - **Private Subnets**:
        - `aviacore-priv-sub1`: Primary subnet for backend services (e.g., SAP HANA, SAP S/4HANA).
        - `aviacore-priv-sub2`: Secondary subnet for backend service redundancy.

### Aviatrix Spoke Gateways

- **Spoke Gateways**: Provide secure and scalable routing between VPCs and on-premises networks or other cloud environments.
    - **Public Subnet Gateways**: Facilitate the communication between the public subnets and external networks.
    - **Private Subnet Gateways**: Handle secure outbound communication from private subnets to external networks or the internet via Aviatrix controllers.

### Route Tables

- **Public Route Table**: Routes all public subnet traffic to the Aviatrix Spoke Gateways for external communication.
- **Private Route Table**: Routes traffic from private subnets to the Aviatrix Spoke Gateways, ensuring secure connectivity while preventing direct internet access.

### Security Groups

- **Public Security Group (`public_sg`)**:
    - **Inbound**:
        - HTTP (port 80): Public access.
        - HTTPS (port 443): Public access.
        - Custom port (50000): Used for SAP frontend applications.
    - **Outbound**:
        - All traffic allowed (0.0.0.0/0).
- **Private Security Group (`private_sg`)**:
    - **Inbound**:
        - Custom port (30015): SAP HANA access, restricted to internal VPC traffic.
        - Custom port (3306): Database connections for SAP applications, restricted to frontend instances.
    - **Outbound**:
        - All traffic allowed (0.0.0.0/0).

## EC2 Instances (Simulated Workloads)

- **Frontend Instances** (in Public Subnet):
    - **Frontend 1**: Simulates SAP Fiori or web portal services accessible over HTTP/HTTPS.
    - **Frontend 2**: Provides redundancy for frontend services.
- **Backend Instances** (in Private Subnet):
    - **SAP HANA Instance**: Simulates a database backend for SAP applications.
    - **Application Server**: Simulates an SAP S/4HANA application backend.
- **ETL Worker** (in Private Subnet):
    - Simulates an ETL process for data extraction, transformation, and loading.

## Key Configuration Details

- **Public Subnets**: For SAP frontend applications accessible over HTTP/HTTPS and a custom SAP port.
- **Private Subnets**: For backend SAP services and the ETL worker, accessible only from within the VPC.
- **Aviatrix Spoke Gateways**: Provide secure routing for outbound communication from both the public and private subnets, preventing direct internet access from private subnets.

## Example Architecture

| Component           | Subnet           | Security Group | Ports          |
| ------------------- | ---------------- | -------------- | -------------- |
| **Frontend 1**      | Public Subnet 1  | `public_sg`    | 80, 443, 50000 |
| **Frontend 2**      | Public Subnet 2  | `public_sg`    | 80, 443, 50000 |
| **SAP HANA DB**     | Private Subnet 1 | `private_sg`   | 30015, 3306    |
| **SAP App Server**  | Private Subnet 2 | `private_sg`   | 30015, 3306    |
| **Secret workload** | Private Subnet 1 | `sec_sg`       | 8080           |

## Aviatrix Smart Groups and WebGroups

**Aviatrix Security Smart Groups** are a feature of the Aviatrix platform designed to simplify and centralize the management of security rules for traffic control across cloud environments. They provide a logical abstraction for grouping resources and applying security policies at scale. 

---

### **Core Principles of Security Smart Groups**

1. **Logical Grouping**:
    
    - Security Smart Groups group resources based on logical functions (e.g., frontend, backend, database).
    - Groups can consist of VPCs, subnets, instances, or even entire application tiers.
2. **Centralized Policy Management**:
    
    - Policies are defined centrally on the Aviatrix Controller and then enforced at the gateways (e.g., Spoke Gateways).
    - This simplifies operations in environments spanning multiple VPCs, regions, or cloud providers.
3. **Dynamic Membership**:
    
    - Resources can be dynamically added to or removed from groups based on tags, metadata, or predefined criteria.
    - This makes it easy to adapt to changes in infrastructure without manual reconfiguration.
4. **Micro-Segmentation**:
    
    - Enables fine-grained control over traffic flow within the cloud environment.
    - Policies can be tailored to allow or deny specific traffic between groups, improving security posture.

---

### **Key Features**

1. **Granular Security Policies**:  
    Security Smart Groups allow administrators to define **allow** or **deny** rules at a granular level for:
    
    - Traffic between groups (east-west traffic).
    - Traffic to/from the internet or on-premises (north-south traffic).
2. **Application-Aware Filtering**:  
    Policies can filter traffic based on application protocols (e.g., HTTP, HTTPS, database-specific ports).
    
3. **Cross-Cloud and Hybrid Support**:  
    Smart Groups span across VPCs, accounts, regions, and cloud providers, making them ideal for hybrid and multi-cloud deployments.
    
4. **Dynamic Tagging**:  
    Resources can be automatically added to Smart Groups based on tags, ensuring policies are always up-to-date with infrastructure changes.
    
5. **Centralized Monitoring and Logging**:  
    All security policy enforcement and traffic flows are monitored centrally, providing detailed insights for troubleshooting and audits.
    

---

### **How It Works**

1. **Define Security Smart Groups**:
    
    - Create groups based on workload roles (e.g., `Frontend_Smart_Group`, `Backend_Smart_Group`).
    - Add resources to these groups dynamically using tags or static IP(CIDR) ranges.
2. **Apply Policies**:
    
    - Define security rules between groups, specifying:
        - Allowed protocols and ports (e.g., allow HTTP/HTTPS from `Frontend_Smart_Group` to `Backend_Smart_Group`).
        - Denied traffic patterns (e.g., block internet access for `Backend_Smart_Group`).
3. **Policy Enforcement**:
    
    - Aviatrix Spoke Gateways enforce these policies in real time.
    - Traffic between groups or to/from external networks is evaluated against these rules.
4. **Visibility and Insights**:
    
    - Use Aviatrix CoPilot to visualize Smart Group traffic.
    - Analyze security logs for rule hits, drops, or potential misconfigurations.
### **Benefits of Aviatrix Smart Groups**

1. **Consistency Across Clouds**:  
    Apply the same security policies across AWS, Azure, GCP, or on-premises environments.
    
2. **Scalability**:  
    Manage hundreds or thousands of rules without the complexity of native cloud firewall configurations.
    
3. **Automation-Ready**:  
    Integrate with CI/CD pipelines or infrastructure as code tools (e.g., Terraform) to dynamically manage Smart Groups.
    
4. **Enhanced Security**:  
    Reduce the attack surface with zero trust principles and micro-segmentation.


## WebGroups

**Aviatrix WebGroups** are logical constructs within the Aviatrix platform designed to control and secure web traffic. They enable centralized management of web-based traffic filtering, allowing administrators to enforce policies for accessing or exposing web services across their network. This feature integrates seamlessly with Aviatrix gateways to enhance security and compliance for web-facing applications.

---

### **Core Principles of WebGroups**

1. **Traffic Segmentation**:
    
    - WebGroups allow you to group web services (e.g., specific HTTP/HTTPS endpoints) based on their purpose or sensitivity.
    - These groups can include applications, services, or APIs hosted across different subnets, VPCs, or even cloud providers.
2. **Centralized Management**:
    
    - Policies are defined and enforced at the Aviatrix Controller, simplifying the administration of complex environments with multiple web services.
3. **Fine-Grained Access Control**:
    
    - WebGroups enable you to define rules that allow or block access to specific web resources, ensuring only authorized traffic flows.

---

### **Key Features**

1. **URL and Domain Filtering**:
    
    - Control access to specific URLs or domains. For example, you can restrict backend services from accessing external web resources.
2. **Application-Specific Rules**:
    
    - Enforce rules based on application-specific ports (e.g., HTTP 80, HTTPS 443).
3. **Dynamic Membership**:
    
    - Resources can be automatically added to WebGroups based on tags, metadata, or IP addresses, ensuring the groups are always aligned with infrastructure changes.
4. **Cross-Cloud Compatibility**:
    
    - WebGroups work across multiple clouds and on-premises environments, providing a consistent security posture.
5. **Visibility and Analytics**:
    
    - Monitor and log web traffic associated with WebGroups to identify anomalies, policy violations, or optimization opportunities.

---

### **How It Works**

1. **Define WebGroups**:
    
    - Group web-based services logically (e.g., `Frontend_Web_Group`, `Backend_Web_Group`).
    - Add resources to the group dynamically or manually using:
        - Tags (e.g., `Environment: Production`, `App: Frontend`).
        - Specific IP addresses or subnets.
2. **Create WebGroup Policies**:
    
    - Define rules that control traffic flow between WebGroups or external entities.
    - Examples:
        - Allow all traffic from `Frontend_Web_Group` to `Backend_Web_Group` on HTTPS (port 443).
        - Deny access from `Backend_Web_Group` to the public internet.
3. **Policy Enforcement**:
    
    - Aviatrix gateways enforce the policies at the network edge, ensuring secure communication between WebGroups or with external resources.
4. **Monitor and Audit**:
    
    - Use the Aviatrix Controller or CoPilot for real-time monitoring and auditing of web traffic governed by WebGroups.

### SNI Filtering in Relation to WebGroups?

**Server Name Indication (SNI) Filtering** is a mechanism used in web traffic management to inspect and control encrypted HTTPS traffic. Within the context of **Aviatrix WebGroups**, SNI filtering allows administrators to enforce security policies by analyzing the **server name** embedded in the TLS handshake of HTTPS traffic without decrypting it. This capability is particularly useful for enforcing web access controls in multi-cloud and hybrid environments.

---

### **Understanding SNI in HTTPS**

1. **TLS Handshake with SNI**:  
    When a client initiates an HTTPS connection to a server, the **Server Name Indication (SNI)** is included in the TLS handshake. This indicates the hostname of the server the client wants to connect to.
    
    - Example: A client trying to access `example.com` will send "example.com" in the SNI field before encryption begins.
2. **Why SNI is Important for Filtering**:
    
    - Since the SNI field is visible during the handshake (before encryption), it can be inspected without decrypting the traffic.
    - This enables filtering based on the hostname, providing a way to block or allow access to specific domains or services.

---

### **How SNI Filtering Works with WebGroups**

Aviatrix integrates **SNI filtering** with **WebGroups** to control access to web resources based on the hostname (SNI) of HTTPS traffic. Here's how it works:

1. **WebGroup Configuration with SNI Rules**:
    
    - Administrators define WebGroups that represent logical collections of web resources (e.g., `Frontend_Web_Group` or `Admin_Web_Group`).
    - SNI filtering rules can then be applied to these WebGroups to allow or block specific hostnames.
2. **Policy Enforcement at Gateways**:
    
    - Aviatrix Spoke Gateways inspect the SNI field of HTTPS traffic passing through them.
    - If the hostname matches a rule (allow or deny), the traffic is either permitted or dropped.
3. **Dynamic Filtering**:
    
    - Policies can include wildcards or patterns to dynamically filter multiple related domains.
        - Example: Allow `*.example.com` but block `restricted.example.com`.
4. **Integration with Centralized Management**:
    
    - All SNI filtering policies are centrally managed via the Aviatrix Controller, ensuring consistent enforcement across clouds and regions.

---

### **Use Cases for SNI Filtering with WebGroups**

1. **Blocking Unwanted Domains**:
    
    - Prevent access to known malicious or unapproved domains (e.g., `example-phishing.com`).
2. **Allowlisting Approved Domains**:
    
    - Restrict access to only a set of approved domains for specific workloads.
        - Example: Backend servers can only communicate with `api.partner-domain.com`.
3. **Segregating Web Traffic**:
    
    - Ensure that sensitive resources are only accessible from specific WebGroups.
        - Example: Only allow `Admin_Web_Group` to access `admin.example.com`.
4. **Compliance and Governance**:
    
    - Enforce compliance by blocking access to unauthorized or non-compliant external resources.
5. **Cloud-Specific Domain Management**:
    
    - Manage access to cloud-native services (e.g., block non-essential connections to `*.gcp.com` from an AWS VPC).

### **Comparison: Security Smart Groups vs. WebGroups**

| Feature                | Security Smart Groups                     | WebGroups                                  |
| ---------------------- | ----------------------------------------- | ------------------------------------------ |
| **Purpose**            | General traffic control and segmentation. | Specific to web traffic filtering.         |
| **Resource Scope**     | Covers all types of traffic.              | Focuses on web protocols (HTTP/HTTPS).     |
| **Use Case**           | Micro-segmentation, hybrid connectivity.  | URL/domain filtering, web traffic control. |
| **Policy Granularity** | General allow/deny rules for any traffic. | Specific to web-based protocols.           |

## Demo environment

This environment utilizes **4 Smart Groups** and **4 WebGroups** to manage traffic and security across different workloads:

### Smart Groups:

1. **Frontend_Smart_Group**:
    
    - Manages all resources related to SAP frontend applications in the **public subnets** (`aviacore-pub-sub1`, `aviacore-pub-sub2`).
    - EC2 Instances: `Frontend 1`, `Frontend 2`
    - Ports: 80, 443, 50000
2. **Backend_Smart_Group**:
    
    - Manages SAP backend services, including the SAP HANA and SAP S/4HANA app servers in the **private subnets** (`aviacore-priv-sub1`, `aviacore-priv-sub2`).
    - EC2 Instances: `SAP HANA Instance`, `SAP App Server`
    - Ports: 30015 (SAP HANA), 3306 (DB)
3. **ETL_Smart_Group**:
    
    - Manages the ETL workload in the **private subnet** (`aviacore-priv-sub1`).
    - EC2 Instance: `ETL Worker`
    - Ports: 8080
4. **Aviatrix_PSF_Smart_Group**:
    
    - Manages the Aviatrix Public Subnet Filtering (PSF) which applies filtering to public subnet traffic.
    - Resources: Aviatrix PSF
    - Subnets: Public Subnets (`aviacore-pub-sub1`, `aviacore-pub-sub2`)

### WebGroups:

1. **Frontend_Web_Group**:
    
    - Handles web traffic (HTTP/HTTPS) to frontend SAP applications (`Frontend 1`, `Frontend 2`).
2. **Backend_Web_Group**:
    
    - Manages internal traffic to backend services (`SAP HANA DB`, `SAP App Server`).
3. **Secret workload**:
    
    - Handles internal traffic for the ETL process and data loading for the secret workload (`ETL Worker`).
4. **PSF_Web_Group**:
    
    - Manages the web traffic filtering rules for public-facing applications, ensuring secure access to the frontend.


#----------------------------------------------------------------linkedin stuff---------------------------------------------------------------------------------------
## Spoke gateway

Aviatrix Systems is an AWS Partner Network (APN) Advanced Technology Partner with the AWS Networking Competency. AWS Transit Gateway can be used to connect Virtual Private Clouds (VPCs) in a hub-and-spoke architecture, simplifying the connectivity between VPCs and on-premises networks. You can connect an external device (External (or 3rd Party) Router/Firewall) to Aviatrix spoke gateways that are enabled with BGP (and NAT).

## What is aviatrix controller

The Aviatrix Controller manages the Gateways and orchestrates all connectivities. From the Controller console, quickly build use case driven solutions for: Multi Cloud Global Transit Networks to connect datacenter to cloud. Egress Control that applies FQDN fillter for EC2 to Internet traffic. It can also speack to native APIs for different CSPs

## Aviatrix gateways

They are represented by cirlcles with arrows pointing toward each other. They represent distributed data plane for the platform Deployed from the platform and never directly interacted with.

## CoPilot

Presented by a red icon with pilot hat It is for day 2 operations It provides

- Mucti-cloud operation visibility

- FlowIQ multi-cloud traffic flow

- Multi-cloud dynamic topology mapping