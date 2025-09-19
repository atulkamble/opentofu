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
