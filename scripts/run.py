import sys

# Path to HDLRegression:
sys.path.append('../extern/hdlregression')
from hdlregression import HDLRegression

def init(hr):
    # UVVM utility library
    hr.add_files("../extern/UVVM/uvvm_util/src/*.vhd", "uvvm_util")

    # Todo: Add files for UVVM VVC framework
    # hr.add_files(...)

    # Add scoreboard VIP (used by some other VIPs)
    hr.add_files("../extern/UVVM/bitvis_vip_scoreboard/src/*.vhd", "bitvis_vip_scoreboard")

    # AXI-Stream VIP
    hr.add_files("../extern/UVVM/bitvis_vip_axistream/src/*.vhd",                "bitvis_vip_axistream")
    hr.add_files("../extern/UVVM/uvvm_vvc_framework/src_target_dependent/*.vhd", "bitvis_vip_axistream")

    # Todo: Add files for other VIPs used in the testbench

    # Todo: Add RTL code for AXI-Stream UART

    # Todo: Add testbench code for AXI-Stream UART


def main():
    hr = HDLRegression()
    init(hr)

    hr.start()
    return


if __name__ == '__main__':
    sys.exit(main())
