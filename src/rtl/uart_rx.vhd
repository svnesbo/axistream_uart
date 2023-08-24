library ieee;
use ieee.std_logic_1164.all;

entity uart_rx is
  generic (
    GC_BAUDRATE : natural;
    GC_CLK_FREQ : natural);
  port (
    clk                   : in  std_logic;
    rst                   : in  std_logic;
    rxd                   : in  std_logic;
    m_axis_receive_tdata  : out std_logic_vector(7 downto 0);
    m_axis_receive_tvalid : out std_logic;
    m_axis_receive_tready : in  std_logic);
end entity uart_rx;

architecture rtl of uart_rx is

  signal baud_gen_enable : std_logic;
  signal baud_pulse      : std_logic;

  type t_uart_rx_fsm is (ST_IDLE, ST_RECEIVE_START_BIT, ST_RECEIVE_DATA, ST_RECEIVE_STOP_BIT, ST_ERROR);
  signal fsm_state : t_uart_rx_fsm;

begin

  inst_baud_gen: entity work.baud_gen
    generic map (
      GC_BAUDRATE => GC_BAUDRATE,
      GC_CLK_FREQ => GC_CLK_FREQ,
      GC_BAUD_RX  => true)
    port map (
      clk        => clk,
      rst        => rst,
      enable     => baud_gen_enable,
      baud_pulse => baud_pulse);


  p_uart_rx_fsm : process (clk) is
  begin
    if rising_edge(clk) then

      case fsm_state is
        when ST_IDLE =>
          ;
          -- * Detect falling edge on rxd in this state
          -- * Start the baud generator on rxd falling edge
          -- * Go to the receive start bit state

        when ST_RECEIVE_START_BIT =>
          ;
          -- * Sample the start bit when we get the baud pulse
          -- * Verify that start bit has the right value,
          --   and proceed to the receive data state

        when ST_RECEIVE_DATA =>
          ;
          -- * Clock in 8 data bits at the baud pulse
          -- * Proceed to receive stop bit state after
          --   all 8 data bits have been received

        when ST_RECEIVE_STOP_BIT =>
          ;
          -- * Receive stop bit and verify value
          -- * Stop bit OK:
          --   * Output the data byte on the AXI-Stream interface
          -- * Stop bit not OK:
          --   * Go to the error state - don't output data

        when ST_ERROR =>
          -- This state can be used to indicate an error (if an error output
          -- is added at the port). For now, it sufficient to just proceed to
          -- IDLE after detecting an error.
          fsm_state <= ST_IDLE;

      end case;

      if rst = '1' then
        -- Reset
      end if;
    end if;
  end process p_uart_rx_fsm;

end architecture rtl;
