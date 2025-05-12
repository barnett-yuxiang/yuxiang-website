# Website deployment Makefile
# Usage:
#   make package - Create a deployment package with version from git tag
#   make clean - Remove all build artifacts

# Configuration
PACKAGE_NAME := yuxiang-website
BUILD_DIR := build
DIST_DIR := dist
CURRENT_DATE := $(shell date +%Y%m%d%H%M%S)

# Get version from git tag, default to 0.0.0 if not found
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")
PACKAGE_FILENAME := $(PACKAGE_NAME)-$(VERSION)-$(CURRENT_DATE).tar.gz

# Files to include
INCLUDE_FILES := index.html LICENSE README.md assets

# Files to exclude from assets directory
EXCLUDE_FILES := .DS_Store .git .gitignore .qodo

.PHONY: all clean package prepare

all: package

# Prepare build directory
prepare:
	@echo "Preparing build directory..."
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(DIST_DIR)
	@echo "Copying files to build directory..."
	@cp -r $(INCLUDE_FILES) $(BUILD_DIR)/
	@echo "Removing excluded files..."
	@find $(BUILD_DIR) -name ".DS_Store" -type f -delete
	@find $(BUILD_DIR) -path "*.git*" -delete
	@find $(BUILD_DIR) -path "*.qodo*" -delete
	@echo "Version: $(VERSION)"

# Create deployment package
package: prepare
	@echo "Creating package $(PACKAGE_FILENAME)..."
	@tar -czf $(DIST_DIR)/$(PACKAGE_FILENAME) -C $(BUILD_DIR) .
	@echo "Package created: $(DIST_DIR)/$(PACKAGE_FILENAME)"
	@echo "Creating latest symlink..."
	@ln -sf $(PACKAGE_FILENAME) $(DIST_DIR)/$(PACKAGE_NAME)-latest.tar.gz
	@echo "Done!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Done!"

# Show version
version:
	@echo "Current version: $(VERSION)"