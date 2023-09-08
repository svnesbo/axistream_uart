--- File: axistream_uart_tb1.vhd
--- Description: Simple testbench for for axistream_uart
--- hdlregression:tb

library ieee;
use ieee.std_logic_1164.all;


entity axistream_uart_simple_tb is
end entity axistream_uart_simple_tb;

architecture tb of axistream_uart_simple_tb is

  constant C_CLK_FREQ    : natural := 50000000;  -- 50 MHz
  constant C_CLK_PERIOD  : time    := 1 sec / C_CLK_FREQ;
  constant C_BAUDRATE    : natural := 115200;
  constant C_BAUD_PERIOD : time    := 1 sec / C_BAUDRATE;


  signal clk     : std_logic := '0';
  signal rst     : std_logic := '0';
  signal rxd_dut : std_logic;
  signal txd_dut : std_logic;
  signal rxd_tb  : std_logic;
  signal txd_tb  : std_logic := '1';

  signal axis_transmit_tdata  : std_logic_vector(7 downto 0) := (others => '0');
  signal axis_transmit_tvalid : std_logic                    := '0';
  signal axis_transmit_tready : std_logic;

  signal axis_receive_tdata  : std_logic_vector(7 downto 0);
  signal axis_receive_tvalid : std_logic;
  signal axis_receive_tready : std_logic := '0';

  signal start_bit_from_dut    : std_logic;
  signal stop_bit_from_dut     : std_logic;
  signal receive_data_from_dut : std_logic_vector(7 downto 0);

begin

  rxd_dut <= txd_tb;
  rxd_tb  <= txd_dut;

  u_dut : entity work.axistream_uart
    generic map (
      GC_BAUDRATE => C_BAUDRATE,
      GC_CLK_FREQ => C_CLK_FREQ)
    port map (
      clk                    => clk,
      rst                    => rst,
      rxd                    => rxd_dut,
      txd                    => txd_dut,
      s_axis_transmit_tdata  => axis_transmit_tdata,
      s_axis_transmit_tvalid => axis_transmit_tvalid,
      s_axis_transmit_tready => axis_transmit_tready,
      m_axis_receive_tdata   => axis_receive_tdata,
      m_axis_receive_tvalid  => axis_receive_tvalid,
      m_axis_receive_tready  => axis_receive_tready);

  p_clk : process is
  begin
    wait for C_CLK_PERIOD/2;
    clk <= not clk;
  end process p_clk;

  p_stimuli : process is
    constant C_DUT_TX_TEST_DATA : std_logic_vector(7 downto 0) := x"AF";
    constant C_DUT_RX_TEST_DATA : std_logic_vector(9 downto 0) := "1" & x"BC" & "0";

  begin

    -- Reset
    wait until rising_edge(clk); rst <= '1';
    wait until rising_edge(clk); rst <= '0';

    -- 2 cycle delay after reset
    wait until rising_edge(clk); wait until rising_edge(clk);

    ---------------------------------------------------------------------------
    -- Test transmit from UART DUT
    ---------------------------------------------------------------------------

    axis_transmit_tdata  <= C_DUT_TX_TEST_DATA;
    axis_transmit_tvalid <= '1';

    -- AXI-Stream handshake
    wait until axis_transmit_tready = '1' and axis_transmit_tvalid = '1';
    wait until rising_edge(clk);

    axis_transmit_tvalid <= '0';

    -- Receive start bit
    wait until rxd_tb = '0';
    wait for C_BAUD_PERIOD/2;
    start_bit_from_dut <= rxd_tb;

    for bit_num in 0 to 7 loop
      wait for C_BAUD_PERIOD;
      receive_data_from_dut(bit_num) <= rxd_tb;
    end loop;

    wait for C_BAUD_PERIOD;
    stop_bit_from_dut <= rxd_tb;

    wait for C_BAUD_PERIOD;
    -- rxd_tb should be high (inactive) now

    ---------------------------------------------------------------------------
    -- Test receive with UART DUT
    ---------------------------------------------------------------------------

    for bit_num in 0 to 9 loop
      txd_tb <= C_DUT_RX_TEST_DATA(bit_num);
      wait for C_BAUD_PERIOD;
    end loop;

    wait for 1 us;

    -- In run.py we configured HDLregression to look for
    -- this string to determine if a testbench passed or not
    report "PASS";

    std.env.stop;
    wait;

  end process p_stimuli;

end architecture tb;
