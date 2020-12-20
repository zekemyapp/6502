library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk : in std_logic;
        enable : in std_logic;
        rw : in std_logic;
        addrs: in std_logic_vector (7 downto 0);
        data: inout std_logic_vector (7 downto 0)
    );
end RAM;

architecture behav of RAM is
    type ram_t is array (0 to 255) of std_logic_vector(7 downto 0);
    
    signal tmp_ram: ram_t;

begin
    process (clk)
    begin
        if (clk = '1' and clk'event) then
            if enable = '1' then
                if rw = '1' then
                    tmp_ram(to_integer(unsigned(addrs))) <= data;
                elsif rw = '0' then
                    data <= tmp_ram(to_integer(unsigned(addrs)));
                else
                    data <= (data'range => 'Z');
                end if;
            end if;
        end if;
    end process;
end behav;


--------------
--------------
library ieee;
use ieee.std_logic_1164.all;

entity RAM_TB is
end RAM_TB;

architecture behav of RAM_TB is
    signal clk : std_logic;
    signal enable : std_logic;
    signal rw : std_logic;
    signal addrs: std_logic_vector (7 downto 0);
    signal data: std_logic_vector (7 downto 0);
    constant clk_t : time := 1 ns;
begin

    RAM0: entity work.RAM port map (clk,enable,rw,addrs,data);

    clock : process
    begin
        for i in 1 to 20 loop
            clk <= '1';
            wait for clk_t/4;
            clk <= '0';
            wait for clk_t/4;
        end loop;

        assert false report "EoT" severity note;
        wait;
    end process;

    process
    begin
        wait for clk_t;
        enable <= '1';
        wait for clk_t;
        rw <= '1';
        addrs <= "00000011";
        data <= "00001001";
        wait for clk_t;
        rw <= '0';
        addrs <= "00000001";
        data <= "ZZZZZZZZ";
        wait for clk_t;
        addrs <= "00000011";
        data <= "ZZZZZZZZ";
        wait for clk_t;
        wait;


    end process;

end behav;