import sys

# Path to HDLRegression:
sys.path.append('../extern/hdlregression')
from hdlregression import HDLRegression

def init(hr):
    # Add RTL code for AXI-Stream UART
    hr.add_files("../src/rtl/*.vhd", "work")

    # Add testbench code for AXI-Stream UART
    hr.add_files("../src/tb/axistream_uart_simple_tb.vhd", "work")

def main():
    hr = HDLRegression()
    init(hr)

    hr.set_result_check_string("PASS")
    hr.start()
    return


if __name__ == '__main__':
    sys.exit(main())
