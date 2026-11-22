# 一加 Turbo 6（PLU110）TWRP 16.0 设备树

本分支为 **TWRP 16.0** 设备树，Fork 自 [kmiit/twrp_device_oplus_sm87xx](https://github.com/kmiit/twrp_device_oplus_sm87xx) 并针对国行一加 Turbo 6 做了 ColorOS 17（C.13）解密适配。

- **适用机型**：国行 OnePlus Turbo 6（`PLU110` / `OP60F0L1` / 项目号 `24816`）
- **不适用**：Turbo 6V、海外版 Nord 6（`CPH2793`）
- **OrangeFox 预编译版**：见默认分支 [`fox_16.0-plu110`](https://github.com/tsxc-github/orangefox-device-oneplus-plu110/tree/fox_16.0-plu110) 与 [Releases](https://github.com/tsxc-github/orangefox-device-oneplus-plu110/releases)

## 相对上游的改动（解密修复）

原版上游通用树保留了 StrongBox / Weaver 的 init 与 VINTF 声明，在国行 Turbo 6 ColorOS 17（C.13）上会导致 Keystore2 共享密钥协商卡死、无法解密 `/data`。本分支同步了 OrangeFox R2 已实机验证通过的修复：

- 移除原厂 C.13 未声明的 7 个 StrongBox / Weaver `.rc` 与 VINTF `.xml` 文件，保留默认 Gatekeeper、KeyMint、SharedSecret 和 eSE
- `init.recovery.qcom.rc`：直接启用 `vendor.secure_element`，移除会触发密钥回收的 `setprop sys.boot_completed 1`
- 适配单机型目标 `twrp_plu110`（`device/oneplus/plu110`）并更新 GitHub Actions 默认构建参数

> 注：该解密方案已在 OrangeFox R2（`PLU110_17.0.0.100(CN01)` / C.13）实机验证通过；本分支编译出的 TWRP 镜像尚未单独实机测试，欢迎自行编译或通过 Actions 构建验证。

## 编译

支持直接使用仓库内自带的 GitHub Actions（`TWRP 16 Builder` 手动触发），或本地编译：

```bash
mkdir -p ~/twrp_16.0 && cd ~/twrp_16.0
repo init --depth=1 -u https://github.com/TWRP-Test/platform_manifest_twrp_aosp.git -b twrp-16.0
repo sync -c -j4 --no-clone-bundle --no-tags

mkdir -p device/oneplus
git clone --depth=1 -b twrp-16.0 https://github.com/tsxc-github/orangefox-device-oneplus-plu110.git device/oneplus/plu110

source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_plu110-bp2a-eng
mka recoveryimage
```

产物位于 `out/target/product/plu110/recovery.img`（独立 A/B `recovery` 分区镜像，复用原机内核，未签名需解 BL）。

## 致谢与许可

- 上游基线：[kmiit/twrp_device_oplus_sm87xx @ 74d0756](https://github.com/kmiit/twrp_device_oplus_sm87xx/tree/74d075623b35f685fcde82efb5a43548697d1a6e)
- Turbo 6 BOE 触摸修复：[neomody77](https://github.com/kmiit/twrp_device_oplus_sm87xx/pull/22)
- TeamWin、AOSP 项目

代码沿用各文件原有的开源许可与版权声明；随上游设备树带入的厂商预编译二进制文件不按开源许可重新授权。
