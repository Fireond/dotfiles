#!/usr/bin/env python3
"""
nutrition_log.py - 支持快捷参数和批量输入的营养日志工具
更新说明：
1. 添加参数缩写（-w, -c, -p, -f）
2. 添加--nutrients参数批量输入三大营养素
3. 添加输入值校验
"""

import argparse
import csv
from datetime import datetime
import os
from typing import List, Optional

CSV_FILE = "/home/fireond/Documents/nutrition_data.csv"
COLUMNS = [
    "Date",
    "Weight(kg)",
    "Carbs(g)",
    "Proteins(g)",
    "Fats(g)",
    "Energy(kCal)",
    "DayType",
]
DAY_TYPES = ["t", "r"]


def init_file():
    """初始化CSV文件"""
    if not os.path.exists(CSV_FILE):
        with open(CSV_FILE, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(COLUMNS)
        print(f"初始化成功，已创建文件 {CSV_FILE}")
    else:
        print(f"文件 {CSV_FILE} 已存在")


def validate_positive(value: float, name: str):
    """校验正值"""
    if value < 0:
        raise ValueError(f"{name} 不能为负值")
    return value


def validate_day_type(value: str):
    """校验日期类型输入"""
    if value.lower() not in DAY_TYPES:
        raise ValueError(f"DayType 必须是 {DAY_TYPES} 之一")
    return value.lower()


def safe_round(value: Optional[float], decimals: int) -> Optional[float]:
    """安全处理四舍五入（允许None值）"""
    return round(value, decimals) if value is not None else None


def update_entry(
    date: str,
    weight: Optional[float],
    carbs: Optional[float],
    proteins: Optional[float],
    fats: Optional[float],
    day_type: Optional[str],
):
    """更新或创建记录"""
    # 验证日期格式
    try:
        datetime.strptime(date, "%Y-%m-%d")
    except ValueError:
        raise ValueError("日期格式不正确，请使用 YYYY-MM-DD 格式")

    # 读取现有数据
    entries = []
    exists = os.path.exists(CSV_FILE)

    if exists:
        with open(CSV_FILE, "r") as f:
            reader = csv.DictReader(f)
            entries = list(reader)

    # 查找现有记录
    target_entry = None
    for entry in entries:
        if entry["Date"] == date:
            target_entry = entry
            break

    # 创建或更新记录
    if not target_entry:
        target_entry = {col: None for col in COLUMNS}
        target_entry["Date"] = date
        entries.append(target_entry)

    if day_type is not None:
        target_entry["DayType"] = validate_day_type(day_type)

    # 只更新提供的字段（应用四舍五入）
    if weight is not None:
        target_entry["Weight(kg)"] = safe_round(validate_positive(weight, "体重"), 2)
    if carbs is not None:
        target_entry["Carbs(g)"] = safe_round(validate_positive(carbs, "碳水"), 1)
    if proteins is not None:
        target_entry["Proteins(g)"] = safe_round(
            validate_positive(proteins, "蛋白质"), 1
        )
    if fats is not None:
        target_entry["Fats(g)"] = safe_round(validate_positive(fats, "脂肪"), 1)

    # 计算热量（未提供的营养数据视为0）
    c = float(target_entry["Carbs(g)"]) if target_entry.get("Carbs(g)") else 0
    p = float(target_entry["Proteins(g)"]) if target_entry.get("Proteins(g)") else 0
    f = float(target_entry["Fats(g)"]) if target_entry.get("Fats(g)") else 0
    target_entry["Energy(kCal)"] = round(4 * c + 4 * p + 9 * f, 1)

    # 写入文件
    with open(CSV_FILE, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=COLUMNS)
        writer.writeheader()
        for entry in entries:
            # 转换None值为空字符串
            processed = {k: v if v is not None else "" for k, v in entry.items()}
            writer.writerow(processed)


def view_entries():
    """查看所有记录（带友好格式）"""
    if not os.path.exists(CSV_FILE):
        print("尚未初始化，请先运行 init 命令")
        return

    with open(CSV_FILE, "r") as f:
        reader = csv.DictReader(f)
        entries = list(reader)

    if not entries:
        print("暂无记录")
        return

    # 按日期排序
    entries.sort(key=lambda x: x["Date"])

    # 打印表格
    print("\n营养记录（未填写项目显示为 --）：")
    headers = [
        "日期",
        "体重(kg)",
        "碳水(g)",
        "蛋白质(g)",
        "脂肪(g)",
        "热量(kCal)",
        "类型",
    ]
    print(
        f"{headers[0]:<10} | {headers[1]:<6} | {headers[2]:<6} | {headers[3]:<7} | {headers[4]:<6} | {headers[5]:<8} | {headers[6]:<6}"
    )
    print("-" * 95)

    for entry in entries:
        date = entry["Date"]
        weight = entry["Weight(kg)"] or "--"
        carbs = entry["Carbs(g)"] or "--"
        proteins = entry["Proteins(g)"] or "--"
        fats = entry["Fats(g)"] or "--"
        energy = entry["Energy(kCal)"] or "--"
        day_type = entry.get("DayType", "--") or "--"
        day_type_symbol = (
            "t"
            if day_type == DAY_TYPES[0]
            else "r"
            if day_type == DAY_TYPES[1]
            else "--"
        )

        print(
            f"{date:<12} | {str(weight):<8} | {str(carbs):<8} | "
            f"{str(proteins):<10} | {str(fats):<8} | {str(energy):<10} | {day_type_symbol:<6}"
        )


def main():
    parser = argparse.ArgumentParser(
        description="分次记录营养数据工具",
        formatter_class=argparse.RawTextHelpFormatter,
    )
    subparsers = parser.add_subparsers(dest="command")

    # init 命令
    subparsers.add_parser("init", help="初始化CSV文件")

    # add 命令
    add_parser = subparsers.add_parser(
        "add",
        help="""添加/更新记录
示例：
仅记录体重：  add -d 2025-03-27 -w 52.5
批量营养输入：add -d 2025-03-27 -n 150 60 30
组合输入：    add -d 2025-03-27 -w 52.5 -n 150 60 30""",
    )

    add_parser.add_argument(
        "-d",
        "--date",
        default=datetime.today().strftime("%Y-%m-%d"),
        help="日期（默认今天）",
    )
    add_parser.add_argument("-w", "--weight", type=float, help="体重（kg）")

    add_parser.add_argument(
        "-t",
        "--day-type",
        type=str,
        choices=DAY_TYPES,
        help="日期类型：t（训练日）/r（休息日）",
    )

    # 批量营养参数组
    nutrients_group = add_parser.add_argument_group("营养输入选项（可任选其一）")
    nutrients_group.add_argument(
        "-n",
        "--nutrients",
        type=float,
        nargs=3,
        metavar=("CARBS", "PROTEINS", "FATS"),
        help="一次性输入三大营养素：碳水 蛋白质 脂肪",
    )
    nutrients_group.add_argument("-c", "--carbs", type=float, help="碳水化合物（g）")
    nutrients_group.add_argument("-p", "--proteins", type=float, help="蛋白质（g）")
    nutrients_group.add_argument("-f", "--fats", type=float, help="脂肪（g）")

    # view 命令
    subparsers.add_parser("view", help="查看所有记录")

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return

    try:
        if args.command == "init":
            init_file()
        elif args.command == "add":
            # 参数冲突检查
            if args.nutrients and (args.carbs or args.proteins or args.fats):
                raise ValueError("不能同时使用 --nutrients 和单独的营养参数")

            # 解析批量营养参数
            carbs = proteins = fats = None
            if args.nutrients:
                carbs, proteins, fats = args.nutrients

            update_entry(
                args.date,
                args.weight,
                carbs or args.carbs,
                proteins or args.proteins,
                fats or args.fats,
                args.day_type,
            )
            print(f"记录已更新：{args.date}")
        elif args.command == "view":
            view_entries()
    except Exception as e:
        print(f"操作失败：{str(e)}")


if __name__ == "__main__":
    main()
