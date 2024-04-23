# zmk firmwareの作成方法について
## フォルダ構成
```:フォルダ構成
📁my_zmk_firmware
 ├─ 📄build.yaml
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
```yaml
#マイコンボード名
board: [seeeduino_xiao_ble]
#シールド名 カンマ区切り
shield: [asym_ble_left, asym_ble_right, settings_reset] 
```
こっちの入力方法でもOK
```yaml
include:
  - board: seeeduino_xiao_ble #マイコンボード名
    shield: asym_ble_left     #シールド名
  - board: seeeduino_xiao_ble
    shield: asym_ble_right
  - board: seeeduino_xiao_ble
    shield: settings_reset
```

### 📄build.yml
<details>

<summary>クリックして内容表示</summary>
	
```yml
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
```yml
# シールド設定で分岐
if SHIELD_LEFT             
# デバイス表示名定数
config ZMK_KEYBOARD_NAME
        # 16文字以内
        default "asym_ble"

# ホストとの接続役かどうか
config ZMK_SPLIT_ROLE_CENTRAL 
        default y          

endif
if SHIELD_LEFT || SHIELD_RIGHT
# 分割キーボードか否か
config ZMK_SPLIT
        default y
endif
```
### 📄Kconfig.shield
シールド設定の定義
```yml
# シールド設定の名称
config SHIELD_LEFT                      #↓第2引数にシールド名
        def_bool $(shields_list_contains,asym_ble_left)
config SHIELD_RIGHT
        def_bool $(shields_list_contains,asym_ble_right)
```
### 📄asym_ble.conf
機能設定 キー入力だけなら入力不要or全コメントアウト

### 📄asym_ble.dtsi
キー入力の基本設定
```c
#include <dt-bindings/zmk/matrix_transform.h>
/ {
	chosen {
		zmk,kscan = &kscan0;
		zmk,matrix_transform = &default_transform;
	};
	default_transform: matrix_transform_0 {
		compatible = "zmk,matrix-transform";
		rows = <4>;
		columns = <13>;
		map = <
			RC(0,1)	RC(1,1)	RC(0,2)	RC(0,3)	RC(0,4)	RC(0,5)				RC(0,6)	RC(0,7)	RC(0,8)	RC(0,9)	RC(0,10)	RC(0,11)	RC(1,11)
			RC(0,0)	RC(2,1)	RC(1,2)	RC(1,3)	RC(1,4)	RC(1,5)				RC(1,6)	RC(1,7)	RC(1,8)	RC(1,9)	RC(1,10)	RC(2,11)
			RC(1,0)	RC(3,2)	RC(2,2)	RC(2,3)	RC(2,4)	RC(2,5)		RC(3,6)	RC(2,6)	RC(2,7)	RC(2,8)	RC(2,9)	RC(2,10)	RC(3,11)
			RC(2,0)							RC(3,4)	RC(3,5)		RC(3,8)	RC(3,9) 
		>;
	};

	kscan0: kscan {
		compatible = "zmk,kscan-gpio-matrix";
		diode-direction = "col2row";
		col-gpios =
			<&xiao_d  0  GPIO_ACTIVE_HIGH>,
			<&xiao_d  1  GPIO_ACTIVE_HIGH>,
			<&xiao_d  2  GPIO_ACTIVE_HIGH>,
			<&xiao_d  3  GPIO_ACTIVE_HIGH>,
			<&xiao_d  4  GPIO_ACTIVE_HIGH>,
			<&xiao_d  5  GPIO_ACTIVE_HIGH>;
		row-gpios =
			<&xiao_d  6  (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>,
			<&xiao_d  7  (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>,
			<&xiao_d  8  (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>,
			<&xiao_d  9  (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>;
	};
};
```


### 📄asym_ble.keymap
かなり長いので省略<br>
### 📄asym_ble.zmk.yml
デバイスのメタデータ設定<br>
```yml
file_format: "1"
id: asym_ble   #キーボード名
name: asym_ble #キーボード名
type: shield
url: https://github.com/tamanium/my_zmk_firmware/
requires: [seeeduino_xiao_ble] #マイコンボード名
features:
  - keys
siblings:
  - asym_ble_left  #左シールド名
  - asym_ble_right #右シールド名
  
```
### 📄asym_ble_left.overlay
左シールド独自の設定を記載(col-gpiosなど)

```c
#include "asym_ble.dtsi"
```
### 📄asym_ble_right.overlay
右シールド独自の設定を記載(col-gpiosやcol番号のオフセットなど)

```c
#include "asym_ble.dtsi"
&default_transform {
	col-offset = <6>;
};
```
