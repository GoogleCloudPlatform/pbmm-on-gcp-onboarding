.ONESHELL:
.PHONY: test init

SHELL=/bin/bash

init:
ifeq (,$(wildcard ./go.mod))
	go mod init $(shell basename $(CURDIR))
endif

test: init
	go test -v -count 1 -short -timeout "60m" -parallel 16 `go list ./...`

clean:
	@find . -name terraform.tfstate -type f -exec rm -rf {} +
	@find . -name terraform.tfstate.backup -type f -exec rm -rf {} +
	@find . -name .terraform -type d -exec rm -rf {} +
