# SPDX-FileCopyrightText: (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

SUB_FOLDERS := docker controller/docker autocalibration/docker percebro/docker
EXTRA_BUILD_FLAGS :=
TARGET_BRANCH ?= $(if $(CHANGE_TARGET),$(CHANGE_TARGET),$(BRANCH_NAME))

ifneq (,$(filter DAILY TAG,$(BUILD_TYPE)))
  EXTRA_BUILD_FLAGS := rebuild
endif

ifneq (,$(filter rc beta-rc,$(TARGET_BRANCH)))
  EXTRA_BUILD_FLAGS := rebuild
endif

.PHONY: build
build: check-tag build-certificates build-docker

.PHONY: check-tag
check-tag:
ifeq ($(BUILD_TYPE),TAG)
	@echo "Checking if tag matches version.txt..."
	@TAG_NAME=$$(echo $(BRANCH_NAME) | sed 's|refs/tags/||'); \
	if grep --quiet "$$TAG_NAME" version.txt; then \
		echo "Perfect - Tag and Version is matching"; \
	else \
		echo "There is some mismatch between Tag and Version"; \
		exit 1; \
	fi
endif

.PHONY: build-certificates
build-certificates:
	make -C certificates CERTPASS=$$(openssl rand -base64 12)

.PHONY: build-docker
build-docker:
	for dir in $(SUB_FOLDERS); do \
		$(MAKE) http_proxy=$(http_proxy) -C $$dir $(EXTRA_BUILD_FLAGS); \
	done
