TAG := $(shell git tag -l --contains HEAD)
DIR := $(shell pwd)

# Define image names
APP      := archer_api_upload
REGISTRY := seglh

# Build tags
IMG           := $(REGISTRY)/$(APP)
IMG_VERSIONED := $(IMG):$(TAG)

.PHONY: push build version cleanbuild

push: build
	docker push $(IMG_VERSIONED)

build: version
	docker buildx build --platform linux/amd64 -t $(IMG_VERSIONED) . || docker build -t $(IMG_VERSIONED) .
	docker tag $(IMG_VERSIONED) $(IMG_VERSIONED) 
	docker save $(IMG_VERSIONED) | gzip > $(DIR)/$(REGISTRY)-$(APP).tar.gz

cleanbuild:
	docker buildx build --platform linux/amd64 --no-cache -t $(IMG_VERSIONED) .