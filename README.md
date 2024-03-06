# zmk firmwareの作成方法について
## フォルダ構成
以下条件の場合<br>
・キーボード名:asym_ble<br>
・左(右)側キーボード:asym_ble_left(right)<br>

📁my_zmk_firmware<br>
　├─ 📄build.yaml<br>
　├─ 📄README.md<br>
　├─ 📁.github<br>
　│　　└─ 📁workflows<br>
　│　　　　└─ 📄build.yml<br>
　│<br>
　└─ 📁config<br>
　　　　├─ 📄west.yml<br>
　　　　└─ 📁boards<br>
　　　　　　　└─ 📁shields<br>
　　　　　　　　　└─ 📁asym_ble<br>
　　　　　　　　　　　├─ 📄Kconfig.defconfig<br>
　　　　　　　　　　　├─ 📄Kconfig.shield<br>
　　　　　　　　　　　├─ 📄asym_ble.conf<br>
　　　　　　　　　　　├─ 📄asym_ble.dtsi<br>
　　　　　　　　　　　├─ 📄asym_ble.keymap<br>
　　　　　　　　　　　├─ 📄asym_ble.zmk.yml<br>
　　　　　　　　　　　├─ 📄asym_ble_left.overlay<br>
　　　　　　　　　　　└─ 📄asym_ble_right.overlay<br>

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
### Kconfig.defconfig
### Kconfig.shield
### asym_ble.conf
### asym_ble.dtsi
### asym_ble.keymap
### asym_ble.zmk.yml
### asym_ble_left.overlay
### asym_ble_right.overlay
