load(
    "@io_bazel_rules_go//go:deps.bzl",
    "go_register_toolchains",
    "go_rules_dependencies",
)
load(
    "@bazel_gazelle//:deps.bzl",
    "gazelle_dependencies",
    "go_repository",
)

def articulate_go_dependencies(go_sdk_version = "host"):
    go_rules_dependencies()
    go_register_toolchains(version = go_sdk_version)
    gazelle_dependencies()

    go_repository(
        name = "com_github_go_chi_chi_v5",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/go-chi/chi/v5",
        sum = "h1:rLz5avzKpjqxrYwXNfmjkrYYXOyLJd37pz53UFHC6vk=",
        version = "v5.0.10",
    )
