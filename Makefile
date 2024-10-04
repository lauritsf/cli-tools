# Makefile for cli-tools

SCRIPTS = scount countfiles
INSTALL_DIR = $(HOME)/bin

all: test install

test:
	@echo "Running tests..."
	@for script in $(SCRIPTS); do \
        tests/test_$$script.sh; \
    done
	@echo "Tests complete."

install:
	@echo "Installing scripts..."
	@mkdir -p $(INSTALL_DIR)
	@for script in $(SCRIPTS); do \
        if [ -f "$(INSTALL_DIR)/$$script" ]; then \
            echo "$$script already exists in $(INSTALL_DIR). Skipping installation."; \
        else \
            cp scripts/$$script.sh $(INSTALL_DIR)/$$script; \
            chmod +x $(INSTALL_DIR)/$$script; \
            echo "$$script installed to $(INSTALL_DIR)."; \
        fi; \
    done
	@echo "Make sure to add $(INSTALL_DIR) to your PATH if it's not already there."

uninstall:
	@echo "Uninstalling scripts..."
	@for script in $(SCRIPTS); do \
        rm -f $(INSTALL_DIR)/$$script; \
        echo "$$script uninstalled from $(INSTALL_DIR)."; \
    done

help:
	@echo "Available commands:"
	@echo "  make all        Run tests and install scripts"
	@echo "  make test       Run the tests"
	@echo "  make install    Install the scripts"
	@echo "  make uninstall  Uninstall the scripts"
	@echo "  make help       Display this help message"

.PHONY: all test install uninstall help
