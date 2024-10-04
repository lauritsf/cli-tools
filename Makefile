# Makefile for cli-tools

all: test install

test:
	@echo "Running tests..."
	@./tests/test_scount.sh
	@echo "Tests complete."

install:
	@echo "Installing scripts..."
	@mkdir -p $(HOME)/bin
	@if [ -f "$(HOME)/bin/scount" ]; then \
		echo "scount already exists in $(HOME)/bin. Skipping installation."; \
	else \
		cp scripts/scount.sh $(HOME)/bin/scount; \
		chmod +x $(HOME)/bin/scount; \
		echo "scount installed to $(HOME)/bin."; \
	fi
	@echo "Make sure to add $(HOME)/bin to your PATH if it's not already there."

uninstall:
	@echo "Uninstalling scripts..."
	@rm -f $(HOME)/bin/scount
	@echo "scount uninstalled from $(HOME)/bin."

help:
	@echo "Available commands:"
	@echo "  make all        Run tests and install scripts"
	@echo "  make test       Run the tests"
	@echo "  make install    Install the scripts"
	@echo "  make uninstall  Uninstall the scripts"
	@echo "  make help       Display this help message"

.PHONY: all test install uninstall help
