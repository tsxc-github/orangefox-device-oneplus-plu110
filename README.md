# 一加 Turbo 6（PLU110）OrangeFox Recovery

非官方 OrangeFox Recovery（R12.0）设备树及预编译镜像，**仅适用于国行一加 Turbo 6**。

- **适用机型**：国行 OnePlus Turbo 6（`PLU110` / `OP60F0L1` / 项目号 `24816`）
- **不适用**：Turbo 6V、海外版 Nord 6（`CPH2793`）
- **分支说明**：默认分支 `fox_16.0-plu110` 为 OrangeFox R12.0；如需同期带 C.13 解密修复的 TWRP 16.0 设备树，见 [`twrp-16.0`](https://github.com/tsxc-github/orangefox-device-oneplus-plu110/tree/twrp-16.0) 分支。

## 实测状态

已在国行 `PLU110`、ColorOS 17 `PLU110_17.0.0.100(CN01)`（C.13）实机验证通过：

- 正常启动进入 OrangeFox，BOE 屏幕触摸正常
- 原锁屏 PIN 密码可正常解密 `/data`

> 其他固件版本、图案/混合密码等锁屏方式及 Android 多用户暂未实测。

## 下载镜像

前往 [Releases](https://github.com/tsxc-github/orangefox-device-oneplus-plu110/releases/tag/r12.0-plu110-c13-r2) 下载：

- **文件**：`OrangeFox-R12.0-Unofficial-plu110-c13-r2.img`（100 MiB）
- **SHA-256**：
  ```text
  9da77c9a349b7ce9b0166781ccfbd33c4c3d6da094383c53e5f967b277da1b67
  ```

独立 A/B `recovery` 分区镜像（v4 头，复用原机内核，未签名，仅限已解 BL）。

## 改动说明（R2）

早期的 R1 版本虽然能进界面，但在 ColorOS 17（C.13）上解不开用户数据，原因是设备树里多声明了原厂系统用不到的 StrongBox 和 Weaver 服务，把 Keystore2 的共享密钥协商卡死了。

R2 对齐了原厂 C.13 的安全服务配置，移除了多余的 StrongBox / Weaver 声明（保留默认 Gatekeeper、KeyMint、SharedSecret 和 eSE），并去掉了升级密钥写入 `/tmp` 的多余步骤，目前实机 PIN 解密正常。

另外，构建配置里关闭了自动生成卡刷 ZIP 和“重刷当前 OrangeFox”（`FOX_DISABLE_UPDATEZIP=1` / `OF_NO_REFLASH_CURRENT_ORANGEFOX=1`），避免未验证时自动覆写双槽。

## 自行编译

先按 [OrangeFox 官方文档](https://wiki.orangefox.tech/dev/environment) 配好构建环境，在非 root Linux 用户下执行（复制设备树时注意保留文件权限）。

`manifests/c13-r2.xml` 已锁定本次构建所用的全部上游提交（基于 OrangeFox manifest `64cf55fbad23f7b4677fc0b9ed6bc6e2e2cd8628`）：

```bash
mkdir -p ~/fox_16.0 && cd ~/fox_16.0
repo init --depth=1 -u https://github.com/tsxc-github/orangefox-device-oneplus-plu110.git -b refs/tags/r12.0-plu110-c13-r2 -m manifests/c13-r2.xml
repo sync -c -j4 --no-clone-bundle --no-tags

mkdir -p device/oneplus
git clone --depth=1 -b r12.0-plu110-c13-r2 https://github.com/tsxc-github/orangefox-device-oneplus-plu110.git device/oneplus/plu110

# 应用构建补丁
# 1) 打包修复（OrangeFox recovery e684b4be）：合并 terminfo 复制任务、修复 SELinux 标签复制分隔符
git -C bootable/recovery apply "$PWD/device/oneplus/plu110/patches/orangefox-recovery-packaging.patch"
# 2) 解密相关补丁（OrangeFox vold 953de960）
git -C system/vold apply "$PWD/device/oneplus/plu110/patches/vold-crypto-diagnostics.patch"
git -C system/vold apply "$PWD/device/oneplus/plu110/patches/vold-keep-upgrades-in-memory.patch"

export FOX_BUILD_DEVICE=plu110
source build/envsetup.sh
lunch twrp_plu110-bp2a-eng
mka recoveryimage
```

产物在 `out/target/product/plu110/` 下（`recovery.img` 或对应的 OrangeFox 命名镜像）。

**低内存机器编译提示**：如果 Soong 生成构建图时爆内存，可以给 `build/soong`（`6dc77879464584ef3f178cae622134ed0bf19e1e`）打上 `patches/soong-low-memory.patch`，并在 `mka` 前加上：

```bash
export GOMEMLIMIT=7GiB GOGC=60
```

该补丁只影响宿主机编译，不影响产物。

## 致谢与许可

- 基于 [kmiit/twrp_device_oplus_sm87xx @ 74d0756](https://github.com/kmiit/twrp_device_oplus_sm87xx/tree/74d075623b35f685fcde82efb5a43548697d1a6e)（沿用分区表、机型识别与触摸配置）和 [OrangeFox `fox_16.0`](https://gitlab.com/OrangeFox/Manifest/-/tree/fox_16.0)
- 感谢 kmiit 及各位设备树贡献者
- 感谢 [neomody77 贡献的 Turbo 6 BOE 触摸修复](https://github.com/kmiit/twrp_device_oplus_sm87xx/pull/22)
- 感谢 OrangeFox、TeamWin 和 AOSP 项目

代码沿用各文件原有的开源许可与版权声明；随上游设备树带入的厂商预编译二进制文件不按开源许可重新授权。
