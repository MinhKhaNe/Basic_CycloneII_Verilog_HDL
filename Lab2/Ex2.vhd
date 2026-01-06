library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lab2_ex2 is
    Port (
        SW       : in  std_logic_vector(17 downto 0);
        CLOCK_50 : in  std_logic;
        LEDG     : out std_logic_vector(7 downto 0);
        LEDR     : out std_logic_vector(17 downto 0)
    );
end lab2_ex2;
q
architecture Behavioral of lab2_ex2 is
    component dff_sync
        Port (
            clk   : in  std_logic;
            rst_n : in  std_logic;
            din   : in  std_logic_vector(1 downto 0);
            dout  : out std_logic_vector(1 downto 0)
        );
    end component;
begin
    LEDR <= SW;

    DUT : dff_sync
        port map (
            clk   => CLOCK_50,
            rst_n => SW(2),
            din   => SW(1 downto 0),
            dout  => LEDG(1 downto 0)
        );
end Behavioral;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dff_sync is
    Port (
        clk   : in  std_logic;
        rst_n : in  std_logic;
        din   : in  std_logic_vector(1 downto 0);
        dout  : out std_logic_vector(1 downto 0)
    );
end dff_sync;

architecture Behavioral of dff_sync is
    signal q : std_logic_vector(1 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                q <= (others => '0');
            else
                q <= din;
            end if;
        end if;
    end process;

    dout <= q;
end Behavioral;
