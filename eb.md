# 🌱 AWS Elastic Beanstalk (EB CLI) Commands Cheat Sheet

---

## 🔹 Installation & Version

```bash
pip install awsebcli --upgrade
```

```bash
eb --version
```

---

## 🔹 Basic Setup

```bash
eb init
```

👉 Initializes EB in the current directory

* Select region
* Select application
* Select platform (Node.js, Python, .NET, Docker, etc.)
* Configure SSH (optional)

---

## 🔹 Application & Environment

```bash
eb create <env-name>
```

Creates a new environment

```bash
eb list
```

Lists all environments

```bash
eb use <env-name>
```

Sets default environment

```bash
eb status
```

Shows environment status

---

## 🔹 Deployments

```bash
eb deploy
```

Deploys the current application version

```bash
eb deploy <env-name>
```

Deploys to a specific environment

```bash
eb appversion
```

Lists application versions

---

## 🔹 Logs & Health

```bash
eb health
```

Shows environment health

```bash
eb events
```

Displays recent events

```bash
eb logs
```

Fetch logs

```bash
eb logs --all
```

Fetch complete logs

```bash
eb logs --zip
```

Download logs as ZIP

---

## 🔹 Environment Management

```bash
eb open
```

Opens app URL in browser

```bash
eb restart
```

Restarts app servers

```bash
eb rebuild
```

Rebuilds environment (re-provision EC2)

```bash
eb scale <number>
```

Scales number of instances

---

## 🔹 SSH & Debugging

```bash
eb ssh
```

SSH into EC2 instance

```bash
eb ssh --setup
```

Configures SSH keys

```bash
eb printenv
```

Print environment variables

```bash
eb setenv KEY=value
```

Set environment variables

```bash
eb setenv KEY1=value1 KEY2=value2
```

---

## 🔹 Configuration

```bash
eb config
```

Open environment configuration editor

```bash
eb config save
```

Save current configuration locally

```bash
eb config put <config-name>
```

Apply saved configuration

---

## 🔹 Termination & Cleanup ⚠️

```bash
eb terminate
```

Terminate current environment

```bash
eb terminate <env-name>
```

```bash
eb delete
```

Delete application (after all envs terminated)

---

## 🔹 CI/CD & Automation Friendly

```bash
eb deploy --staged
```

Deploy only staged changes

```bash
eb deploy --label v1.0.0
```

Deploy with version label

```bash
eb local run
```

Run app locally using Docker

```bash
eb local open
```

---

## 🔹 Useful Flags

```bash
--profile <aws-profile>
--region <region>
--verbose
--debug
```

Example:

```bash
eb deploy --profile dev --region ap-south-1
```

---

## 🧠 Typical Workflow (Quick)

```bash
eb init
eb create production
eb deploy
eb open
eb logs
eb terminate production
```

---
