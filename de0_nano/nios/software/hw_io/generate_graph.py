from matplotlib import pyplot as plt
import numpy as np
import sys
import functools
import copy


def print_help():
    print("Missing arguments!")
    print("Valid arguments:")
    print("\t-i <input file>")
    print("\t-d [<target stack address/region>]")
    print("Optional arguments:")
    print("\t-f <value/s to filter from stack>")
    print("\t\t(Only valid if -d is a region)")
    # Usage examples:
    # python generate_graph -d\[1021\] -i data.dump
    # python generate_graph -d\[945:970\] -i data.dump
    # python generate_graph -d\[325:929\] -i data.dump -f 0xffffffffffffffff


def read_optional_arg(elem):
    try:
        return sys.argv[sys.argv.index(elem)+1]
    except:
        return None


def parse_args():
    if len(sys.argv) < 2:
        print_help()
        sys.exit(-1)
    try:
        file_name = sys.argv[sys.argv.index("-i") + 1]
        stack_region = sys.argv[sys.argv.index("-d") + 1][1:-1]
        stack_filter = read_optional_arg("-f")
        if stack_filter:
            stack_filter = parse_num(stack_filter)
        if ":" in stack_region:
            stack_region = slice(*map(int, stack_region.split(":")))
        else:
            stack_region = int(stack_region)
        return file_name, stack_region, stack_filter

    except Exception as e:
        print_help()
        sys.exit(-1)


def parse_num(num):
    value = None
    if "0x" in num:
        if "_" in num:
            high, low = num.split("_")
            value = (int(high, 16) << 32) + int(low, 16)
        else:
            value = int(num, 16)
    elif num == "dnf":
        value = 0xffdeadffffc0deff
    else:
        value = int(num)
    return value


def parse_run(results):
    summary, memdump = results.split("memdump:")

    summary = summary.split(",")
    summary = map(lambda elem: elem.split(":")[1], summary)
    summary = map(parse_num, summary)

    memdump = memdump.strip().split("\n")
    memdump = map(lambda elem: elem.split(":")[1], memdump)
    memdump = map(parse_num, memdump)

    return list(summary), list(memdump)


def register_indices(parsed_data):
    indices = []
    start = 0
    data_enum = list(enumerate(parsed_data))
    for i in range(32):
        for j, line in data_enum[start:]:
            if i == line[-3]:
                indices.append(j)
                start = j
                break
    return indices


file_path, stack_region, stack_filter = parse_args()
with open(file_path, "r") as f:
    # File name should always be something like file_name.dump
    path = file_path.split("/")
    file_name = path[-1].split(".")[0]
    # Last line is empty
    raw_data = f.read()[:-1]
    runs_unparsed = raw_data.split("\n\n")
    run_summary = []
    run_memdump = []
    run_count = len(runs_unparsed) - 1
    for run in runs_unparsed:
        summary, memdump = parse_run(run)
        run_summary.append(summary)
        run_memdump.append(memdump[stack_region])
    indices = register_indices(run_summary)
    index_slices = [slice(*(indices[i], indices[i + 1]))
                    for i in range(1, len(indices) - 1)]
    expected_results = run_memdump[0]
    if stack_filter is not None:
        expected_results = list(filter(lambda x: x != stack_filter,
                                       expected_results))
    memdump_by_register = [run_memdump[sl] for sl in index_slices]
    memdump_by_register.append(run_memdump[indices[-1]:])

    summary_by_register = [run_summary[sl] for sl in index_slices]
    summary_by_register.append(run_summary[indices[-1]:])

    # Distinguish runs by register
    # csum regs
    critical_registers = [1, 2, 8, 10, 14, 15]
    # cmatmul regs
    critical_registers = [1, 2, 8, 10, 11, 12, 13, 14, 15, 31]
    # dtn regs
    # critical_registers = [1, 2, 5, 8, 10, 11, 12, 13, 14, 15, 31]
    results_by_register = []
    
    # only valid for matmul
    
    bin_ranges = [(0x88, 0x270), (0x274, 0x354),
                  (0x358, 0x37c), (0x380, 0x3a0)]
    fig = plt.figure()
    for reg in range(31):
        run_results = []
        bins = np.zeros(len(bin_ranges))
        register_summaries = summary_by_register[reg]
        register_memdumps = memdump_by_register[reg]
        for summary, memdump in zip(register_summaries, register_memdumps):
            pc_inject = summary[0]
            exit_code = summary[4]
            if stack_filter is not None:
                memdump = list(filter(lambda x: x != stack_filter, memdump))
            success = (expected_results == memdump) and (exit_code == 0)
            if not success:
                bin_index = np.argmax(list(map(lambda x: x[0] <= pc_inject <= x[1],
                                     bin_ranges)))
                bins[bin_index] += 1
            run_results.append(success)
        results_by_register.append(run_results)
        
        ax = fig.add_subplot(1, 1, 1)
        ax.set_xlabel("Inject PC")
        ax.set_ylabel("Error count")
        ax.set_ylim([0, 100])
        plt.title(f"reg: {reg+1}")
        labels = [f"{fun_start}-{fun_end}"
                  for (fun_start, fun_end) in bin_ranges]
        ax.bar(labels, bins, color="tab:blue",
               edgecolor="black", align='center', width=1)
        save_path = "/".join(path[:-1])
        fig.savefig(f"{save_path}/delays_x{reg+1}.png",bbox_inches="tight")
        plt.clf()

    ax = fig.add_subplot(1, 1, 1)
    ax.set_xlabel("Registers")
    ax.set_ylabel("Error rate")
    rates = [error_rate for _, error_rate in hist_data]
    labels = [f"x{register}" for register, _ in hist_data]
    ax.bar(labels, rates, color="tab:blue",
           edgecolor="black", align='center', width=1)
    save_path = "/".join(path[:-1])
    fig.savefig(f"{save_path}/histogram.png", bbox_inches="tight")
    

    register_results_tally = map(lambda x: (x[0] + 1, sum(x[1]), len(x[1])),
                                 enumerate(results_by_register))
    faulty_registers = filter(lambda x: x[0] in critical_registers,
                              copy.deepcopy(register_results_tally))

    critical_run_count = sum(list(map(lambda x: x[2],
                                      copy.deepcopy(faulty_registers))))
    critical_tally = map(lambda x: x[1], copy.deepcopy(faulty_registers))
    critical_tally = sum(list(critical_tally))
    error_rate = round(1 - critical_tally / critical_run_count, 4)
    print(f"Error rate(critical): {error_rate}")

    total_tally = map(lambda x: x[1], copy.deepcopy(register_results_tally))
    total_tally = sum(list(total_tally))
    error_rate = round(1 - total_tally/run_count, 4)
    print(f"Error rate(total): {error_rate}")

    hist_data = list(map(lambda x: (x[0], 1 - x[1] / x[2]),
                         copy.deepcopy(faulty_registers)))

    
    
    

            