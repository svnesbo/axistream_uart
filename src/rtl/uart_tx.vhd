library ieee;
use ieee.std_logic_1164.all;


entity uart_tx is

  generic (
    GC_BAUDRATE : natural;
    GC_CLK_FREQ : natural);
  port (
    clk                    : in  std_logic;
    rst                    : in  std_logic;
    txd                    : out std_logic;
    s_axis_transmit_tdata  : in  std_logic_vector(7 downto 0);
    s_axis_transmit_tvalid : in  std_logic;
    s_axis_transmit_tready : out std_logic);

end entity uart_tx;

architecture rtl of uart_tx is

  type t_uart_tx_fsm is (ST_IDLE, ST_TRANSMIT);
  signal fsm_state : t_uart_tx_fsm;

begin

  inst_baud_gen : entity work.baud_gen
    generic map (
      GC_BAUDRATE => GC_BAUDRATE,
      GC_CLK_FREQ => GC_CLK_FREQ,
      GC_BAUD_RX  => false)
    port map (
      clk        => clk,
      rst        => rst,
      enable     => baud_gen_enable,
      baud_pulse => baud_pulse);

  p_uart_tx_fsm : process (clk) is
  begin
    if rising_edge(clk) then

      case fsm_state is
        when ST_IDLE =>
          -- Wait for data on s_axis
          -- Perform AXI-Stream handshake
          -- Setup stop bit + 8 data bits + start bit
          -- Start transmit

        when ST_TRANSMIT =>
          -- At baud_pulse:
          -- Push out one bit at a time on txd

      end case;

      if rst = '1' then
        -- Reset
      end if;
    end if;
  end process p_uart_tx_fsm;


end architecture rtl;
