ALZ_LIB_TOOL_VERSION := "0.24.0"

.PHONY: server tools docs docs-check lib-check
server:
	@echo "Starting Hugo docs server..."
	cd docs && hugo server && cd ..

tools:
	@echo "==> installing required tooling..."
	curl -L https://github.com/Azure/alzlib/releases/download/$(ALZ_LIB_TOOL_VERSION)/alzlibtool_linux_amd64.tar.gz | tar -xvz


docs:
	@echo "==> building docs $(LIB)..."
	bash ./scripts/build-docs.sh $(LIB)

docs-check:
	@echo "==> checking docs $(LIB)..."
	bash ./scripts/check-docs.sh $(LIB)

lib-check:
	@echo "==> checking library $(LIB)..."
	bash ./scripts/check-lib.sh $(LIB)
