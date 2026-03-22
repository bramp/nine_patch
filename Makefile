.PHONY: all format analyze test test-ci fix clean upgrade pub-outdated

## Run all checks (format, analyze, test)
all: format analyze test

## Format all Dart code
format:
	dart format .

## Run the analyzer across all packages
analyze:
	dart analyze

## Run all tests
test:
	cd nine_patch_common && dart test
	cd nine_patcher && dart test
	cd nine_patch && flutter test

## Run all tests for CI
test-ci: test
test-app-ci: test

## Apply auto-fixes
fix:
	dart fix --apply

## Check for outdated dependencies in all directories
pub-outdated:
	dart pub outdated
	cd nine_patch && flutter pub outdated
	cd nine_patch_common && dart pub outdated
	cd nine_patcher && dart pub outdated

## Upgrade dependencies
upgrade: pub-outdated
	dart pub upgrade --major-versions --tighten

## Delete build artifacts
clean:
	find . -name ".dart_tool" -type d -exec rm -rf {} +
