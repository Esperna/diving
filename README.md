
# Shutter Stockへのアップロード手順

## ファイルをRenameする

例
```bash
ls -1 Aka/shutter/*.JPG | sort -V | awk '{printf "mv -- \"%s\" \"Aka_macrofish_%d.JPG\"\n", $0, NR}'
```

## Renameしたファイルをアップロードする

* https://submit.shutterstock.com/ からアップロードする
  * 画像のアップロードが先で、その後にtemplateより作成したcsvをアップロードする
  * templateのcsvに記載されているファイル名とアップロードするファイルを一致させる