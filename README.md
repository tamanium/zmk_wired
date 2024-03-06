# zmk firmwareの作成方法について
## フォルダ構成
以下条件の場合<br>
・キーボード名:asym_ble<br>
・左(右)側キーボード:asym_ble_left(right)<br>
```
📁my_zmk_firmware
├─ 📄build.yaml
├─ 📄README.md
├─ 📁.github ─ 📁workflows
│               └─ 📄build.yml
└─ 📁config
    ├─ 📄west.yml
    └─ 📁boards ─ 📁shields ─ 📁asym_ble
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
マイコンボードとキーボード名を設定<br>
キーボード名は〇〇で定義<br>
```yaml
board: [seeeduino_xiao_ble]
shield: [asym_ble_left, asym_ble_right]
```
### 📄README.md
説明文。なくてもOK<br>
### build.yml
何もしない<br>
```yml
on: [push, pull_request, workflow_dispatch]

jobs:
  build:
    uses: zmkfirmware/zmk/.github/workflows/build-user-config.yml@main
```
### 📄west.yml
何もしない<br>
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
### 📄Kconfig.defconfig
接続時に表示されるデバイス名の定義<br>
ZMK_SPLIT(分割キーボード)を設定するか<br>
ZMK_SPLIT_ROLE_CENTRALを左右どちらに設定するか(通常は左らしい)<br>
```
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
「シールド設定名」「シールド名」の定義<br>
任意の名前でok<br>
・「シールド設定名」.defconfigで使う<br>
・「シールド名」build.ymlで使う<br>

```
config 「シールド設定名」
	def_bool $(shields_list_contains,「シールド名」)
```
本ファームウェアでは以下の通り<br>
```
config SHIELD_LEFT
	def_bool $(shields_list_contains,asym_ble_left)

config SHIELD_RIGHT
	def_bool $(shields_list_contains,asym_ble_right)
```
### 📄asym_ble.conf
機能設定<br>
キー入力だけなら全てコメントアウト<br>
```
# CONFIG_ZMK_RGB_UNDERGLOW=y
# CONFIG_WS2812_STRIP=y
# CONFIG_ZMK_USB_LOGGING=y # caused some issues with keys repeating
# CONFIG_ZMK_MOUSE=y
# CONFIG_BT_CTLR_TX_PWR_PLUS_8=y
# CONFIG_GPIO=y
```
### 📄asym_ble.dtsi
いろいろ設定<br>
### 📄asym_ble.keymap
キーマップ設定<br>
### 📄asym_ble.zmk.yml
デバイスのメタデータ設定<br>
### 📄asym_ble_left.overlay
シールド毎の設定<br>
### 📄asym_ble_right.overlay
シールド毎の設定<br>
