# WordPress Provisioner via Puppet

This project automates the provisioning and configuration of a WordPress server running inside an Ubuntu virtual machine using Puppet.

The provisioning process handles the installation, configuration, and integration of all the required components to deploy a functional WordPress environment without requiring manual setup.

## Components Automated

### 1. Apache Web Server

Automates the installation and configuration of Apache HTTP Server, providing the web server infrastructure required to serve WordPress content to visitors.

### 2. MySQL Server

WordPress requires a database to store and manage its content and application data.

Puppet automates the installation and configuration of `mysql-server`, including:
- Database creation for WordPress.
- Dedicated database user creation.
- Configuration of the required access privileges.

This ensures that WordPress can establish a connection to its database and operate correctly.

### 3. PHP

WordPress relies on PHP to execute its application logic and dynamically generate web content.

The provisioning process installs PHP along with the required extensions to ensure compatibility with WordPress and its dependencies.

### 4. WordPress Deployment

The WordPress deployment process is fully automated, including:
- Creation and configuration of the WordPress working directory.
- Installation of the WordPress CLI (`wp`) tool.
- Automated WordPress installation and initial configuration.

Using WP-CLI eliminates the need to perform the initial WordPress installation manually through a web browser.

## Results

Once provisioning is complete, WordPress is ready to use.

Accessing the virtual machine's configured IP address from the host machine's web browser should display the default WordPress blog, confirming that the required services have been installed and configured successfully.

## Configuration and Sensitive Data Management

To avoid hardcoding sensitive information directly into Puppet manifests, this project uses **Hiera**, Puppet's built-in configuration data management system.

Hiera allows configuration data to be separated from Puppet code and organized into different data sources. This makes it possible to define environment-specific values and sensitive configuration parameters that can be dynamically retrieved and assigned to variables within Puppet manifests.

### Required Configuration

Before running the provisioning process, you must create a `data` directory in the root of the cloned repository containing a `common.yaml` file.

The directory structure should look like this:

```text
.
├── data/
│   └── common.yaml
├── manifests/
│   └── default.pp
└── ...
```

The `common.yaml` file must contain the configuration values required by the Puppet classes.

Example:

```yaml
mysql_server::db_name: 'wordpress'
mysql_server::db_username: 'wordpress_user'
mysql_server::db_password: 'your_password_here'
```

### How Hiera Data Mapping Works

Each YAML key follows the `class_name::variable_name: value` naming convention:

- **Class name:** Identifies the Puppet class that consumes the configuration value.
- **Variable name:** Specifies the parameter or variable to which the value is assigned.
- **Value:** Defines the actual configuration value used during provisioning.

For example, `mysql_server::db_password` associates the provided password with the `db_password` parameter of the `mysql_server` class.

This approach keeps configuration data separate from the Puppet manifests, making the project easier to maintain and adapt to different environments.