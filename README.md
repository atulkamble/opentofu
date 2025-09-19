# terraform-vs-opentofu-starter


starter for **Terraform vs OpenTofu**—with install guides, migration notes, runnable examples, Makefile helpers, and a CI workflow.

Open the full repo content in the canvas on the right. It includes:

* 📘 **README.md**, **COMPARISON.md**, **MIGRATION.md**
* 🧪 Two runnable examples (no cloud costs): `minimal-random/` and `local-file/`
* 🧩 A reusable `modules/greeting/` module
* 🛠️ Makefile targets that work with **either** `tofu` or `terraform`
* 🤖 GitHub Actions workflow for `fmt`, `validate`, and `plan`
* 💻 Platform-specific OpenTofu install guides (macOS, Linux, Windows)
* Compares **Terraform** and **OpenTofu** (feature parity, ecosystem, licensing, migration).
* Shows **installation & configuration** for OpenTofu on macOS, Linux, and Windows.
* Provides **copy‑paste runnable IaC examples** that work with either Terraform or OpenTofu.
* Includes **Makefile** helpers and **GitHub Actions** CI for `fmt`, `validate`, and `plan`.

> All examples avoid cloud costs by using the `random`, `null`, and `local` providers. You can swap in AWS/Azure/GCP providers later.

---

## 📦 Repository Structure

```text
terraform-vs-opentofu-starter/
├─ README.md
├─ COMPARISON.md
├─ MIGRATION.md
├─ .gitignore
├─ .editorconfig
├─ Makefile
├─ .github/
│  └─ workflows/
│     └─ tofu-ci.yaml
├─ install/
│  ├─ INSTALL-macOS.md
│  ├─ INSTALL-Linux.md
│  └─ INSTALL-Windows.md
├─ examples/
│  ├─ minimal-random/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  └─ versions.tf
│  └─ local-file/
│     ├─ main.tf
│     ├─ variables.tf
│     ├─ outputs.tf
│     └─ versions.tf
└─ modules/
   └─ greeting/
      ├─ main.tf
      ├─ variables.tf
      └─ outputs.tf
```

---

## 🧭 Quick Start (OpenTofu *or* Terraform)

> Replace `tofu` with `terraform` to run the same flows via Terraform.

```bash
# in examples/minimal-random
make init   TF=tofu
make plan   TF=tofu
make apply  TF=tofu
make output TF=tofu
make destroy TF=tofu
```

If you skip `TF=...`, `make` defaults to `tofu`. To force Terraform:

```bash
make apply TF=terraform
```

---

## 🧩 Files — copy & paste

### 1) `README.md`

````md
# Terraform vs OpenTofu — Starter & Hands‑On

This repo gives you:
- A concise, factual comparison of Terraform and OpenTofu
- Install and config guides for macOS, Linux, Windows
- Ready‑to‑run examples with either binary (`terraform` or `tofu`)
- Makefile automation and GitHub Actions CI

## How to run
```sh
cd examples/minimal-random
make init
make plan
make apply
make output
make destroy
````

> Want Terraform commands instead? Append `TF=terraform` to each `make` command.

## Where to learn more

* See `COMPARISON.md` for a feature/ecosystem view
* See `MIGRATION.md` to switch projects from Terraform to OpenTofu
* See `install/` for platform‑specific setup

````

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
````

### 3) `MIGRATION.md`

````md
# Migrate from Terraform to OpenTofu

1. **Install OpenTofu** (see `install/`). Ensure `tofu -v` works.
2. **Keep your code** — your HCL files remain unchanged.
3. **State**
   - OpenTofu reads Terraform state and backends transparently.
   - No forced state rewrite needed.
4. **Lockfile**
   - Run `tofu init` to refresh `.terraform.lock.hcl` as needed.
5. **Workflows/CI**
   - Swap CLI binary calls: `terraform` → `tofu`.
   - For shared CI, parameterize the binary (see Makefile and workflow here).
6. **Provider Mirror (optional)**
   - Use `TF_PLUGIN_CACHE_DIR` to cache or mirror providers.
7. **Try it**
   ```sh
   cd examples/minimal-random
   tofu init && tofu plan && tofu apply
````

````

### 4) `.gitignore`
```gitignore
# IaC
.terraform/
.terraform.lock.hcl
terraform.tfstate
terraform.tfstate.backup
*.tfvars
*.tfvars.json
crash.log

# macOS & editors
.DS_Store
.idea/
.vscode/
````

### 5) `.editorconfig`

```ini
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

### 6) `Makefile`

```make
# Usage: make <target> [TF=tofu|terraform]
# Defaults to OpenTofu
TF ?= tofu

.PHONY: init plan apply destroy validate fmt output clean

init:
	$(TF) init -upgrade

plan:
	$(TF) plan -out=tfplan

apply:
	$(TF) apply -auto-approve tfplan || $(TF) apply -auto-approve

destroy:
	$(TF) destroy -auto-approve

validate:
	$(TF) validate

fmt:
	$(TF) fmt -recursive

output:
	$(TF) output -json || true

clean:
	rm -rf .terraform tfplan .terraform.lock.hcl
```

### 7) GitHub Actions: `.github/workflows/tofu-ci.yaml`

