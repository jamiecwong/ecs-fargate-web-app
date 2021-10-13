# ECS hosted web app example

This creates an ECS Fargate cluster which runs an example nginx web app.

For ease of deploying this with just a few Terraform commands the service runs on HTTP only. However the resources to enable a HTTPS redirect are commented out in alb.tf should you have a domain and cert that can be used.

For the same reason I haven't created a friendly DNS name as a domain is required. In the example we will just use the load balancer DNS name.

## Deploy the infrastructure using Terraform

You can use Terraform versions 0.13 and later, I used v1.0.8 at the time of writing.
We are using a local backend, but only for ease of use with this example, using a remote backend is recommended.

Run the Terraform commands:
- `cd terraform`
- `terraform init`
- `terraform plan -out tfplan`
- `terraform apply tfplan`

## Obtain the load balancer dns name

This will be output to the terminal after the terraform apply command completes, similar to:
```
Outputs:

load_balancer_dns_name = "ecs-9b8b-alb-example-1496498274.eu-west-2.elb.amazonaws.com"
```
Copy the DNS name and navigate to it in a browser to view the nginx web page.

## Force the service to scale

The service will be running a single task/container to serve the web app.
We will use K6 to send a high number of requests to the service to simulate a large number of users and force it to scale to multiple tasks/containers.

K6 can be installed on Mac using Homebrew: `brew install k6`. Installation methods for alternate operating systems can be found [here](https://github.com/grafana/k6#install).

`cd` into the root of the repo where the `k6_script.js` file is located.
Modify the `k6_script.js` file, replacing `<LOAD_BALANCER_DNS_NAME>` with the load balancer DNS name we received from the terraform apply output earlier. Save the file.

Run K6:
`k6 run k6_script.js`

K6 will begin to send a high number of requests (reaching 200), and will complete after 3 minutes.

This will cause the service ECSServiceAverageCPUUtilization metric to exceed the intentionally low 5% threshold forcing the service to scale. Using the AWS CLI or console you will see that the service has scaled from 1 to multiple tasks/containers.

The CPU Utilization Average metric can be viewed in the CloudWatch console under metrics for Elastic Container Service.

Container logging to CloudWatch logs has also been enabled, the log group is named after the cluster name prefix, e.g. `ecs-9b8b`.

# Monitoring and alerting

The load balancer and target group are monitored for 5XX errors, Cloudwatch alarms are triggered if these errors are detected. An SNS Topic arn can be added to these alarms in `monitoring.tf` so that you can receive the alerts via email.

# Security groups

The nginx web app is set up to be publicly available. The security groups can be amended in `sg.tf` if you intend for it to be accessed only from a secure set of IPs.

# Cleaning up

To remove the infrastructure run the Terraform commands:
- `cd terraform`
- `terraform plan -destroy -out tfplan`
- `terraform apply tfplan`
