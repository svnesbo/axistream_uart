library ieee;
use ieee.std_logic_1164.all;

entity baud_gen is
  generic (
    GC_BAUDRATE : natural;
    GC_CLK_FREQ : natural;
    GC_BAUD_RX  : boolean  -- If baud pulse is for receive (midpoint) or transmit
    );
  port (
    clk        : in  std_logic;
    rst        : in  std_logic;
    enable     : in  std_logic;
    baud_pulse : out std_logic);
    
end entity baud_gen;

architecture rtl of baud_gen is
  
begin

  p_baud_gen: process (clk) is
  begin
    if rising_edge(clk) then

      -- Baud generator logic should be implemented here.
      -- This is how the module should work:
      -- * A counter runs freely when the enable signal is active
      -- * The counter wraps around at a value depending on the generic
      --   parameters, giving it a period corresponding to the desired baud period
      -- * The counter stops when enable is not active
      -- * The counter restarts when enable goes from inactive to active
      -- * The output baud_pulse is pulsed for one clock cycle when:
      --   GC_BAUD_RX=false: At the end of a baud period (when the counter wraps around)
      --   GC_BAUD_RX=true:  At the middle of a baud period (counter has middle
      --   value))

      if rst = '1' then
        -- Reset registers here
      end if;
    end if;

  end process p_baud_gen;

end architecture rtl;
