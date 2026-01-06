library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab2_ex7 is
    port (
        CLOCK_50 : in  std_logic;
        SW       : in  std_logic_vector(3 downto 0);
        LEDG     : out std_logic_vector(3 downto 0)
    );
end Lab2_ex7;

architecture Structural of Lab2_ex7 is

    component Counter
        generic ( N : integer := 4 );
        port (
            clk   : in  std_logic;
            reset : in  std_logic;
            q     : out std_logic_vector(N-1 downto 0)
        );
    end component;

begin

    U1: Counter
        generic map (N => 4)
        port map (
            clk   => CLOCK_50,
            reset => SW(0),
            q     => LEDG
        );

end Structural;
