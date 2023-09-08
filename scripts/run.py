import sys

# Path to HDLRegression:
sys.path.append('../extern/hdlregression')
from hdlregression import HDLRegression

def init(hr):
    # Add RTL code for baud gen module
    hr.add_files("../src/rtl/baud_gen.vhd", "work")

    # Todo:
    # - Add remaining .vhd files for RTL code and testbench


def main():
    hr = HDLRegression()
    init(hr)

    hr.set_result_check_string("PASS")
    hr.start()
    return


if __name__ == '__main__':
    sys.exit(main())
