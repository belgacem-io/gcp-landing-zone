### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/h-belgacem/eks-apigee.git
   ```
2. Setup your local environment
   ```sh
   make up
   ```
3. Create an '.env' file and add GCP credentials 
   ```sh
    export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/application_default_credentials.json
   ```
4. Apply terraform scripts
   ```sh
    make apply eks
   ```
