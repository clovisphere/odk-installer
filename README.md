# ODK Central Automated Setup

This repository contains scripts to automate the local installation of [ODK Central](https://github.com/getodk/central) using Docker Compose.

## Prerequisites

Before running the installation script, ensure you have the following installed on your system:

* **Docker Engine:** Follow the installation instructions for your operating system from the [official Docker documentation](https://docs.docker.com/engine/install/).
* **Docker Compose:** Follow the installation instructions from the [official Docker Compose documentation](https://docs.docker.com/compose/install/).
* **Git:** Git is required to clone the ODK Central repository. You likely have it installed, but if not, you can find installation instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Getting Started

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
    make local ODK_VERSION=v2024.3.2
    ```

## Configuration

The installation uses environment-specific `.env` files for configuration:

- *.env.local*: Contains basic settings for a local testing environment.
- *.env.dev*  : Contains settings for a development environment (e.g., different port mappings, debugging options).
- *.env.prod* : Contains settings for a production-like local test (e.g., specific domain if testing, different storage paths).

**Before running the installation, review and modify these `.env` files to match your desired settings.** You can duplicate `.env.sample` to create these environment-specific files.

## Next Steps (AWS Deployment)

This repository also lays the groundwork for automating deployment to an AWS server. Once you have tested the local installation, we can explore setting up a CI/CD workflow using GitHub Actions to automatically deploy changes to your AWS development server.

## Contributing

Feel free to fork this project and/or submit pull requests. Contributions are welcome!

## License

This project is open-source and licensed under the [MIT License](./LICENSE).
