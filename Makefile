.PHONY: nuitka pex appimage pyoxidizer benchmark portability-test clean all

DIST_DIR := $(CURDIR)/dist
SOURCE_DIR := $(CURDIR)
WHEEL_DIR := $(CURDIR)/wheelhouse
BUILD_DIR := $(CURDIR)/.build
CACHE_DIR := $(CURDIR)/.cache
DOCKER_IMAGE := myapp-manylinux-build-env

DOCKER_BUILD_INDICATOR := $(BUILD_DIR)/.docker-build
WHEELHOUSE_INDICATOR := $(WHEEL_DIR)/.wheelhouse
VERIFY_WHEELS_INDICATOR := $(BUILD_DIR)/.verify-wheels
ALLOWED_WHL_TAGS := any manylinux_2_24_x86_64
BENCHMARK_ENABLED := $(DIST_DIR)/myapp_nuitka_onefile $(DIST_DIR)/myapp_nuitka_as_folder/myapp $(DIST_DIR)/pyoxidizer/myapp

export DIST_DIR
export SOURCE_DIR
export WHEEL_DIR
export CACHE_DIR


$(DOCKER_BUILD_INDICATOR):
	mkdir -p $(BUILD_DIR)
	$(SOURCE_DIR)/docker/build.sh
	touch $@

docker-images: $(DOCKER_BUILD_INDICATOR)

$(WHEELHOUSE_INDICATOR): $(DOCKER_BUILD_INDICATOR)
	BUILD_DIR=$(BUILD_DIR)/$@ \
	$(SOURCE_DIR)/docker/docker-run.sh ${SOURCE_DIR}/docker/build-wheels.sh
	touch $@

$(VERIFY_WHEELS_INDICATOR): $(WHEELHOUSE_INDICATOR)
	$(SOURCE_DIR)/packaging/tools/verify-wheels.py $(WHEEL_DIR) $(ALLOWED_WHL_TAGS)
	touch $@

nuitka: $(VERIFY_WHEELS_INDICATOR)
	BUILD_DIR=$(BUILD_DIR)/$@ \
	$(SOURCE_DIR)/docker/docker-run.sh ${SOURCE_DIR}/packaging/nuitka/build.sh

pex: $(VERIFY_WHEELS_INDICATOR)
	BUILD_DIR=$(BUILD_DIR)/$@ \
	$(SOURCE_DIR)/docker/docker-run.sh $(SOURCE_DIR)/packaging/pex/build.sh

appimage: $(VERIFY_WHEELS_INDICATOR)
	BUILD_DIR=$(BUILD_DIR)/$@ \
	$(SOURCE_DIR)/docker/docker-run.sh $(SOURCE_DIR)/packaging/appimage/build.sh

pyoxidizer: $(VERIFY_WHEELS_INDICATOR)
	BUILD_DIR=$(BUILD_DIR)/$@ \
	$(SOURCE_DIR)/packaging/pyoxidizer/docker-run.sh

benchmark:
	hyperfine --warmup 5  $(BENCHMARK_ENABLED)

portability-test:
	test/portability-test.sh

all: pyoxidizer nuitka pex appimage

clean:
	rm -f $(DOCKER_BUILD_INDICATOR) $(WHEELHOUSE_INDICATOR) $(VERIFY_WHEELS_INDICATOR)
	rm -rf $(BUILD_DIR)/*
