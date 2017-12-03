# Azure Subscription Base
This module creates a hub and spoke model of subscription management.

This module will create:
- [x] Network Resource Group
  - [x] Virtual Network
  - [x] App Subnet
  - [x] Data Subnet
  - [x] Web Subnet
  - [ ] Course Grain NSG
- [x] DNS Resource Group
  - [x] DNS Zone for the Subscription
  - [x] DNS NS record in the hub azure dns zone

If the Spoke flag is true, this module will create:
- [x] DNS Parent Zone for the subscription (that will be used as a parent domain for all the subscriptions, including the hub)
- [x] Peering to the Hub
- [x] Peering from the Hub

If the Spoke flag is False (i.e. is a hub), this module will create:
- [x] A Parent DNS Zone for the tenant

For an example, see /example/Hub and Spoke/