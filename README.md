Prerequisites:
Terraform  (terraform version 0.15.1):

* `git clone https://github.com/chili94/get-task.git` - Clone this repo.
* `cd get-task` - Change directory to get-task.
* `Create terraform.tfvars` file, which is used to pass parametars to variables.tf (check terraform.tfvars_sample)
* `terraform init` - Initialize terraform (download required drivers).
* `terraform validate` - Check syntax.
* `terraform plan -out example` - Create terraform example plan.
* `terraform apply example` - Apply terraform "example" plan generated in above step.

when you create a file `terraform.tfvars` you have to enter your path to the public key and also the ip address from which you will access.
