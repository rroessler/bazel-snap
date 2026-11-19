p = "MODULE.bazel"
s = open(p).read()
old = 'single_version_override(\n    module_name = "rules_jvm_external",'
new = (
    'single_version_override(\n    module_name = "rules_java",\n'
    '    patch_strip = 1,\n'
    '    patches = ["//third_party:rules_java_riscv64_jni.patch"],\n)\n\n'
    'single_version_override(\n    module_name = "abseil-cpp",\n'
    '    patch_strip = 1,\n'
    '    patches = ["//third_party:abseil_riscv64_cycleclock.patch"],\n)\n\n')
assert s.count(old) == 1
open(p, "w").write(s.replace(old, new + old, 1))
p = "BUILD"
s = open(p).read()
old = '        "//third_party:rules_jvm_external_6.0.patch",\n'
assert s.count(old) == 1
new = (old + '        "//third_party:rules_java_riscv64_jni.patch",\n'
       '        "//third_party:abseil_riscv64_cycleclock.patch",\n')
open(p, "w").write(s.replace(old, new, 1))
