-- Generic ALU
-- author: zekemyapp
-- December, 2020

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        A,B : in std_logic_vector (7 downto 0);  -- Input registers A and B
        cin : in std_logic;                      -- Carry in
        opt : in std_logic_vector (2 downto 0);      -- Operational Code
        reg_out : out std_logic_vector (7 downto 0)  -- Output register
    );
end ALU;

architecture behav of ALU is
-- ALU function codes
constant OP_NOP: STD_LOGIC_VECTOR(2 downto 0) := "000";    -- no operation
constant OP_ADD: STD_LOGIC_VECTOR(2 downto 0) := "001";    -- no operation
constant OP_XOR: STD_LOGIC_VECTOR(2 downto 0) := "010";    -- no operation
constant OP_AND: STD_LOGIC_VECTOR(2 downto 0) := "011";    -- no operation
constant OP_OR : STD_LOGIC_VECTOR(2 downto 0) := "100";    -- no operation
constant OP_RSB: STD_LOGIC_VECTOR(2 downto 0) := "101";    -- no operation


begin
    process(A, B, cin, opt)
    begin
        case opt is
            when OP_ADD => -- Add
                reg_out <= std_logic_vector(unsigned(A) + unsigned(B));
            when OP_XOR => -- XOR
                reg_out <= A xor B;
            when OP_AND => -- AND
                reg_out <= A and B;
            when OP_OR  => -- OR
                reg_out <= A or B;
            when OP_RSB => -- Shift Right
                reg_out <= '0' & A(7 downto 1);
            when others =>
                reg_out <= "ZZZZZZZZ";
        end case;
    end process;
end behav;


------
-- Test bench
------
library ieee;
use ieee.std_logic_1164.all;

entity ALU_TB is
end ALU_TB;

architecture behav of ALU_TB is
    signal A : std_logic_vector (7 downto 0) := "00000101";
    signal B : std_logic_vector (7 downto 0) := "00000011";
    signal cin : std_logic := '0';
    signal opt : std_logic_vector (2 downto 0) := "ZZZ";
    signal reg_out : std_logic_vector (7 downto 0);
    constant clk : time := 1 ns;

    begin
        ALU0: entity work.ALU port map (A, B, cin, opt, reg_out);
        process
        begin
            wait for clk;
            opt <= "000";
            wait for clk;
            opt <= "001";
            wait for clk;
            opt <= "010";
            wait for clk;
            opt <= "011";
            wait for clk;
            opt <= "100";
            wait for clk;
            assert false report "EoT" severity note;
            wait;
        end process;
end behav;