# zmk firmwareの作成方法について
## フォルダ構成
```:フォルダ構成
📁my_zmk_firmware
 ├─ 📄build.yaml
 ├─ 📄README.md
 ├─ 📁.github ─ 📁workflows ─ 📄build.yml
 └─ 📁config
     ├─ 📄west.yml
     └─ 📁boards ─ 📁shields
                    ├─ 📁settings_reset
                    └─ 📁asym_ble
                        ├─ 📄Kconfig.defconfig
                        ├─ 📄Kconfig.shield
                        ├─ 📄asym_ble.conf
                        ├─ 📄asym_ble.dtsi
                        ├─ 📄asym_ble.keymap
                        ├─ 📄asym_ble.zmk.yml
                        ├─ 📄asym_ble_left.overlay
                        └─ 📄asym_ble_right.overlay
```
## ファイルについて

### 📄build.yaml
マイコンボード・シールドの設定？
```yaml:build.yaml
board: [seeeduino_xiao_ble]
shield: [asym_ble_left, asym_ble_right]
```
こっちの表記方法でもOK

```yaml:build.yaml
include:
  - board: seeeduino_xiao_ble
    shield: asym_ble_left
  - board: seeeduino_xiao_ble
    shield: asym_ble_right
  - board: seeeduino_xiao_ble
    shield: settings_reset
```

### 📄README.md
この文章
### 📄build.yml
<details>

<summary>クリックして内容表示</summary>
	
```yml:build.yml
on: [push, pull_request, workflow_dispatch]

jobs:
  build:
    uses: zmkfirmware/zmk/.github/workflows/build-user-config.yml@main
```
</details>

### 📄west.yml
<details>

<summary>クリックして内容表示</summary>

```yml
manifest:
  remotes:
    - name: zmkfirmware
      url-base: https://github.com/zmkfirmware
  projects:
    - name: zmk
      remote: zmkfirmware
      revision: main
      import: app/west.yml
  self:
    path: config
```
</details>

### 📄Kconfig.defconfig
各シールドの役割付け・デバイス表示名定義
```kconfig
if SHIELD_LEFT
config ZMK_KEYBOARD_NAME
	default "asym_ble"

config ZMK_SPLIT_ROLE_CENTRAL
	default y

endif
if SHIELD_LEFT || SHIELD_RIGHT

config ZMK_SPLIT
	default y

endif
```
### 📄Kconfig.shield
シールド設定の定義
```dts
config SHIELD_LEFT
	def_bool $(shields_list_contains,asym_ble_left)

config SHIELD_RIGHT
	def_bool $(shields_list_contains,asym_ble_right)
```
### 📄asym_ble.conf
機能設定 キー入力だけなら入力不要or全コメントアウト

### 📄asym_ble.dtsi
かなり長いので省略

```devicetree

#include <dt-bindings/zmk/matrix_transform.h>
/ {
	chosen {
		zmk,kscan = &kscan0;
		zmk,matrix_transform = &default_transform;
	};
    
	kscan0: kscan {
		compatible = "zmk,kscan-gpio-matrix";
		diode-direction = "col2row";
		row-gpios =
			<&xiao_d  1  (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>,
			～～～
			<&xiao_d  3  (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>;
		col-gpios =
			<&xiao_d  0  GPIO_ACTIVE_HIGH>,
			～～～
			<&xiao_d  2  GPIO_ACTIVE_HIGH>;
	};
    
	default_transform: matrix_transform_0 {
		compatible = "zmk,matrix-tranxform";
		rows = <4>;
		columns = <12>;
		map = <
			RC(0,0) RC(0,1) RC(0,2)～～～;
			RC(1,0) RC(1,1) RC(1,2)～～～;
			RC(2,0) RC(2,1) RC(2,2)～～～;
			RC(3,0)         RC(3,2)～～～;
		>;
	}
};
```





### 📄asym_ble.keymap
かなり長いので省略<br>
### 📄asym_ble.zmk.yml
デバイスのメタデータ設定<br>
```yml
file_format: "1"
id: asym_ble
name: asym_ble
type: shield
url: https://github.com/tamanium/my_zmk_firmware/
requires: [seeeduino_xiao_ble]
features:
  - keys
siblings:
  - asym_ble_left
  - asym_ble_right
  
```
### 📄asym_ble_left.overlay
dtsiの内容に対して左シールド独自の設定を記載<br>
col-gpiosのピン割り当てとか<br>
```dts
#include "asym_ble.dtsi"
```
### 📄asym_ble_right.overlay
dtsiの内容に対して左シールド独自の設定を記載<br>
col-gpiosのピン割り当てとか、
keymapのcol番号のオフセット設定とか<br>

```dts
#include "asym_ble.dtsi"

&default_transform {
	col-offset = <6>;
};
```
