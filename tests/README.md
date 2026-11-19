# Testing Snap Integration

To start testing the snap, firstly pack the version of Bazel you want to test:

```shell
# Modify the version of "snap/snapcraft.yaml" (optional, or manually edit)
yq -i '.version = "7.7.2"' snap/snapcraft.yaml

# Actually pack a version of the Bazel snap (optionally specify arch)
snapcraft clean bazel
snapcraft pack --platform amd64
```

After this, we can then use the [`spread`](https://github.com/canonical/spread) command to run integration tests:

```shell
spread          # Baseline command runs all tests
spread -debug   # Entire a debug session on failures
spread -vv      # Enables verbose outputs from "spread"
```

## Installing Dependencies

- [`yq`](https://github.com/mikefarah/yq) &mdash; Installable as Snap or APT package
- [`spread`](https://github.com/canonical/spread) &mdash; Best to install using Golang
