# Terraform vs OpenTofu — Comparison


### 2) `COMPARISON.md`
```md
# Terraform vs OpenTofu — Comparison

## Summary
- **Core Language & CLI**: HCL syntax and workflow are compatible in day‑to‑day use.
- **State**: Both maintain state; OpenTofu reads existing Terraform state formats.
- **Providers & Modules**: OpenTofu uses the Terraform Registry protocol; most providers/modules work as‑is.
- **Licensing & Governance**: OpenTofu is community‑governed under a true open‑source license.
- **Ecosystem**: Most common CLIs/tools (tflint, tfsec, Infracost) work with either via flags or compatibility layers.

## Day‑to‑day Commands (equivalent)
| Task | Terraform | OpenTofu |
|---|---|---|
| Init | `terraform init` | `tofu init` |
| Validate | `terraform validate` | `tofu validate` |
| Plan | `terraform plan` | `tofu plan` |
| Apply | `terraform apply` | `tofu apply` |
| Destroy | `terraform destroy` | `tofu destroy` |
| Output | `terraform output` | `tofu output` |

> Where tools are Terraform‑name‑hardcoded, use environment variables or wrappers; see `MIGRATION.md`.
