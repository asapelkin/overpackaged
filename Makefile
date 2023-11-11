.PHONY: nuitka pex appimage pyoxidizer benchmark portability-test clean all

DIST_DIR := $(CURDIR)/dist
SOURCE_DIR := $(CURDIR)
WHEEL_DIR := $(CURDIR)/wheelhouse
BUILD_DIR := $(CURDIR)/.build
CACHE_DIR := $(CURDIR)/.cache
DOCKER_IMAGE := myapp-manylinux-build-env
MANYLINUX_PYTHON=/opt/python/cp38-cp38/bin/python
MANYLINUX_PIP=/opt/python/cp38-cp38/bin/pip
PYTHON_INSTALL_PREFIX=/opt/python-build-standalone
PYTHON_HOME=$(PYTHON_INSTALL_PREFIX)/python/install/
PYTHON=$(PYTHON_HOME)/bin/python3
PIP=$(PYTHON_HOME)/bin/pip


DOCKER_BUILD_INDICATOR := $(BUILD_DIR)/.docker-build
WHEELHOUSE_INDICATOR := $(WHEEL_DIR)/.wheelhouse
VERIFY_WHEELS_INDICATOR := $(BUILD_DIR)/.verify-wheels
ALLOWED_WHL_TAGS := any manylinux_2_24_x86_64
BENCHMARK_ENABLED_STARTUP := "$(DIST_DIR)/myapp_nuitka_onefile --help" "$(DIST_DIR)/myapp_nuitka_as_folder/myapp --help" "$(DIST_DIR)/pyoxidizer/myapp --help" "$(DIST_DIR)/myapp.AppImage --help"
BENCHMARK_ENABLED_FULL_RUN := "$(DIST_DIR)/myapp_nuitka_onefile run" "$(DIST_DIR)/myapp_nuitka_as_folder/myapp run" "$(DIST_DIR)/pyoxidizer/myapp run" "$(DIST_DIR)/myapp.AppImage run"

export DIST_DIR
export SOURCE_DIR
export WHEEL_DIR
export CACHE_DIR
export MANYLINUX_PYTHON
export MANYLINUX_PIP
export PYTHON_INSTALL_PREFIX
export PYTHON_HOME
export PYTHON
export PIP


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
	$(SOURCE_DIR)/docker/docker-run.sh $(SOURCE_DIR)/packaging/pyoxidizer/build.sh


benchmark:
	echo "Benchmarking startup time..."
	hyperfine --warmup 5  $(BENCHMARK_ENABLED_STARTUP)
	echo "Benchmarking full working time..."
	hyperfine --warmup 5  $(BENCHMARK_ENABLED_FULL_RUN)


portability-test:
	test/portability-test.sh


clean:
	rm -f $(DOCKER_BUILD_INDICATOR) $(WHEELHOUSE_INDICATOR) $(VERIFY_WHEELS_INDICATOR)
	rm -rf $(BUILD_DIR)/* $(DIST_DIR)/* $(WHEEL_DIR)/*
