library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab2_ex9 is
    Port (
        SW       : in  STD_LOGIC_VECTOR(17 downto 0);
        CLOCK_50 : in  STD_LOGIC;
        LEDG     : out STD_LOGIC_VECTOR(7 downto 0);
        LEDR     : out STD_LOGIC_VECTOR(17 downto 0)
    );
end Lab2_ex9;

architecture Structural of Lab2_ex9 is

    signal count    : unsigned(25 downto 0) := (others => '0');
    signal slow_clk : STD_LOGIC := '0';

    component left_shift
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            in_value : in  STD_LOGIC;
            enable   : in  STD_LOGIC;
            Q        : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin

    LEDR <= SW;

    process (CLOCK_50, SW)
    begin
        if SW(0) = '1' then
            count    <= (others => '0');
            slow_clk <= '0';
        elsif rising_edge(CLOCK_50) then
            if count = 25_000_000 - 1 then  
                count    <= (others => '0');
                slow_clk <= not slow_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    DUT: left_shift
        port map (
            clk      => slow_clk,
            rst      => SW(0),
            in_value => SW(1),
            enable   => SW(2),
            Q        => LEDG(3 downto 0)
        );

end Structural;
