library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port (
        A,B : in std_logic_vector (7 downto 0);  -- Input registers A and B
        opt : in std_logic_vector (2 downto 0);      -- Operational Code
        reg_out : out std_logic_vector (7 downto 0);  -- Output register
        clk : in STD_LOGIC
    );
end CPU;

architecture behav of CPU is

--
component ALU
    port (
        A,B : in std_logic_vector (7 downto 0);  -- Input registers A and B
        cin : in std_logic;                      -- Carry in
        opt : in std_logic_vector (2 downto 0);      -- Operational Code
        reg_out : out std_logic_vector (7 downto 0)  -- Output register
    );
end component;

--
component GENERIC_REG
    port(
      clk : in STD_LOGIC;
      sbit: in STD_LOGIC;
      din : in STD_LOGIC_VECTOR(7 downto 0); 
      dout: out STD_LOGIC_VECTOR(7 downto 0)
      );
end component;

--
signal regx_out : std_logic_vector (7 downto 0) := "ZZZZZZZZ";
signal regy_out : std_logic_vector (7 downto 0) := "ZZZZZZZZ";
signal alu_out : std_logic_vector (7 downto 0) := "ZZZZZZZZ";
signal set_reg : std_logic := '1';
signal cin : std_logic := '1';

begin
    alu1:ALU port map (regx_out, regy_out, cin, opt, alu_out);
    reg_a:GENERIC_REG port map (clk, set_reg, alu_out, reg_out);
    reg_x:GENERIC_REG port map (clk, set_reg, A, regx_out);
    reg_y:GENERIC_REG port map (clk, set_reg, B, regy_out);

end behav;


------
-- Test bench
------
library ieee;
use ieee.std_logic_1164.all;

entity CPU_TB is
end CPU_TB;

architecture behav of CPU_TB is
    signal A : std_logic_vector (7 downto 0) := "00000101";
    signal B : std_logic_vector (7 downto 0) := "00000011";
    signal opt : std_logic_vector (2 downto 0) := "ZZZ";
    signal reg_out : std_logic_vector (7 downto 0);
    signal sig_clk : std_logic := '0';
    constant clk : time := 1 ns;

    signal enable : std_logic := '1';
    signal rw : std_logic := '1';
    signal addrs : std_logic_vector (7 downto 0) := "00000000";

    begin
        CPU0: entity work.CPU port map (A, B, opt, reg_out, sig_clk);
        RAM0: entity work.RAM port map (sig_clk, enable, rw, addrs, reg_out);

        process
        begin
            wait for clk;
            opt <= "000";
            sig_clk <= not sig_clk;
            wait for clk;
            sig_clk <= not sig_clk;
            wait for clk;
            opt <= "001";
            sig_clk <= not sig_clk;
            wait for clk;
            sig_clk <= not sig_clk;
            wait for clk;
            opt <= "010";
            sig_clk <= not sig_clk;
            wait for clk;
            sig_clk <= not sig_clk;
            wait for clk;
            opt <= "011";
            sig_clk <= not sig_clk;
            wait for clk;
            sig_clk <= not sig_clk;
            wait for clk;
            opt <= "100";
            sig_clk <= not sig_clk;
            wait for clk;
            sig_clk <= not sig_clk;
            wait for clk;
            assert false report "EoT" severity note;
            wait;
        end process;
end behav;