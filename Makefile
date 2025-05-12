# yuxiang-website deployment Makefile
# Usage:
#   make package - Create a deployment package with current date
#   make clean - Remove all build artifacts

# Configuration
PACKAGE_NAME := yuxiang-website
BUILD_DIR := build
DIST_DIR := dist
CURRENT_DATE := $(shell date +%Y%m%d%H%M%S)
PACKAGE_FILENAME := $(PACKAGE_NAME)-$(CURRENT_DATE).zip

# Files to include
INCLUDE_FILES := index.html assets

.PHONY: all clean package prepare

all: package

# Prepare build directory
prepare:
	@echo "Preparing build directory..."
	@mkdir -p $(BUILD_DIR)/$(PACKAGE_NAME)
	@mkdir -p $(DIST_DIR)
	@echo "Copying files to build directory..."
	@cp -r $(INCLUDE_FILES) $(BUILD_DIR)/$(PACKAGE_NAME)/

# Create deployment package
package: prepare
	@echo "Creating package $(PACKAGE_FILENAME)..."
	@cd $(BUILD_DIR) && zip -r ../$(DIST_DIR)/$(PACKAGE_FILENAME) $(PACKAGE_NAME)
	@echo "Package created: $(DIST_DIR)/$(PACKAGE_FILENAME)"
	@echo "Done!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(DIST_DIR)
	@echo "Done!"