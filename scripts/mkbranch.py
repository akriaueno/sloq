#!/usr/bin/env python3

import re
import subprocess
import sys

print_prefix = "[mkbranch]"
issue = input(
    f"{print_prefix} Paste issue name and number with sharp (ex. implement foo #5)\n"
)
issue_regex = re.compile(r"^(.+)\#(\d+)$")
if not issue_regex.match(issue):
    print("Bad Format: can't parse input.", file=sys.stderr)
    exit(1)
issue_title, issue_no = issue_regex.match(issue).groups()
formatted_issue_title = issue_title.strip().replace(" ", "_")
branch_base = "feature"
branch_detail = f"#{issue_no}_{formatted_issue_title}"
branch_name = f"{branch_base}/{branch_detail}"
create_branch = False
while True:
    user_input = input(f"{print_prefix} Create branch {branch_name}?[Y/n]: ")
    if user_input in ["y", "yes", "Y", "YES", "Yes"]:
        create_branch = True
        break
    elif user_input in ["n", "no", "N", "NO", "No"]:
        exit()

cmd = ["git", "checkout", "-b", branch_name]
subprocess.run(cmd)
