-- File: axistream_uart_uvvm_tb.vhd
-- Description: Testbench for for axistream_uart
-- hdlregression:tb

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library uvvm_vvc_framework;
use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;

library bitvis_vip_axistream;
context bitvis_vip_axistream.vvc_context;

library bitvis_vip_uart;
context bitvis_vip_uart.vvc_context;

library bitvis_vip_clock_generator;
context bitvis_vip_clock_generator.vvc_context;

entity axistream_uart_uvvm_tb is
  generic (
    GC_TESTCASE              : string);
end entity axistream_uart_uvvm_tb;

architecture tb of axistream_uart_uvvm_tb is

  constant C_SCOPE      : string := "AXISTREAM_UART_UVVM_TB";
  constant C_CLK_PERIOD : time   := 20 ns;

  -- VVC idx
  constant C_VVC_MASTER_IDX  : natural := 0;

  constant C_AXIS_VVC_TRANSMIT_IDX : natural := 0;
  constant C_AXIS_VVC_RECEIVE_IDX  : natural := 1;
  constant C_UART_VVC_IDX          : natural := 0;

  --------------------------------------------------------------------------------
  -- Signal declarations
  --------------------------------------------------------------------------------
  signal clk       : std_logic := '0';
  signal arst      : std_logic := '0';

