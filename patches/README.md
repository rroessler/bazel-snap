# Patching Bazel Bootstrapping

To be able to patch Bazel, we need to coordinate two primary things:

1. Apply version specific patches
2. Modification of Bazel artifacts

As such, we structure out patches like the following:

```txt
patches/
  - <version>/
    - _apply.py
    - <first>.patch
    - <second>.patch
```

When we execute the bootstrapping script, the major version of Bazel is used to select the desired patches directory. From here all patches are copied to the `third_party` directory and an optional `_apply.py` script is run to more granular modification of Bazel artifacts.
