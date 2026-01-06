library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab2_ex3 is
    Port (
        CLOCK_50 : in  std_logic;               
        SW       : in  std_logic_vector(3 downto 0);  -- J = SW[0], K = SW[1]
        LEDG     : out std_logic_vector(1 downto 0);
        LEDR     : out std_logic_vector(3 downto 0)
    );
end Lab2_ex3;

architecture Behavioral of Lab2_ex3 is
    signal Q_int : STD_LOGIC := '0';
begin
	LEDR <= SW;
    process (CLOCK_50, SW(0))
    begin
        if SW(0) = '1' then
            Q_int <= '0';                            
        elsif rising_edge(CLOCK_50) then
            case std_logic_vector'(SW(2) & SW(1)) is
                when "00" => Q_int <= Q_int;          
                when "01" => Q_int <= '0';            
                when "10" => Q_int <= '1';            
                when "11" => Q_int <= not Q_int;      
                when others => null;
            end case;
        end if;
    end process;
    LEDG(0) <= Q_int;
end Behavioral;
