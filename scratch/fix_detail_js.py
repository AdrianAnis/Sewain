import re

file_path = r"d:\TELKOM UNIVERSITY\TUGAS KULIAH\SEMESTER 4\PBO\Tubes\Sewain\web\assets\js\tenant\detail.js"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace escaped dollars \$ with $
new_content = content.replace(r"\$", "$")

# Replace escaped backticks \` with `
new_content = new_content.replace(r"\`" , "`")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(new_content)

print("Replacement done!")
