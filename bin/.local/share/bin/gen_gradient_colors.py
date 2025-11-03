#!/usr/bin/env python3


def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))


def rgb_to_hex(rgb):
    return "#{:02X}{:02X}{:02X}".format(*rgb)


def generate_gradients(start_hex, end_hex, steps=8):
    start_rgb = hex_to_rgb(start_hex)
    end_rgb = hex_to_rgb(end_hex)

    gradients = []
    for i in range(1, steps + 1):
        ratio = i / (steps + 1)
        r = int(start_rgb[0] + (end_rgb[0] - start_rgb[0]) * ratio)
        g = int(start_rgb[1] + (end_rgb[1] - start_rgb[1]) * ratio)
        b = int(start_rgb[2] + (end_rgb[2] - start_rgb[2]) * ratio)
        gradients.append(rgb_to_hex((r, g, b)))
    return gradients


color_path = "/home/fireond/.dotfiles/cava/.config/cava/matugen"
config_path = "/home/fireond/.dotfiles/cava/.config/cava/config"

with open(color_path, "r") as file:
    lines = [file.readline().strip() for _ in range(2)]

gradients = generate_gradients(lines[0], lines[1])


with open(config_path, "r") as file:
    lines = file.readlines()

# 替换或添加颜色值
find = False
for i, line in enumerate(lines):
    if line.startswith("# matugen"):
        find = True
        for j, color in enumerate(gradients, start=1):
            lines[i + j] = f"gradient_color_{j} = '{color}'\n"
        break
if not find:
    print("Not find #matugen!")
# for i, color in enumerate(gradients, start=1):
#     # 在每行中找到 gradient_color_i 的行并替换
#     for j, line in enumerate(lines):
#         if line.startswith(f"gradient_color_{i}"):
#             lines[j] = f"gradient_color_{i} = '{color}'\n"
#             break
#     else:
#         # 如果没有找到对应的行，就添加新行
#         lines.append(f"gradient_color_{i} = '{color}'\n")

# 将修改后的内容写回文件
with open(config_path, "w") as file:
    file.writelines(lines)
