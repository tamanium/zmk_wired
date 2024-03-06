# zmk firmwareの作成方法について
## フォルダ構成
以下条件の場合<br>
・キーボード名:asym_ble<br>
・左(右)側キーボード:asym_ble_left(right)<br>

📁my_zmk_firmware<br>
├─ 📄build.yaml<br>
├─ 📄README.md<br>
├─ 📁.github ─ 📁workflows<br>
│　　　　　　　└─ 📄build.yml<br>
│<br>
└─ 📁config<br>
　　├─ 📄west.yml<br>
　　└─ 📁boards ─ 📁shields ─ 📁asym_ble<br>
　　　　　　　　　　　　　　　　├─ 📄Kconfig.defconfig<br>
　　　　　　　　　　　　　　　　├─ 📄Kconfig.shield<br>
　　　　　　　　　　　　　　　　├─ 📄asym_ble.conf<br>
　　　　　　　　　　　　　　　　├─ 📄asym_ble.dtsi<br>
　　　　　　　　　　　　　　　　├─ 📄asym_ble.keymap<br>
　　　　　　　　　　　　　　　　├─ 📄asym_ble.zmk.yml<br>
　　　　　　　　　　　　　　　　├─ 📄asym_ble_left.overlay<br>
　　　　　　　　　　　　　　　　└─ 📄asym_ble_right.overlay<br>
********
## ファイルについて

### 📄build.yaml
マイコンボードとキーボード名を設定<br>
キーボード名は〇〇で定義<br>
```yaml
board: [seeeduino_xiao_ble]
shield: [asym_ble_left, asym_ble_right]
```
### README.md
説明文。なくてもOK<br>
### build.yml
何もしない<br>
```yml
on: [push, pull_request, workflow_dispatch]

jobs:
  build:
    uses: zmkfirmware/zmk/.github/workflows/build-user-config.yml@main
```
### west.yml
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
### Kconfig.defconfig
デバイス名の定義？<br>
ZMK_SPLIT(分割キーボード)を設定するか<br>
ZMK_SPLIT_ROLE_CENTRALを左右どちらに設定するか(通常は左らしい)<br>
```
# Copyright (c) 2022 The ZMK Contributors
# SPDX-License-Identifier: MIT

if SHIELD_TINY_LEFT
config ZMK_KEYBOARD_NAME
	default "asym_ble"

config ZMK_SPLIT_ROLE_CENTRAL
	default y

endif
if SHIELD_TINY_LEFT || SHIELD_TINY_RIGHT

config ZMK_SPLIT
	default y

endif
```
### Kconfig.shield
SHIELD_TINY_LEFT(RIGHT)の定義？<br>
それぞれ$(shields_list_contains,～～)に左右キーボード名を入れる<br>
```
# Copyright (c) 2022 The ZMK Contributors
# SPDX-License-Identifier: MIT

config SHIELD_TINY_LEFT
	def_bool $(shields_list_contains,asym_ble_left)

config SHIELD_TINY_RIGHT
	def_bool $(shields_list_contains,asym_ble_right)
```
### asym_ble.conf
### asym_ble.dtsi
### asym_ble.keymap
### asym_ble.zmk.yml
### asym_ble_left.overlay
### asym_ble_right.overlay
