import shutil
import os
import glob
import sys

args = sys.argv[1:]

if len(args) == 1:
    root = sys.argv[1:]

    if root:
        root = os.path.join(os.getcwd(), root)
    else:
        root = os.getcwd()

    print("target:", root)

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
    else:
        print("no files to organize")
else:
    print("couldn't parse arguments")
