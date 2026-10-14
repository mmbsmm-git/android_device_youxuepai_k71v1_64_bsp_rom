# sepolicy/reference/

从**同 SoC**（MTK6771）的参考设备树
`ADeadTrousers/android_device_Unihertz_Atom_LXL @ lineage-20.0` 取来的 MTK 相关 sepolicy 条目，
**仅作参考，未启用**（`BoardConfig.mk` 只引用 `sepolicy/{private,public,vendor}`，本目录不会被编译）。

| 文件 | 内容 |
|---|---|
| `atom-file_contexts.txt` | MTK 系统路径/类型（`aal`、`aee_*`、`emdlogger*`、`mobile_log_d`…）|
| `atom-property_contexts.txt` | MTK 属性（`ctl.*`、`init.svc.*`、`persist.vendor.*`…）|

> ⚠️ 这些条目引用的类型（如 `aal_exec`）**必须有对应 `.te` 定义**才可用
> （通常来自 MTK 的 common sepolicy，或原厂 vendor sepolicy）。
> **直接启用而缺定义会编译报错**（unknown type）。

## M1 用法

1. 先让系统以 **permissive** 起来（`dmesg | grep avc` / `logcat` 抓 denials）。
2. 按需把本目录里的条目搬进 `sepolicy/private/`，并**同时补上对应类型定义**。
3. 稳定后再转 **enforcing**。
