all: build.bazel tidy
.PHONY: all

build.backend:
	bazel build \
			--platforms @zig_sdk//platform:linux_arm64 \
			--extra_toolchains @zig_sdk//toolchain:linux_arm64_musl \
			//cmd/backend
.PHONY: build.bazel

tidy:
	go mod tidy
	bazel run //:gazelle-update-repos
.PHONY: tidy

format:
	bazel run @aspect_rules_format//format
.PHONY: format
