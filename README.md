# Ansible provisioning using terraform

This environment can be used to:
- Provision machines (create.yml)
- Remove machines (destroy.yml)

As neither terraform nor ansible offer integration, these playbooks offer the
benefits of both tools.

## Overview

```
+------------------+    | - Ansible uses Terraform to create resource.
| Ansible "Create" |    |   In the directory ./terraform the infrastructure
+------------------+    |   is described.
         |              |
         V              |
 +---------------+      | - In this example Digital Ocean hosts:
 | Digital Ocean |      |   - Droplets (instance)
 +---------------+      |   - Loadbalancer
         ^              |   - IP Addresses
         |              |
+-------------------+   | - Ansible is configured (ansible.cfg) to use a dynamic
| Dynamic Inventory |   |   inventory. This queries Digital Ocean of hosts.
+-------------------+   |   All hosts are reported back.
         |              |
         V              |
+---------------------+ | - After the droplets are created, the instances are
| Ansible "Configure" | |   configured using common Ansible syntax.
+---------------------+ |
```

## Required software
- ansible
- terraform

## Using the playbooks

Some variables needs to be set.
- DO_API_TOKEN - The Digital Oceans token, used in scripts & dynamic inventory.
- TF_VAR_do_api_token - Same as DO_API_TOKEN, used in terraform
- TF_VAR_cf_api_token - The CloudFlare token, used in terraform
- TF_VAR_aws_acces_key - The Amazon AWS access key, used in terraform
- TF_VAR_aws_secret_key - The Amazon AWS secret key, used in terraform


Here is an example of how to set the variables.

```
export DO_API_TOKEN="abc123"
export TF_VAR_do_api_token="${DO_API_TOKEN}"
export TF_VAR_cf_api_token="abc123"
export TF_VAR_aws_acces_key="abc123"
export TF_VAR_aws_secret_key="abc123"
```

Most Digital Ocean images require the use of an SSH key.

Here is how to load an SSH key:
```
ssh-add ~/.ssh/id_dsa
```

Now that everything is loaded, you can start to:

## Define in what regions you'd like to deploy
Look in `create-terraform-files.yml` and (un)comment all desired regions.
Run the first playbook when done:

```
ansible-playbook create-terraform-files.yml
````

This creates files in the terraform directory.
These files instruct terraform what to build.

## Deploy the infrastructure.
To see what terraform is going to do:

```
cd terraform
terraform plan
cd ../
```

Whenever you are ready to deploy: (This is going to cost money!)

```
ansible-playbook create-infrastructure.yml
```

This will run for a couple of minutes.

Whenever you're done experimenting:

```
ansible-playbook destroy-infrastructure.yml
```
