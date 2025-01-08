.PHONY: server tools docs
server:
	@echo "Starting Hugo docs server..."
	cd docs && hugo server && cd ..

tools:
	@echo "==> installing required tooling..."
	curl -L https://github.com/Azure/alzlib/releases/download/v0.24.0/alzlibtool_linux_amd64.tar.gz | tar -xvz


docs:
	@echo "==> building docs..."
	bash ./scripts/build-docs.sh

docs-check:
	@echo "==> checking docs..."
	bash ./scripts/check-docs.sh

lib-check:
	@echo "==> checking library..."
	bash ./scripts/check-lib.sh
