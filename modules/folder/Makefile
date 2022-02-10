.PHONY: test init

init:
ifeq (,$(wildcard ./go.mod))
	go mod init $(shell basename $(CURDIR))
endif

test: init
	go test -v -count 1 -short -timeout "60m" -parallel 16 `go list ./...`

clean:
	@find . -type d -name .terraform -exec rm -rf {} \;

fmt:
	@terragrunt hclfmt
	@terraform fmt -recursive