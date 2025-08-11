
# Shutter Stockへのアップロード手順

## ファイルをRenameする

```bash
ls -1 *.JPG | sort -V | awk '{printf "mv -- \"%s\" \"Aka_macrofish_%03d.JPG\"\n", $0, NR}'
```
