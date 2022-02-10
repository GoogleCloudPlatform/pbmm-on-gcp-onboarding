# Overview
Terratests for name generator.

All tests are found in [gc_name_tests.go]("gc_name_tests.go") file.

Add/Edit map values in [gc_name_tests.go]("gc_name_tests.go") to create/edit tests.

To run specific tests, set environment variable `TERRATESTS_TESTNAMES_LIST` to a comma separated
list of the key values from the [gc_name_tests.go]("gc_name_tests.go") file.

Example:
```bash
export TERRATESTS_TESTNAMES_LIST="sql_server,sql_database"
```

Leave environment variable empty/unset to run all tests.

# Limitations

# Known Issues

# Usage
```bash
go mod init name_test
go test -v -timeout 30m -parallel 16
```
