GIT_SHA = $(shell git rev-parse --short HEAD)

ifndef BUILD_TAG
  BUILD_TAG = git-$(GIT_SHA)
endif

NAME := app-server-errors
BUILD_IMAGE := build-$(NAME)
RELEASE_IMAGE := $(NAME):$(BUILD_TAG)
CODES := 402 403 404 410 412 423 500 502 503 504

all: test build

build:
	docker build -t $(BUILD_IMAGE) .
	docker cp `docker run -d $(BUILD_IMAGE)`:/go/bin/app-server-errors image/
	for CODE in $(CODES); do \
		sed -e "s/#CODE#/$$CODE/" image/Dockerfile.template > image/Dockerfile || exit 1; \
		docker build -t $(RELEASE_IMAGE)-$$CODE image || exit 1; \
	done

	rm -rf image/$(NAME)
	rm -rf image/Dockerfile

push:
	for CODE in $(CODES); do \
		docker tag -f $(RELEASE_IMAGE)-$$CODE $(DEV_REGISTRY)/$(RELEASE_IMAGE)-$$CODE || exit 1; \
		docker push $(DEV_REGISTRY)/$(RELEASE_IMAGE)-$$CODE || exit 1; \
	done

test:
	go test -v ./...

test-cover:
	go test -cover ./...
