# トラブル備忘録
## case 1 再ペアリング不可
### 事象
1. キーボードをペアリングする
2. キーボードをデバイス削除（ペアリング解除）する
3. キーボードをペアリングする <-ここで接続が失敗する
### 試したこと（解決不可）
- キーボードの再起動
- PCの再起動
- firmware再書込
### 解決策
- 別キーボードのfirmwareを書き込み、その後本来のfirmwareを書き込んだ
    - 今回用いたのは[mentako-ya様のリセット用uf2](https://github.com/mentako-ya/magictrackrest-zmk-config/tree/main/firmware)
> 本キーボードの情報をクリアにできれば書き込む内容はなんでもOK？
### 原因
不明
### 対策
- デバイス削除（ペアリング解除）操作を行わない
- bluetooth接続を切りたい場合はホストのbluetooth機能をoffにする
