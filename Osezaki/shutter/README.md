
# Shutter Stockへのアップロード手順

## 目的

* 煩わしい手動の手順を減らすこと

## ファイルをRenameする

```bash
ls -1 *.JPG | sort -V | awk '{printf "mv -- \"%s\" \"Ose_macrofish_%03d.JPG\"\n", $0, NR}'
```

## Renameしたファイルをアップロードする

* https://submit.shutterstock.com/ からアップロードする
  * 画像のアップロードが先で、その後にtemplateより作成したcsvをアップロードする
  * templateのcsvに記載されているファイル名とアップロードするファイルを一致させる
