# ODK Central Automated Setup 🚀

[![Development Deployment Status](https://img.shields.io/github/actions/workflow/status/clovisphere/odk-installer/deploy.yml?branch=development&label=Development%20Deploy)](https://github.com/clovisphere/odk-installer/actions?query=workflow%3ADeploy%20ODK%20Central+branch%3Adevelopment) [![Production Deployment Status](https://img.shields.io/github/actions/workflow/status/clovisphere/odk-installer/deploy.yml?branch=main&label=Production%20Deploy)](https://github.com/clovisphere/odk-installer/actions?query=workflow%3ADeploy%20ODK%20Central+branch%3Amain)

This repository contains scripts to automate the local installation of [ODK Central](https://github.com/getodk/central) using Docker Compose.

## Prerequisites ⚙️

Before running the installation script, ensure you have the following installed on your system:

* **Docker Engine:** Follow the installation instructions for your operating system from the [official Docker documentation](https://docs.docker.com/engine/install/).
* **Docker Compose:** Follow the installation instructions from the [official Docker Compose documentation](https://docs.docker.com/compose/install/).
* **Git:** Git is required to clone the ODK Central repository. You likely have it installed, but if not, you can find installation instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Getting Started ▶️

1.  **Clone this repository:**

    ```bash
    git clone <YOUR_REPOSITORY_URL>
    cd <YOUR_REPOSITORY_NAME>
    ```

2.  **Make the installation script executable:**

    ```bash
    chmod +x install.sh
    ```

3.  **Run the installation for your desired environment:**

    * **Local Installation (default):**

        ```bash
        make local
        ```

        This will install ODK Central using the configurations in the `.env.local` file.

    * **Development Installation:**

        ```bash
        make dev
        ```

        This will use the configurations in the `.env.dev` file.

    * **Production-like Installation (for local testing):**

        ```bash
        make prod
        ```

        This will use the configurations in the `.env.prod` file.

    You can also specify a different ODK Central version using the `ODK_VERSION` variable:

    ```bash
    ODK_VERSION=v2024.3.2 make local
    ```

## Configuration 🛠️

The installation uses environment-specific `.env` files for configuration:

-   `.env.local`: Contains basic settings for a local testing environment.
-   `.env.dev`: Contains settings for a development environment (e.g., different port mappings, debugging options).
-   `.env.prod`: Contains settings for a production-like local test (e.g., specific domain if testing, different storage paths).

**Before running the installation, review and modify these `.env` files to match your desired settings.** You can duplicate `.env.sample` to create these environment-specific files.

## GitHub Actions for Automated Deployment ⚙️

This repository includes a GitHub Actions workflow ([deploy.yml](./.github/workflows/deploy.yml)) to automate the deployment of ODK Central to development and production servers when code is pushed to the `development` and `main` branches, respectively. The workflow utilizes SSH to connect to your servers and execute the deployment scripts.

### GitHub Actions Variables and Secrets 🔑

The deployment workflow ([deploy.yml](./.github/workflows/deploy.yml)) relies on the following **GitHub Actions Variables** and **Secrets** configured in your repository's "Settings" under "Secrets and variables" -> "Actions":

#### Variables (`Variables`) ⚙️

Variables are used for non-sensitive configuration values that control the deployment process.

* `CAN_DEPLOY_DEV`: Set to the exact string `"True"` (case-sensitive) to enable automatic deployment to the development server on pushes to the `development` branch. Set to any other value (or leave undefined) to disable automatic deployment.
* `CAN_DEPLOY_PROD`: Set to the exact string `"True"` (case-sensitive) to enable automatic deployment to the production server on pushes to the `main` branch. Set to any other value (or leave undefined) to disable automatic deployment.
* `ODK_DEV_HTTP_PORT`: The HTTP port for your development ODK Central instance.
* `ODK_DEV_HTTPS_PORT`: The HTTPS port for your development ODK Central instance.
* `ODK_PROD_HTTP_PORT`: The HTTP port for your production ODK Central instance.
* `ODK_PROD_HTTPS_PORT`: The HTTPS port for your production ODK Central instance.

#### Secrets (`Secrets`) 🔒

Secrets are used for sensitive information required for the deployment process. **Ensure these are configured securely in your repository settings.**

> Development Server 🧪

* `DEV_HOST`: The hostname or IP address of your development server.
* `DEV_USER`: The username to use when SSHing into your development server.
* `DEV_SSH_PRIVATE_KEY`: The private SSH key (including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`) to authenticate with your development server.
* `DEV_PORT`: The SSH port for your development server (usually `22`).
* `ODK_DEV_DOMAIN`: The domain name for your development ODK Central instance.
* `ODK_DEV_SYSADMIN_EMAIL`: The system administrator email for your development ODK Central instance.
* `ODK_DEV_SSL_TYPE`: The SSL type (`letsencrypt`, `customssl`, `upstream`, `selfsign`) for your development ODK Central instance.

> Production Server 🏭

* `PROD_HOST`: The hostname or IP address of your production server.
* `PROD_USER`: The username to use when SSHing into your production server.
* `PROD_SSH_PRIVATE_KEY`: The private SSH key for your production server.
* `PROD_PORT`: The SSH port for your production server (usually `22`).
* `ODK_PROD_DOMAIN`: The domain name for your production ODK Central instance.
* `ODK_PROD_SYSADMIN_EMAIL`: The system administrator email for your production ODK Central instance.
* `ODK_PROD_SSL_TYPE`: The SSL type for your production ODK Central instance.

**Note:** The `.env.dev` and `.env.prod` files used for local testing are separate from the Secrets configured here for remote server deployments.

**Before pushing to your `development` or `main` branches, ensure you have configured these Variables and Secrets in your GitHub repository.**

## Known Issues ⚠️

-   On MacOS or/and Windows, you may encounter an issue related to `mount` permissions. To resolve this, follow the instructions provided [here](https://github.com/getodk/central#services).

## Next Steps (AWS Deployment) 🚧

> Not yet implemented.

## Contributing 🙌

Feel free to fork this project and/or submit pull requests. Contributions are welcome!

## License 📄

This project is open-source and licensed under the [MIT License](./LICENSE).
