import shutil
import os
import glob

files = glob.glob("*.png")

if len(files) > 0:
    folders = [
        "up_right",
        "right",
        "down_right",
        "down",
        "down_left",
        "left",
        "up_left",
        "up",
    ]

    for folder in folders:
        if not os.path.exists(folder):
            os.mkdir(folder)

    for file in files:
        number = int(os.path.splitext(file)[0]) - 1
        new_name = os.path.join(folders[number % 8], file)
        shutil.move(file, new_name)
        print(file, "->", new_name)
