## Purpose

The purpose of this stage is to set up the common folder used to house projects that contain shared resources such as DNS Hub, Interconnect, Security Command Center notification, org level secrets, network hub and org level logging. This will create the following folder and project structure:
   ```text
   example-organization
        └── xx-infra (folder)
        ├── xx-logging-prod
        ├── xx-security-prod
        └── xx-nethub-prod
   ```

### Logging
This project is organization wide billing, applications and infra logs. The logs are collected into BigQuery datasets which you can then use for general querying, dashboarding, and reporting. Logs are also exported to Pub/Sub, a Cloud Storage bucket, and a log bucket.
### Nethub
This project is designed to serve as the hub for both the networks and DNS within the organization. It essentially contains two types of networks.
1. **DMZ Network**: Also known as the 'demilitarized zone' network, the DMZ network hosts internet-facing appliances. This includes tools like NAT (Network Address Translation), routers, and HTTP Proxies. DMZ network acts as a buffer zone between the public internet and the internal network of your organization, enhancing security by limiting exposure to potential threats from the internet.
2. **Internal Hub Network**: unlike the DMZ, the internal hub network is designed primarily for intra-organizational connectivity. It facilitates secure and efficient communication within your organization. Additionally, it can also be linked to on-premise infrastructure via VPN (Virtual Private Network) or Interconnect, enabling seamless integration between cloud-based and on-premise resources.

### Security
This project, overseen by your organization's security teams, forms the foundation for centralized audit logs and security alerts at the organization level. This secure hub will feature a Pub/Sub topic and subscription, along with a Security Command Center notification set up to broadcast all new findings to the established topic. Furthermore, it serves as a home for the Secret Manager, where your organization can safely store and share secrets.
