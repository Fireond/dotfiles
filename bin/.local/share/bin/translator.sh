#!/bin/bash

# 配置Google Translate API密钥（需替换成你自己的）
API_KEY="YOUR_API_KEY"
TARGET_LANG="zh-CN" # 目标语言设置为简体中文

# 创建多行输入临时文件
INPUT_FILE=$(mktemp)

# 多行输入对话框（800x600大窗口）
zenity --text-info \
  --title="翻译输入" \
  --width=800 \
  --height=600 \
  --editable \
  --filename="$INPUT_FILE" \
  --ok-label="开始翻译" \
  --cancel-label="退出" >"$INPUT_FILE"

# 检查用户是否输入内容
if [ ! -s "$INPUT_FILE" ]; then
  rm "$INPUT_FILE"
  exit 0
fi

# 调用Google Translate API（保留换行符）
INPUT_TEXT=$(sed ':a;N;$!ba;s/\n/\\n/g' "$INPUT_FILE") # 转换换行符为JSON格式
RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  --data "{
        'q': '$INPUT_TEXT',
        'target': '$TARGET_LANG',
        'format': 'text'
    }" \
  "https://translation.googleapis.com/language/translate/v2?key=$API_KEY")

# 解析响应并处理换行符
TRANSLATED_TEXT=$(echo "$RESPONSE" | jq -r '.data.translations[0].translatedText' | sed 's/\\n/\n/g')

if [ -n "$TRANSLATED_TEXT" ]; then
  # 创建结果临时文件
  RESULT_FILE=$(mktemp)
  echo -e "🔤 原文：\n$(cat "$INPUT_FILE")\n\n🌐 译文：\n$TRANSLATED_TEXT" >"$RESULT_FILE"

  # 显示结果（带滚动条的大窗口）
  zenity --text-info \
    --title="翻译结果" \
    --width=800 \
    --height=600 \
    --filename="$RESULT_FILE" \
    --ok-label="关闭" \
    --cancel-label="复制译文" 2>/dev/null

  # 静默复制操作
  if [ $? -eq 1 ]; then
    echo -e "$TRANSLATED_TEXT" | wl-copy
  fi

  rm "$INPUT_FILE" "$RESULT_FILE"
else
  zenity --error --title="错误" --text="翻译失败，请检查API密钥或网络连接"
  rm "$INPUT_FILE"
fi
