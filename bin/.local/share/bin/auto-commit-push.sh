#!/bin/bash
path=$1
cd $path  # 替换为你的仓库路径
git add .  # 添加所有修改（可按需调整）
git commit -m "Auto-commit: $(date +'%Y-%m-%d %H:%M:%S')"  # 含时间戳的提交信息
git push origin main  # 推送的分支名称（如 main/master）
