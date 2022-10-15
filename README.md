# zleep
zig で sleep 時にプログレスバーを表示するだけのコマンド。

## 利用方法
```
# ビルド
zig build-exe -Drelease-small zleep.zig

# sleep する秒数を引数で入力
./zleep 5

# ファイル指定で実行
zig run zleep.zig -- 5
```
## 実行イメージ
![](https://storage.googleapis.com/zenn-user-upload/0676ecf09407-20221011.gif)
