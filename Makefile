.PHONY: build

FRAMEWORK = CocoaLumberjack
PROJECT = Lumberjack.xcodeproj
SCHEME = "CocoaLumberjack"

build:
	rm -rf build/$(target) &> /dev/null;
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -sdk $(target) \
	-configuration Release ONLY_ACTIVE_ARCH=NO CONFIGURATION_BUILD_DIR=build/$(target) MACH_O_TYPE=staticlib | xcpretty

build_simulator:
	@make build target=iphonesimulator

build_device:
	@make build target=iphoneos

link_universal:
	rm -rf build/Products &> /dev/null; mkdir build/Products
	cp -r build/iphoneos/"$(FRAMEWORK)".framework build/Products/.
	lipo \
	-create build/iphoneos/"$(FRAMEWORK)".framework/"$(FRAMEWORK)" build/iphonesimulator/"$(FRAMEWORK)".framework/"$(FRAMEWORK)" \
	-output build/Products/"$(FRAMEWORK)".framework/"$(FRAMEWORK)"

release:
	@make build_simulator
	@make build_device
	@make link_universal