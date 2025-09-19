# Migrate from Terraform to OpenTofu
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
