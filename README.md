■...開発する上で編集不要なファイル：README・CMDショートカット・隠しファイル<br>
<br>
C:.<br>
│　build.yaml<br>
│　■Command Prompt.lnk<br>
│　■README.md<br>
│<br>
├─■.github<br>
│　　└─■workflows<br>
│　　　　■build.yml<br>
│<br>
└─config<br>
　　　│　○west.yml<br>
　　　│<br>
　　　└─boards<br>
　　　　　　└─shields<br>
　　　　　　　　　└─asym_ble<br>
　　　　　　　　　　　Kconfig.defconfig<br>
　　　　　　　　　　　　　├─キーボード名の定義<br>
　　　　　　　　　　　　　└─分割の設定<br>
　　　　　　　　　　　Kconfig.shield<br>
　　　　　　　　　　　　　└─不明<br>
　　　　　　　　　　　asym_ble.conf<br>
　　　　　　　　　　　　　└─全コメントアウトでOK<br>
　　　　　　　　　　　asym_ble.dtsi<br>
　　　　　　　　　　　　　├─キーマップのレイアウト<br>
　　　　　　　　　　　　　├─col数, row数の定義<br>
　　　　　　　　　　　　　└─gpioの定義<br>
　　　　　　　　　　　asym_ble.keymap<br>
　　　　　　　　　　　　　├─コンボの定義<br>
　　　　　　　　　　　　　└─キーマップ・レイヤーの定義<br>
　　　　　　　　　　　asym_ble.zmk.yml<br>
　　　　　　　　　　　　　└─id・name・url等　いまはtiny20について記載<br>
　　　　　　　　　　　asym_ble_left.overlay<br>
　　　　　　　　　　　　　└─#include "tiny20.dtsi" のみ記載<br>
　　　　　　　　　　　asym_ble_right.overlay<br>
　　　　　　　　　　　　　├─#include "tiny20.dtsi"<br>
　　　　　　　　　　　　　└─col-offset=<20> 右側の場合はcol値を+10するらしい<br>
　　　　　　　　　　　　　                  この設定のおかげでキーマップ1個でうまいことやれている<br>
