# Overview
Quickly create a chef automate instace for testing

#### Supported platform families:
  * Debian
  * RHEL
  * SUSE

## Usage
Copy the terraform.tfvars.example file to terraform.tfvars and fill in the missing
variables

### Example
```
aws_region                          = "eu-west-1"
aws_profile                         = "testing"
aws_creds_file                      = "/home/jdoe/.aws/credentials"

automate_cidrs                      = ["53.61.3.2/32"]
automate_key_name                   = "jdoe_key"
automate_ssh_user_private_key       = "/home/jdoe/.ssh/eu_west_1"
automate_ingest_token               = "token1234"
automate_admin_password             = "zaq12wsx"
automate_create                     = true

automate_instance_type              = "t3.large"
automate_products                   = ["automate", "infra-server"]

automate_license = "dadjaslkdjsakldjaslkjdlaskjdlaskdjaskldjaskldjaskldj

automate_enabled_profiles = [
  {
    "name"     = "cis-aws-benchmark-level1",
    "version" = "latest",
    "owner"   = "admin"
  },
  {
    "name"    = "cis-sles11-level1",
    "version" = "1.1.0-7",
    "owner"   = "admin"
  }
]

tags = {
  "X-Dept" = "Eng",
  "X-Contact" = "jdoe@chef.io",
  "X-Project" = "testing"
}
```

the profiles specified in the `automate_enabled_profiles` list will be automatically enabled on the chef automate instance. And an ingest token will be create matching the string provided in the `automate_ingest_token` variable
