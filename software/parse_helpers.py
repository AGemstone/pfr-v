import subprocess as sp


def subp_run(cmd, capture_output=False):
    return sp.run(cmd.split(" "), capture_output=capture_output, text=True)


def instr_patch(instr):
    patch = ""
    if instr[:2] in ["ld", "lw", "lh", "lb"]:
        opcode, args = instr.split()
        args = args.split(",")

        if(args[0] in args[1]):
            print(args)
            #using an unlikely to be used register
            patch += f"mv t6, {args[0]}\n"
            args[1] = args[1].replace(args[0],"t6")
            instr = f"{opcode}\t{args[0]}, {args[1]}"
            print(instr)
        
        patch += f"{instr}\n"
    patch += f"{instr}\n"
    print(patch)
    print()
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
