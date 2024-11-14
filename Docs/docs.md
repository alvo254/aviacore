# Docs


This Terraform configuration creates an AWS Virtual Private Cloud (VPC) with public and private subnets and deploys a sample SAP workload. It includes frontend-facing applications in the public subnets and backend services in the private subnets, along with appropriate routing and security configurations.

## Overview

This setup aims to simulate a basic SAP workload, with:

- **Frontend applications** in public subnets for user-facing access.
- **Backend services** in private subnets, securely connected to the frontend applications.
- **Aviatrix Spoke Gateways** to enable communication between the private subnets and external networks.

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

|Component|Subnet|Security Group|Ports|
|---|---|---|---|
|**Frontend 1**|Public Subnet 1|`public_sg`|80, 443, 50000|
|**Frontend 2**|Public Subnet 2|`public_sg`|80, 443, 50000|
|**SAP HANA DB**|Private Subnet 1|`private_sg`|30015, 3306|
|**SAP App Server**|Private Subnet 2|`private_sg`|30015, 3306|
|**ETL Worker**|Private Subnet 1|`etl_sg`|8080|

## Aviatrix Smart Groups and WebGroups

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
3. **ETL_Web_Group**:
    
    - Handles internal traffic for the ETL process and data loading (`ETL Worker`).
4. **PSF_Web_Group**:
    
    - Manages the web traffic filtering rules for public-facing applications, ensuring secure access to the frontend.



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