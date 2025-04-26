# WP Unit Test Boilerplate

A Docker-powered WordPress plugin boilerplate designed to help plugin developers add **automated unit testing** to their plugins quickly and easily.

This project provides:
- A Docker-based environment for spinning up a full WordPress installation.
- Auto-activation of the plugin and execution of PHPUnit tests.
- GitLab CI integration for running tests and collecting reports.

## ✅ Features

- Run WordPress unit tests from **any operating system** with Docker support.
- CI-ready setup with `.gitlab-ci.yml`.
- Easy start/stop scripts to manage your local testing environment.
- PHPUnit results are exported and saved as **GitLab test artifacts**.
- Built-in **plugin checker** for WordPress coding standards.

---

## 🏗️ Project Structure

```
.
├── start.sh              # Start WordPress and run tests locally
├── stop.sh               # Stop and clean up Docker containers
├── .gitlab-ci.yml        # GitLab CI pipeline configuration
├── ci/docker/            # Docker config and environment files
│   ├── .env.testing
│   ├── compose.yml
│   └── wp/
│       ├── Dockerfile
│       └── wp-cli.yml
├── composer.json         # Dev dependencies and autoload config
├── phpunit.xml           # PHPUnit configuration
├── tests/                # PHPUnit test classes and bootstrap
│   ├── bootstrap.php
│   └── FirstTest.php
├── wp-unit-test.php      # Main plugin file
└── index.php             # Silence placeholder
```

## 🚀 Usage

### Run Tests Locally

```bash
./start.sh
```

This command will:
- Copy plugin files to a temp build dir
- Spin up WordPress + MariaDB containers
- Install and activate your plugin
- Run PHPUnit and `plugin-check`
- Output test results

To shut everything down:

```bash
./stop.sh
```

---

## 🧪 GitLab CI Integration

Tests run automatically when pushed to GitLab. The pipeline:
1. Builds a fresh WordPress environment.
2. Installs and activates the plugin.
3. Runs PHPUnit tests and plugin checks.
4. Stores test reports as GitLab artifacts.

You can configure your GitLab Runner to allow Docker-in-Docker by setting `privileged = true`.

---

## 📁 Reports & Artifacts

- `reports/phpunit-report.xml`: JUnit report for GitLab.
- `reports/plugin-check-report.md`: WordPress plugin check output.

---

## 🧰 Requirements

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- GitLab CI (optional)

---

## 🧪 How to Add PHPUnit Testing to Your Existing WP Plugin

To make your WordPress plugin PHPUnit test-ready using this boilerplate, follow these steps:

### ✅ Required Files and Folders to Copy
Copy the following files and folders into the root of your plugin directory:

```bash
├── ci/                     # Docker setup and configuration
│   └── docker/
├── tests/                  # PHPUnit test classes and bootstrap
├── .gitlab-ci.yml          # GitLab CI automation
├── composer.json           # PHPUnit dependency
├── phpunit.xml             # PHPUnit configuration
├── start.sh                # Script to start test environment and run tests
├── stop.sh                 # Script to stop containers and clean up
```

### Steps After Copying
* Update the plugin slug in `ci/docker/.env.testing`:
```dotenv
WP_PLUGIN_SLUG=your-plugin-slug
```

* Update composer.json and namespaces (optional):

	* Adjust the autoload namespace to match your plugin's test structure.
	* Rename the test suite inside phpunit.xml if desired.

* Write your test cases inside the tests/ directory following the example in FirstTest.php.
* Run Tests:
	* Locally: `./start.sh`
	* On GitLab CI: Push your changes and GitLab will run the tests automatically.
