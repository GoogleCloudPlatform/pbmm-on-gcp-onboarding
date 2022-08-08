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
<img width="1262" alt="pbmm_sv-1-landingzone-sys-interface" src="https://user-images.githubusercontent.com/94715080/183471721-0d484056-4b6d-4fe5-a24d-b6b73ae9d083.png">



