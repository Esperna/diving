#!/bin/bash

# 引数チェック
if [ -z "$2" ]; then
    echo "使用方法: $0 <divingsite> <category>"
    echo "例: $0 Aka macrofish"
    exit 1
fi

divingsite="$1"
category="$2"
category_dir="$divingsite/$category"

# カテゴリフォルダの存在確認
if [ ! -d "$category_dir" ]; then
    echo "エラー: フォルダ '$category_dir' が見つかりません"
    exit 1
fi

ls -1 "$category_dir"/*.JPG | sort -V | \
    awk -v site="$divingsite" -v cat="$category" -v dir="$category_dir" '{printf "mv -- \"%s\" \"%s/%s_%s_%d.JPG\"\n", $0, dir, site, cat, NR}' | sh

# カテゴリフォルダ内の*_template.csvファイルを探す
template_file=$(find "$category_dir" -maxdepth 1 -name "*_template.csv" | head -n 1)

if [ -z "$template_file" ]; then
    echo "エラー: '$category_dir' フォルダ内に *_template.csv ファイルが見つかりません"
    exit 1
fi

echo "カテゴリ: $category"
echo "テンプレートファイル: $template_file"

# 2行目（テンプレートデータ行）を読み込む
template_line=$(sed -n '2p' "$template_file")

# 2行目の1列目以外の部分を取得（カンマ区切りで2列目以降）
# 最初のカンマの位置を見つけて、それ以降を取得
template_rest=$(echo "$template_line" | sed 's/^[^,]*,\s*//')

# ヘッダー行を取得
header=$(head -n 1 "$template_file")

# カテゴリフォルダ内の*.JPGファイルを取得（数値順にソート）
jpg_files=($(ls -1 "$category_dir"/*.JPG 2>/dev/null | sort -V))

if [ ${#jpg_files[@]} -eq 0 ]; then
    echo "警告: '$category_dir' フォルダ内に *.JPG ファイルが見つかりません"
    exit 1
fi

jpg_count=${#jpg_files[@]}
echo "JPGファイル数: $jpg_count"

# ファイルを100件ごとに分割
current_output_file=""

for i in "${!jpg_files[@]}"; do
    jpg_file="${jpg_files[$i]}"
    # ファイル名のみを取得（パスからファイル名部分を抽出）
    jpg_filename=$(basename "$jpg_file")
    file_number=$((i + 1))
    
    # 100件ごとのグループの開始番号を計算
    # 例: 1→1, 101→101, 201→201, 301→301
    start_number=$((((file_number - 1) / 100) * 100 + 1))
    
    # 終了番号を計算（グループの最後または総ファイル数の小さい方）
    end_number=$((start_number + 99))
    if [ $end_number -gt $jpg_count ]; then
        end_number=$jpg_count
    fi
    
    # 出力ファイル名を生成（カテゴリフォルダ内に出力）
    output_file="$category_dir/metadata${start_number}-${end_number}.csv"
    
    # ファイルが変わった場合、ヘッダーを書き込む
    if [ "$output_file" != "$current_output_file" ]; then
        current_output_file="$output_file"
        echo "$header" > "$output_file"
        echo "作成中: $output_file"
    fi
    
    # 1列目にJPGファイル名、2列目以降にテンプレートの2列目以降の内容を結合
    echo "$jpg_filename,$template_rest" >> "$output_file"
done

echo "メタデータファイルを作成しました"

