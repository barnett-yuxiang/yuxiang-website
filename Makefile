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
INCLUDE_FILES := index.html assets README.md LICENSE

.PHONY: all clean package prepare

all: package

# Prepare build directory
prepare:
	@echo "Preparing build directory..."
	@mkdir -p $(BUILD_DIR)/$(PACKAGE_NAME)
	@mkdir -p $(DIST_DIR)
	@echo "Copying files to build directory..."
	@for file in $(INCLUDE_FILES); do \
		if [ -f "$$file" ]; then \
			cp "$$file" $(BUILD_DIR)/$(PACKAGE_NAME)/; \
		elif [ -d "$$file" ]; then \
			cp -r "$$file" $(BUILD_DIR)/$(PACKAGE_NAME)/; \
		fi; \
	done
	@echo "Removing unwanted files..."
	@find $(BUILD_DIR)/$(PACKAGE_NAME) -name ".DS_Store" -type f -delete 2>/dev/null || true
	@find $(BUILD_DIR)/$(PACKAGE_NAME) -name "*.swp" -type f -delete 2>/dev/null || true
	@find $(BUILD_DIR)/$(PACKAGE_NAME) -name "*.tmp" -type f -delete 2>/dev/null || true

# Create deployment package
package: prepare
	@echo "Creating package $(PACKAGE_FILENAME)..."
	@cd $(BUILD_DIR) && zip -r ../$(DIST_DIR)/$(PACKAGE_FILENAME) $(PACKAGE_NAME)
	@echo "Package created: $(DIST_DIR)/$(PACKAGE_FILENAME)"
	@echo "Package size: $$(du -h $(DIST_DIR)/$(PACKAGE_FILENAME) | cut -f1)"
	@echo "Done!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(DIST_DIR)
	@echo "Done!"