```yaml
name: IaC CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  validate-plan:
    runs-on: ubuntu-latest
    env:
      TF_IN_AUTOMATION: "1"
    steps:
      - uses: actions/checkout@v4

      - name: Install OpenTofu
        run: |
          sudo mkdir -p /usr/local/bin
          curl -L "https://get.opentofu.org/install-opentofu.sh" | sudo bash
          tofu -version

      - name: Validate & Plan (examples/minimal-random)
        working-directory: examples/minimal-random
        run: |
          tofu init -upgrade
          tofu fmt -recursive -check
          tofu validate
          tofu plan -no-color
```

---

## 🧪 Example 1 — `examples/minimal-random`

### `versions.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0"
    }
  }
}
```

### `main.tf`

```hcl
module "greet" {
  source = "../../modules/greeting"

  name_prefix = var.name_prefix
}

# Demonstrate null_resource provisioners running a harmless local-exec
resource "null_resource" "echo_demo" {
  triggers = {
    id = module.greet.id
  }

  provisioner "local-exec" {
    command = "echo Greeting ID: ${module.greet.id}"
  }
}
```

### `variables.tf`

```hcl
variable "name_prefix" {
  description = "Prefix for the greeting token"
  type        = string
  default     = "cloudnautic"
}
```

### `outputs.tf`

```hcl
output "greeting" {
  value = module.greet.message
}

output "token" {
  value       = module.greet.id
  description = "Deterministic token for demo purposes"
}
```

---

## 🧪 Example 2 — `examples/local-file`

### `versions.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0"
    }
  }
}
```

### `main.tf`

```hcl
resource "random_pet" "this" {
  length = 2
}

resource "local_file" "readme" {
  filename = "demo.txt"
  content  = "Hello from ${random_pet.this.id}!\n"
}

output "file_path" {
  value = local_file.readme.filename
}
```

### `variables.tf`

```hcl
# no vars required
```

### `outputs.tf`

```hcl
output "message" {
  value = "Wrote demo.txt next to your working directory"
}
```

---

## 🧩 Module — `modules/greeting`

### `main.tf`

```hcl
resource "random_id" "greet" {
  byte_length = 4
  keepers = {
    prefix = var.name_prefix
  }
}

output "message" {
  value = "Hello, ${var.name_prefix}!"
}

output "id" {
  value = random_id.greet.hex
}
```

### `variables.tf`

```hcl
variable "name_prefix" {
  type        = string
  description = "Prefix used for greeting and as a keeper for id"
}
```

### `outputs.tf`

```hcl
output "message" { value = "Hello, ${var.name_prefix}!" }
output "id" { value = random_id.greet.hex }
```

---

## 🛠️ Installation (OpenTofu)

Platform‑specific guides live under `install/`. Short form:

### macOS (Homebrew)

```bash
brew tap opentofu/core
brew install opentofu

tofu -version
```

### Linux (shell script)

```bash
curl -L "https://get.opentofu.org/install-opentofu.sh" | sudo bash

tofu -version
```

### Windows (winget or choco)

```powershell
winget install OpenTofu.OpenTofu
# or
choco install opentofu -y

tofu -version
```

> Optional version managers: `tfenv`, `asdf`, `tofuenv` (community). Pin versions in CI to avoid drift.

---

## 🧪 Run the demos

```bash
# Minimal random
cd examples/minimal-random
make init && make plan && make apply
make output
make destroy

# Local file demo
cd ../local-file
make init && make apply
cat demo.txt
make destroy
```

---

## 🔐 Provider caching (faster CI)

```bash
export TF_PLUGIN_CACHE_DIR="$HOME/.tf-plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"
```

---

## ✅ Linting & Security (optional tooling)

* **tflint**: `tflint --init && tflint`
* **tfsec**: `tfsec .`
* **infracost**: for cost diff (useful when you add cloud providers)

---

## 📘 `install/` detailed guides

### `install/INSTALL-macOS.md`

````md
# Install OpenTofu on macOS

## Homebrew (recommended)
```sh
brew tap opentofu/core
brew install opentofu
````

## asdf

```sh
asdf plugin add opentofu https://github.com/virtualroot/asdf-opentofu.git
asdf install opentofu latest
asdf global opentofu latest
```

## Verify

```sh
tofu -version
```

````

### `install/INSTALL-Linux.md`
```md
# Install OpenTofu on Linux

## One‑liner
```sh
curl -L "https://get.opentofu.org/install-opentofu.sh" | sudo bash
````

## Manual (deb/rpm)

* Download the package from releases, then `sudo dpkg -i` or `sudo rpm -i` accordingly.

## Verify

```sh
tofu -version
```

````

### `install/INSTALL-Windows.md`
```md
# Install OpenTofu on Windows

## winget
```powershell
winget install OpenTofu.OpenTofu
````

## Chocolatey

```powershell
choco install opentofu -y
```

## Verify

```powershell
tofu -version
```

```

---

## 🔄 Swap to a real cloud later

1. Add a provider block (AWS/Azure/GCP) in `versions.tf`.
2. Configure credentials via env vars or profiles.
3. Replace demo resources with real infrastructure.

> Keep the Makefile and CI — only your provider/resources change.

---

## 🧯 Troubleshooting

- **`Error acquiring the state lock`**: Run `tofu force-unlock <LOCK_ID>` (ensure no other run is active).
- **`Incompatible provider version`**: Update constraints in `versions.tf` and re‑run `init -upgrade`.
- **Windows path issues**: Use a short workdir path (avoid spaces), run PowerShell as Admin when needed.

---

## 📜 License
MIT

```
