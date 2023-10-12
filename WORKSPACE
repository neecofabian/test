workspace(name = "tisl_articulate")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_features",
    sha256 = "9fcb3d7cbe908772462aaa52f02b857a225910d30daa3c252f670e3af6d8036d",
    strip_prefix = "bazel_features-1.0.0",
    url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.0.0/bazel_features-v1.0.0.tar.gz",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

commit = "effff479b3ef228c1b998670c73193741b61024d"

http_archive(
    name = "io_tweag_rules_nixpkgs",
    strip_prefix = "rules_nixpkgs-{commit}".format(commit = commit),
    urls = ["https://github.com/tweag/rules_nixpkgs/archive/{commit}.tar.gz".format(commit = commit)],
)

load("@io_tweag_rules_nixpkgs//nixpkgs:repositories.bzl", "rules_nixpkgs_dependencies")

rules_nixpkgs_dependencies()

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_cc_configure", "nixpkgs_git_repository", "nixpkgs_package")
load("@io_tweag_rules_nixpkgs//nixpkgs:toolchains/go.bzl", "nixpkgs_go_configure")  # optional
load("@bazel_features//:deps.bzl", "bazel_features_deps")

bazel_features_deps()

http_archive(
    name = "aspect_rules_format",
    sha256 = "c8d04f68082c0eeac2777e15f65048ece2f17d632023bdcc511602f8c5faf177",
    strip_prefix = "bazel-super-formatter-2.0.0",
    url = "https://github.com/aspect-build/bazel-super-formatter/archive/refs/tags/v2.0.0.tar.gz",
)

load("@aspect_rules_format//format:repositories.bzl", "rules_format_dependencies")

rules_format_dependencies()

load("@rules_nodejs//nodejs:repositories.bzl", "DEFAULT_NODE_VERSION", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "node",
    node_version = DEFAULT_NODE_VERSION,
)

load("@aspect_rules_format//format:dependencies.bzl", "parse_dependencies")

parse_dependencies()

http_archive(
    name = "hermetic_cc_toolchain",
    sha256 = "973ab22945b921ef45b8e1d6ce01ca7ce1b8a462167449a36e297438c4ec2755",
    strip_prefix = "hermetic_cc_toolchain-5098046bccc15d2962f3cc8e7e53d6a2a26072dc",
    urls = [
        "https://github.com/uber/hermetic_cc_toolchain/archive/5098046bccc15d2962f3cc8e7e53d6a2a26072dc.tar.gz",  # 2023-06-28
    ],
)

load("@hermetic_cc_toolchain//toolchain:defs.bzl", zig_toolchains = "toolchains")

zig_toolchains()

# Register zig sdk toolchains with support for Ubuntu 20.04 (Focal Fossa) which has an EOL date of April, 2025.
# For ubuntu glibc support, see https://launchpad.net/ubuntu/+source/glibc
register_toolchains(
    "@zig_sdk//toolchain:linux_amd64_gnu.2.31",
    "@zig_sdk//toolchain:linux_arm64_gnu.2.31",
    # Hermetic cc toolchain is not yet supported on darwin. Sysroot needs to be provided.
    # See https://github.com/uber/hermetic_cc_toolchain#osx-sysroot
    #    "@zig_sdk//toolchain:darwin_amd64",
    #    "@zig_sdk//toolchain:darwin_arm64",
    # Windows builds are not supported yet.
    #    "@zig_sdk//toolchain:windows_amd64",
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

gazelle_dependencies(go_sdk = "go_sdk")

load(
    "@tisl_articulate//bazel:repositories.bzl",
    "articulate_go_repositories",
)

articulate_go_repositories()

load(
    "@tisl_articulate//bazel:deps.bzl",
    "articulate_go_dependencies",
)

articulate_go_dependencies()

# This should stay at the end of the WORKSPACE
load("@aspect_rules_format//format:toolchains.bzl", "format_register_toolchains")

format_register_toolchains()

#gazelle:repository_macro bazel/deps.bzl%articulate_go_dependencies
