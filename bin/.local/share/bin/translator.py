#!/usr/bin/env python3
import os
import sys
import configparser
import subprocess
import requests
from argparse import ArgumentParser

# 环境配置
os.environ["GDK_BACKEND"] = "wayland"
CONFIG_PATH = os.path.expanduser("~/Documents/api.conf")


def get_wayland_text(primary=True):
    """获取选区或剪贴板内容"""
    try:
        return (
            subprocess.check_output(
                ["wl-paste", "-p" if primary else ""],
                timeout=2,
                stderr=subprocess.DEVNULL,
            )
            .decode()
            .strip()
        )
    except:
        return ""


def show_dialog(content, dialog_type="info"):
    """显示Zenity弹窗"""
    cmd = ["zenity", f"--{dialog_type}", "--width=600", "--height=400"]
    if dialog_type == "text-info":
        cmd += ["--title=翻译结果", "--font=Noto Sans 12", f"--text={content}"]
    elif dialog_type == "list":
        cmd += [
            "--title=选择翻译引擎",
            "--column=引擎",
            "--column=描述",
            "DeepSeek",
            "深度求索AI",
            "DeepL",
            "专业翻译",
            "Google",
            "免费快速",
        ]
    subprocess.run(cmd)


def translate(text, engine, target_lang):
    """多引擎翻译核心"""
    config = configparser.ConfigParser()
    config.read(CONFIG_PATH)

    # DeepSeek翻译
    if engine == "DeepSeek":
        headers = {"Authorization": f"Bearer {config['DEEPSEEK']['api_key']}"}
        payload = {
            "model": config["DEEPSEEK"].get("model", "deepseek-chat"),
            "messages": [
                {
                    "role": "system",
                    "content": f"你是一位翻译专家，请将内容精准翻译为{target_lang}",
                },
                {"role": "user", "content": text},
            ],
        }
        response = requests.post(
            config["DEEPSEEK"]["endpoint"],
            headers=headers,
            json=payload,
            timeout=float(config["DEFAULT"]["timeout"]),
        )
        return response.json()["choices"][0]["message"]["content"]

    # DeepL翻译
    elif engine == "DeepL":
        data = {
            "auth_key": config["DEEPL"]["api_key"],
            "text": text,
            "target_lang": target_lang,
        }
        response = requests.post(
            config["DEEPL"]["endpoint"],
            data=data,
            timeout=float(config["DEFAULT"]["timeout"]),
        )
        return response.json()["translations"][0]["text"]

    # Google翻译
    elif engine == "Google":
        params = {
            "client": "gtx",
            "sl": "auto",
            "tl": target_lang,
            "dt": "t",
            "q": text,
        }
        response = requests.get(
            config["GOOGLE"]["endpoint"],
            params=params,
            timeout=float(config["DEFAULT"]["timeout"]),
        )
        return response.json()[0][0][0]


def main():
    # 获取输入文本
    if text := get_wayland_text():
        engine = subprocess.check_output(
            ["zenity", "--list", "--hide-header", "--print-column=1"]
            + ["DeepSeek", "DeepL", "Google"],
            text=True,
        ).strip()

        if not engine:
            sys.exit(0)

        translated = translate(text, engine, config["DEFAULT"]["default_lang"])
        show_dialog(f"【{engine}翻译结果】\n\n{translated}", "text-info")

        # 结果存入剪贴板
        subprocess.run(["wl-copy"], input=translated.encode())
    else:
        show_dialog("未检测到选中文本！", "error")


if __name__ == "__main__":
    main()
