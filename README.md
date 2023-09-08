# axistream_uart

This repo contains a simple UART with AXI-Stream interface written in VHDL, which is intended for educational purposes. It can be used as a very quick learning example for VHDL and verification with UVVM + HDLregression. There are several exercises and solutions that are structured in different branches (more details under *Coding exercise* below).

The RTL and testbench code is gradually added in the *solution* branches. But the **main** branch contains all of the finished code and can probably be useful as a template or starting point for a module or project that uses UVVM+HDLregression.
But note that the UART module has not been tested in hardware. It will probably work, but use at your own risk. It is also very rudimentary with configuration options (e.g. it is hardcoded for 8N1).

# Getting started

## Prerequisites

Running the code in this repo requires:
- An installation of Modelsim. A good choice is the Intel Modelsim Starter edition, which can be downloaded for free from Intel's website.
  - The `vsim` command should be in your PATH
- A Python 3 installation
  - There should not be any dependencies or requirements

## Cloning the repo

Clone this repo: `git clone <repo-url>`. URLs for HTTPS/SSH are listed under `Code` on the GitHub frontpage for this project.

The code in this repo relies on two submodules: UVVM and HDLregression. These can be initialized by running:
```
cd axistream_uart            # cd into the project
git submodule init --update  # Initialize git submodules
```

## Running the simulation

Modelsim (and other simulators) generate several log and other output files in the working directory. It is recommended to run the scripts from the empty `run` directory. A gitignore file in this directory prevents these files from showing up as untracked in the git status.

From the root of the repo:
```
cd run
python ../scripts/run.py
```

This will compile and run every testbench in this project - when it is run the first time. HDLregression will not re-run tests unless there are changes, or unless it is instructed to do so.

Running the script with `-h` will print a help menu. Some interesting arguments for the scripts are:
`-ltc`: List test cases
`-g`: Run simulation in GUI mode (i.e. Modelsim GUI will open)
`-v`: Verbose output
`-tc <testcase name>`: Run a specific test case


# Coding exercise

## Part 1 - Finish the RTL code for the UART

| [Part 1](https://github.com/svnesbo/axistream_uart/tree/part1) | [Part 1 - Solution](https://github.com/svnesbo/axistream_uart/tree/part1_solution) |


## Part 2 - Build and simulate using HDLregression

| [Part 2](https://github.com/svnesbo/axistream_uart/tree/part2) | [Part 2 - Solution](https://github.com/svnesbo/axistream_uart/tree/part2_solution) |


## Part 3 - Write a UVVM-based testbench for the UART

| [Part 3](https://github.com/svnesbo/axistream_uart/tree/part3) | [Part 3 - Solution](https://github.com/svnesbo/axistream_uart/tree/part3_solution) |


## Part 4 - Extend the UVVM-based testbench with individual test cases

| [Part 4](https://github.com/svnesbo/axistream_uart/tree/part4) | [Part 4 - Solution](https://github.com/svnesbo/axistream_uart/tree/part4_solution) |

Not done yet :)
