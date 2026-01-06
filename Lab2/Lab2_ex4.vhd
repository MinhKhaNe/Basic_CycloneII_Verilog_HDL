library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab2_ex4 is
    port (
        CLOCK_50 : in  std_logic;               
        SW       : in  std_logic_vector(6 downto 0);  
        LEDG     : out std_logic_vector(3 downto 0);
        LEDR     : out std_logic_vector(6 downto 0)
    );
end entity;

architecture behavioral of Lab2_ex4 is
    signal q_reg      : unsigned(3 downto 0) := (others => '0');
    signal slow_count : unsigned(25 downto 0) := (others => '0');
    signal sw1_prev   : std_logic := '0';
begin
    LEDR <= SW;

    process(CLOCK_50, SW(0))
    begin
        if SW(0) = '0' then
            q_reg      <= (others => '0');
            slow_count <= (others => '0');
        elsif rising_edge(CLOCK_50) then
            if slow_count = to_unsigned(49_999_999, slow_count'length) then
                slow_count <= (others => '0');

                if SW(1) = '1' and sw1_prev = '0' then
                    q_reg <= unsigned(SW(6 downto 3)); 
                elsif SW(2) = '1' then
                    q_reg <= q_reg + 1;
                end if;
            else
                slow_count <= slow_count + 1;
            end if;
            sw1_prev <= SW(1);
        end if;
    end process;

    LEDG <= std_logic_vector(q_reg);
end architecture;
