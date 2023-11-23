# file mostly taken from crane...

# A shell wrapper which logs any `roc` invocation
roc() {
  # Run in a subshell to avoid polluting the environment
  (
    set -x
    command roc "$@"
  )
}

# TODO: add helper for setting RUST_BACKTRACE