begin

  -----------------------------------------------------------------------------
  -- Instantiate test harness
  -----------------------------------------------------------------------------
  i_test_harness : entity work.axistream_uart_uvvm_th
    generic map (
      GC_AXIS_VVC_TRANSMIT_IDX => C_AXIS_VVC_TRANSMIT_IDX,
      GC_AXIS_VVC_RECEIVE_IDX  => C_AXIS_VVC_RECEIVE_IDX,
      GC_UART_VVC_IDX          => C_UART_VVC_IDX)
    port map (
      arst => arst
      );

  ------------------------------------------------
  -- Sequencer process
  ------------------------------------------------
  p_sequencer : process is

    -- BFM config
    variable v_axistream_bfm_config : t_axistream_bfm_config := C_AXISTREAM_BFM_CONFIG_DEFAULT;
    variable v_uart_bfm_config      : t_uart_bfm_config      := C_UART_BFM_CONFIG_DEFAULT;

    procedure test_case_uart_transmit (void : t_void) is
      constant data : t_slv_array(0 to 3)(7 downto 0) := (x"1A", x"FC", x"37", x"E2");
    begin
      axistream_transmit(AXISTREAM_VVCT, C_AXIS_VVC_TRANSMIT_IDX, data, "Transmit data with UART DUT");

      for byte_num in 0 to 3 loop
        uart_expect(UART_VVCT, C_UART_VVC_IDX, RX, data(byte_num), "Receive same data with UART VVC");
      end loop;
      
      await_completion(AXISTREAM_VVCT, C_AXIS_VVC_TRANSMIT_IDX, 1000 us, C_SCOPE);
      await_completion(UART_VVCT, C_UART_VVC_IDX, RX, 4*1000 us, C_SCOPE);
    end procedure test_case_uart_transmit;

    procedure test_case_uart_receive (void : t_void) is
      constant data : t_slv_array(0 to 3)(7 downto 0) := (x"1A", x"FC", x"37", x"E2");
    begin
      for byte_num in 0 to 3 loop
        uart_transmit(UART_VVCT, C_UART_VVC_IDX, TX, data(byte_num), "Transmit data with UART VVC");
      end loop;

      axistream_expect(AXISTREAM_VVCT, C_AXIS_VVC_RECEIVE_IDX, data, "Receive same data with UART DUT");
      
      await_completion(AXISTREAM_VVCT, C_AXIS_VVC_RECEIVE_IDX, 1000 us, C_SCOPE);
      await_completion(UART_VVCT, C_UART_VVC_IDX, TX, 4*1000 us, C_SCOPE);
      
    end procedure test_case_uart_receive;

    procedure test_case_uart_simultaneous_transmit_receive (void : t_void) is
      constant data_tx : t_slv_array(0 to 3)(7 downto 0) := (x"1A", x"FC", x"37", x"E2");
      constant data_rx : t_slv_array(0 to 3)(7 downto 0) := (x"DE", x"13", x"9C", x"7A");
    begin
      axistream_transmit(AXISTREAM_VVCT, C_AXIS_VVC_TRANSMIT_IDX, data_tx, "Transmit data with UART DUT");
      axistream_expect(AXISTREAM_VVCT, C_AXIS_VVC_RECEIVE_IDX, data_rx, "Receive data with UART DUT");
      
      for byte_num in 0 to 3 loop
        uart_transmit(UART_VVCT, C_UART_VVC_IDX, TX, data_rx(byte_num), "Transmit data with UART VVC");
        uart_expect(UART_VVCT, C_UART_VVC_IDX, RX, data_tx(byte_num), "Receive data with UART VVC");
      end loop;

      await_completion(AXISTREAM_VVCT, C_AXIS_VVC_TRANSMIT_IDX, 1000 us, C_SCOPE);
      await_completion(AXISTREAM_VVCT, C_AXIS_VVC_RECEIVE_IDX, 1000 us, C_SCOPE);
      await_completion(UART_VVCT, C_UART_VVC_IDX, RX, 4*1000 us, C_SCOPE);
      await_completion(UART_VVCT, C_UART_VVC_IDX, TX, 4*1000 us, C_SCOPE);
      
    end procedure test_case_uart_simultaneous_transmit_receive;

  begin

    -- Create separate log files for each test case
    set_log_file_name(GC_TESTCASE & "_Log.txt");
    set_alert_file_name(GC_TESTCASE & "_Alert.txt");

    -- Print the configuration to the log
    report_global_ctrl(VOID);
    report_msg_id_panel(VOID);

    enable_log_msg(ALL_MESSAGES);

    -----------------------------------------------------------------------------
    -- Wait for UVVM to finish initialization
    -----------------------------------------------------------------------------
    await_uvvm_initialization(VOID);

    start_clock(CLOCK_GENERATOR_VVCT, 0, "Start clock generator");

    gen_pulse(arst, '1', 10 * C_CLK_PERIOD, "Pulsed reset-signal - active for 10 clock periods");
    wait for C_CLK_PERIOD * 10;

    -----------------------------------------------------------------------------
    -- Set UVVM verbosity level
    -----------------------------------------------------------------------------

    -- All messages can be enabled if you want more detailed logs for debugging.
    disable_log_msg(ALL_MESSAGES);
    enable_log_msg(ID_SEQUENCER);
    enable_log_msg(ID_LOG_HDR);

    -----------------------------------------------------------------------------
    -- AXI-Stream VVC config
    -----------------------------------------------------------------------------
    v_axistream_bfm_config.check_packet_length := false; -- Disable tlast
    v_axistream_bfm_config.clock_period        := C_CLK_PERIOD;
    v_axistream_bfm_config.ready_default_value := '1';
    v_axistream_bfm_config.max_wait_cycles     := 1000000;

    shared_axistream_vvc_config(C_AXIS_VVC_TRANSMIT_IDX).bfm_config := v_axistream_bfm_config;
    shared_axistream_vvc_config(C_AXIS_VVC_RECEIVE_IDX).bfm_config  := v_axistream_bfm_config;

    -----------------------------------------------------------------------------
    -- UART VVC config
    -----------------------------------------------------------------------------
    v_uart_bfm_config.parity                              := PARITY_NONE;
    v_uart_bfm_config.bit_time                            := (1 sec) / 115200;
    shared_uart_vvc_config(RX, C_UART_VVC_IDX).bfm_config := v_uart_bfm_config;
    shared_uart_vvc_config(TX, C_UART_VVC_IDX).bfm_config := v_uart_bfm_config;

    -----------------------------------------------------------------------------
    -- Test sequence
    -----------------------------------------------------------------------------
    log(ID_SEQUENCER, "Running testcase: " & GC_TESTCASE, C_SCOPE);

    if GC_TESTCASE = "TC_UART_TRANSMIT" then
      test_case_uart_transmit(VOID);
    elsif GC_TESTCASE = "TC_UART_RECEIVE" then
      test_case_uart_receive(VOID);
    elsif GC_TESTCASE = "TC_UART_SIMULTANEOUS_TRANSMIT_RECEIVE" then
      test_case_uart_simultaneous_transmit_receive(VOID);
    elsif GC_TESTCASE = "TC_FAILING_TEST" then
      tb_failure("This test failed..");
    end if;

    -----------------------------------------------------------------------------
    -- Ending the simulation
    -----------------------------------------------------------------------------
    wait for 1000 ns;                   -- Allow some time for completion
    report_alert_counters(FINAL);       -- Report final counters and print conclusion for simulation (Success/Fail)
    log(ID_LOG_HDR, "SIMULATION COMPLETED", C_SCOPE);

    -- Finish the simulation
    std.env.stop;
    wait;

  end process p_sequencer;

end architecture tb;
