library IEEE;
use IEEE.std_logic_1164.all;
 
-- 8 bit register
entity GENERIC_REG is
  port(
    clk : in STD_LOGIC;
    sbit: in STD_LOGIC;
    din : in STD_LOGIC_VECTOR(7 downto 0); 
    dout: out STD_LOGIC_VECTOR(7 downto 0)
    );
end GENERIC_REG;
 
architecture bhv of GENERIC_REG is
signal reg: STD_LOGIC_VECTOR(7 downto 0);
begin
  process(clk)
    begin
      if (clk'event and clk = '1') then 
        if sbit = '1' then
          reg <= din;
        else
          reg <= reg;
        end if;
      end if;  
  end process;
  dout <= reg;
end bhv;


------
-- Test bench
------
library ieee;
use ieee.std_logic_1164.all;

entity REG_TB is
end REG_TB;

architecture behav of REG_TB is
  signal clk_sig : std_logic;
  signal sbit : std_logic := '0';
  signal din  : STD_LOGIC_VECTOR(7 downto 0); 
  signal dout : STD_LOGIC_VECTOR(7 downto 0);

  constant clk_t : time := 1 ns;

begin

  reg0: entity work.GENERIC_REG port map (clk_sig, sbit, din, dout);
  clock : process
  begin
      for i in 1 to 20 loop
          clk_sig <= '1';
          wait for clk_t/4;
          clk_sig <= '0';
          wait for clk_t/4;
      end loop;

      assert false report "EoT" severity note;
      wait;
  end process;

  process
    begin
        wait for clk_t;
        sbit <= '1';
        wait for clk_t;
        din <= "00000001";
        wait for clk_t;
        din <= "00000010";
        wait for clk_t;
        din <= "00000011";
        wait for clk_t;
        wait;
    end process;

end behav;