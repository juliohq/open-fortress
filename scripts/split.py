import shutil
import os
import glob
import sys

assert(len(sys.argv) == 2)
directions = int(sys.argv[1])

files = glob.glob("*.png")

if len(files) > 0:
    folders = []
    
    if directions == 4:
        folders = [
            "right",
            "down",
            "left",
            "up",
        ]
    elif directions == 8:
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

    assert(len(directions) > 0)

    for folder in folders:
        if not os.path.exists(folder):
            os.mkdir(folder)

    for file in files:
        number = int(os.path.splitext(file)[0]) - 1
        new_name = os.path.join(folders[number % directions], file)
        shutil.move(file, new_name)
        print(file, "->", new_name)
