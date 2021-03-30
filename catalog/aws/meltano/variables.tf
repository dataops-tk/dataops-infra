##############################################
### Standard variables for all AWS modules ###
##############################################

variable "name_prefix" {
  description = "Standard `name_prefix` module input. (Prefix counts towards 64-character max length for certain resource types.)"
  type        = string
}
variable "environment" {
  description = "Standard `environment` module input."
  type = object({
    vpc_id          = string
    aws_region      = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
}
variable "resource_tags" {
  description = "Standard `resource_tags` module input."
  type        = map(string)
}

########################################
### Custom variables for this module ###
########################################

# Tap and Target Config

variable "taps" {
  description = <<EOF
A list of tap configurations with the following setting keys:

- `id`       - The official id of the tap plugin to be used, without the 'tap-' prefix.
- `name`     - The friendly name of the tap, without the 'tap-' prefix.
- `schedule` - A list of one or more daily sync times in `HHMM` format. E.g.: `0400` for 4am, `1600` for 4pm.
- `settings` - Map of tap settings to their values.
- `secrets`  - Map of secrets names mapped to any of the following:
               A. file path ("path/to/file") that contains a matching key name,
               B. the file path and the json/yaml key ("path/to/file:key"),
               C. the AWS Secrets Manager ID of an already stored secret
EOF
  type = list(object({
    id       = string
    name     = string
    schedule = list(string)
    settings = map(string)
    secrets  = map(string)
  }))
}

variable "project_source" {
  description = <<EOF
The source repo which contains your project source.
If provided as a local reference (without 'http' in the string) the project will be locally linked.
Otherwise, a git-based connection to the repo will be attempted.
EOF
  type        = string
}

# Data Lake Settings

variable "data_lake_type" {
  description = "Specify `S3` if loading to an S3 data lake, otherwise leave blank."
  default     = "S3"
}
variable "data_lake_logging_path" {
  description = <<EOF
The remote folder for storing tap execution logs and log artifacts.
Currently only S3 paths (s3://...) are supported.
EOF
  type        = string
  default     = null
}
variable "data_lake_metadata_path" {
  description = <<EOF
The remote folder for storing tap definitions files.
Currently only S3 paths (s3://...) are supported.
EOF
  type        = string
}
variable "data_lake_storage_path" {
  description = <<EOF
The root path where files should be stored in the data lake.
Note:
 - Currently only S3 paths (S3://...) are supported.
 - You must specify `target` or `data_lake_storage_path` but not both.
 - This path will be combined with the value provided in `data_file_naming_scheme`.
EOF
  type        = string
  default     = null
}

# Orchestration

variable "timeout_hours" {
  description = "Optional. The number of hours before a sync task is canceled and retried."
  type        = number
  default     = 48
}
variable "num_retries" {
  description = "Optional. The number of retries to attempt if the task fails."
  default     = 0
}

# Environment Config

variable "ui_container_num_cores" {
  description = "Optional. Specify the number of cores to use in the container."
  default     = 0.5
}
variable "ui_container_ram_gb" {
  description = "Optional. Specify the amount of RAM to be available to the container."
  default     = 1
}

variable "elt_container_num_cores" {
  description = "Optional. Specify the number of cores to use in the container."
  default     = 0.5
}
variable "elt_container_ram_gb" {
  description = "Optional. Specify the amount of RAM to be available to the container."
  default     = 1
}

variable "use_private_subnet" {
  description = <<EOF
If True, tasks will use a private subnet and will require a NAT gateway to pull the docker
image, and for any outbound traffic. If False, tasks will use a public subnet and will
not require a NAT gateway.
EOF
  type        = bool
  default     = false
}

# File Naming Schemes

variable "data_file_naming_scheme" {
  description = <<EOF
The naming pattern to use when landing new files in the data lake. Allowed variables are:
`{tap}`, `{table}`, `{version}`, and `{file}`. This value will be combined with the root
data lake path provided in `data_lake_storage_path`."
EOF
  type        = string
  default     = "{tap}/{table}/v{version}/{file}"
}
variable "state_file_naming_scheme" {
  description = <<EOF
The naming pattern to use when writing or updating state files. State files keep track of
data recency and are necessary for incremental loading. Allowed variables are:
`{tap}`, `{table}`, `{version}`, and `{file}`"
EOF
  type        = string
  default     = "{tap}/{table}/state/{tap}-{table}-v{version}-state.json"
}

# Advanced Settings (Optional)

variable "container_image_override" {
  description = "Optional. Override the docker images with a custom-managed image."
  type        = string
  default     = null
}
variable "container_image_suffix" {
  description = <<EOF
Optional. Appends a suffix to the default container images.
(e.g. '--pre' for prerelease containers)
EOF
  type        = string
  default     = ""
}
variable "container_command" {
  description = "Optional. Override the docker image's command."
  default     = null
}
variable "container_args" {
  type        = list(string)
  description = "Optional. A list of additional args to send to the container."
  default     = []
}
variable "container_entrypoint" {
  description = "Optional. Override the docker image's entrypoint."
  type        = string
  default     = null
}

variable "alerts_webhook_url" {
  description = "Optionally, specify a webhook for MS Teams notifications."
  type        = string
  default     = null
}
variable "alerts_webhook_message" {
  description = "Optionally, specify a message for webhook notifications."
  type        = string
  default     = <<EOF
Warning: A failure occured in the pipeline. Please check on it using the information below.
EOF
}
variable "success_webhook_url" {
  description = "Optionally, specify a webhook for MS Teams notifications."
  type        = string
  default     = null
}
variable "success_webhook_message" {
  description = "Optionally, specify a message for webhook notifications."
  type        = string
  default     = <<EOF
Success! The pipeline completed successfully.
EOF
}
