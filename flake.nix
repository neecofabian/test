{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils/main";
    nixpkgs.url = "github:nixos/nixpkgs/master";
  };
  outputs = { flake-utils, nixpkgs, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};

      bazel-wrapper = pkgs.writeShellScriptBin "bazel" (if pkgs.hostPlatform.isMacOS then ''
        unset CC CXX
        exec ${pkgs.bazelisk}/bin/bazelisk "$@"
      '' else ''
        if [ "$1" == "configure" ]; then
          exec env --unset=USE_BAZEL_VERSION ${pkgs.bazelisk}/bin/bazelisk "$@"
        fi
        exec ${pkgs.bazel_6}/bin/bazel "$@"
      '');
      bazel-watcher = pkgs.writeShellScriptBin "ibazel" ''
        ${pkgs.lib.optionalString pkgs.hostPlatform.isMacOS "unset CC CXX"}
        exec ${pkgs.bazel-watcher}/bin/ibazel \
          ${pkgs.lib.optionalString pkgs.hostPlatform.isLinux "-bazel_path=${bazel-fhs}/bin/bazel"} "$@"
      '';
      bazel-fhs = pkgs.buildFHSEnv {
        name = "bazel";
        runScript = "bazel";
        targetPkgs = pkgs: (with pkgs; [
          bazel-wrapper
          zlib.dev
        ]);
        # unsharePid required to preserve bazel server between bazel invocations,
        # the rest are disabled just in case
        unsharePid = false;
        unshareUser = false;
        unshareIpc = false;
        unshareNet = false;
        unshareUts = false;
        unshareCgroup = false;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nil

          pkgs.postgresql_13

          pkgs.go_1_21
          pkgs.gopls

          pkgs.universal-ctags

          pkgs.git
          pkgs.parallel

          pkgs.shfmt
          pkgs.shellcheck

          pkgs.nodejs-18_x
          pkgs.nodejs-18_x.pkgs.pnpm
          pkgs.nodejs-18_x.pkgs.typescript

          pkgs.cargo
          pkgs.rustc
          pkgs.rustfmt
          pkgs.libiconv
          pkgs.clippy

          pkgs.pre-commit
        ] ++ pkgs.lib.optional pkgs.hostPlatform.isLinux (with pkgs; [
          # need to install bazelisk on your mac
          bazelisk
          bazel-fhs
          bazel-watcher
          bazel-buildtools
        ]);

        USE_BAZEL_VERSION =
          if pkgs.hostPlatform.isMacOS then "" else pkgs.bazel_6.version;
      };
    });
}
