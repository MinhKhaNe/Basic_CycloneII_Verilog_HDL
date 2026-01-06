library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab2_ex11 is
    Port (
        SW       : in  STD_LOGIC_VECTOR(17 downto 0);
        CLOCK_50 : in  STD_LOGIC;
        LEDG     : out STD_LOGIC_VECTOR(7 downto 0);
        LEDR     : out STD_LOGIC_VECTOR(17 downto 0)
    );
end Lab2_ex11;

architecture Behavioral of Lab2_ex11 is

    signal count    : unsigned(25 downto 0) := (others => '0');
    signal slow_clk : STD_LOGIC := '0';

    component universal_shift_register
        generic ( N : integer := 8 );
        port (
            clk     : in  STD_LOGIC;
            rst_n   : in  STD_LOGIC;
            S       : in  STD_LOGIC_VECTOR(1 downto 0);
            sl_in   : in  STD_LOGIC;
            sr_in   : in  STD_LOGIC;
            p_din   : in  STD_LOGIC_VECTOR(N-1 downto 0);
            p_dout  : out STD_LOGIC_VECTOR(N-1 downto 0);
            sr_out  : out STD_LOGIC;
            sl_out  : out STD_LOGIC
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
            if count = 49999999 then
                count    <= (others => '0');
                slow_clk <= not slow_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    DUT: universal_shift_register
        generic map (N => 4)
        port map (
            clk     => slow_clk,
            rst_n   => SW(0),
            S       => SW(2 downto 1),
            sl_in   => SW(3),
            sr_in   => SW(4),
            p_din   => SW(8 downto 5),
            p_dout  => LEDG(3 downto 0),
            sr_out  => LEDG(4),
            sl_out  => LEDG(5)
        );

end Behavioral;
