# zleep
zig で sleep 時にプログレスバーを表示するだけのコマンド。

## 利用方法
```
# sleep する秒数を引数で入力
./zleep 5

# ファイル指定で実行
zig run zleep.zig -- 5

# ビルド
zig build-exe -Drelease-small zleep.zig
```