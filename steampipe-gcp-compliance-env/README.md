# steampipe-gcp-compliance-env

This directory has some codes to configure a GCP project to make some CIS v2.0.0 tests pass.

## How to use

Prerequisite

- terraform <https://developer.hashicorp.com/terraform/install> 
- a GCP project which has a notification channel.


Check the resources which are going to be created.

```bash
terraform plan --var="notification_channel_display_name=your-name" --var="project_id=your-project"
```

Create the resources.

```bash
terraform plan --var="notification_channel_display_name=your-name" --var="project_id=your-project"
```

Some errors might occur when alert_policy is created but you can solve it just by retrying the command.

Then, the GCP project has some logging_metrics and alert_policeies enough to pass CIS v2.0.0 between 2.4 and 2.11

After every test seems ok, destroy the configurations.

```bash
terraform destroy --var="notification_channel_display_name=your-name" --var="project_id=your-project"
```