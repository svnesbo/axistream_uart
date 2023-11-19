import sys

# Path to HDLRegression:
sys.path.append('../extern/hdlregression')
from hdlregression import HDLRegression

def init(hr):
    # The command below can be used to compile all of UVVM, it is not necessary
    # to compile individual libraries as we have done below (it is a bit faster
    # to online compile the libraries that are actually used though).

    # hr.compile_uvvm("../extern/UVVM/")

    # UVVM
    hr.add_files("../extern/UVVM/uvvm_util/src/*.vhd",          "uvvm_util")
    hr.add_files("../extern/UVVM/uvvm_vvc_framework/src/*.vhd", "uvvm_vvc_framework")

    hr.add_files("../extern/UVVM/bitvis_vip_scoreboard/src/*.vhd", "bitvis_vip_scoreboard")

    # AXI-Stream VIP
    hr.add_files("../extern/UVVM/bitvis_vip_axistream/src/*.vhd",                "bitvis_vip_axistream")
    hr.add_files("../extern/UVVM/uvvm_vvc_framework/src_target_dependent/*.vhd", "bitvis_vip_axistream")

    # UART VIP
    hr.add_files("../extern/UVVM/bitvis_vip_uart/src/*.vhd",                "bitvis_vip_uart")
    hr.add_files("../extern/UVVM/uvvm_vvc_framework/src_target_dependent/*.vhd", "bitvis_vip_uart")

    # Clock Generator VVC
    hr.add_files("../extern/UVVM/bitvis_vip_clock_generator/src/*.vhd",          "bitvis_vip_clock_generator")
    hr.add_files("../extern/UVVM/uvvm_vvc_framework/src_target_dependent/*.vhd", "bitvis_vip_clock_generator")

    # Add RTL code for AXI-Stream UART
    hr.add_files("../src/rtl/*.vhd", "work")

    # Add testbench code for AXI-Stream UART
    hr.add_files("../src/tb/axistream_uart_uvvm_tb.vhd", "work")
    hr.add_files("../src/tb/axistream_uart_uvvm_th.vhd", "work")

def main():
    hr = HDLRegression()
    init(hr)

    hr.start()
    return


if __name__ == '__main__':
    sys.exit(main())
