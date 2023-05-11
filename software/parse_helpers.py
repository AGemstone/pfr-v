import subprocess as sp


def subp_run(cmd, capture_output=False):
    return sp.run(cmd.split(" "), capture_output=capture_output, text=True)


def instr_patch(instr):
    patch = f"{instr}\n"
    if instr[:2] in ["ld", "lw", "lh", "lb"]:
        patch += f"{instr}\n"
    return patch


def instr_parse(x):
    res = ""
    try:
        res = f"//{x[0]} {x[2]} {x[3]}"
    except:
        res = f"//{x[0]} {x[2]}"
    return res


def index_where_str_in(string_list, query):
    return [idx for idx, value in enumerate(string_list) if query in value][0]
