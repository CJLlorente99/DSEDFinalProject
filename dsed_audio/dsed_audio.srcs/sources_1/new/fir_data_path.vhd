----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2020 13:37:21
-- Design Name: 
-- Module Name: fir_data_path - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.package_dsed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_data_path is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ctrl : in STD_LOGIC_VECTOR (6 downto 0); --CAMBIAR
           c0 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           c1 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           c2 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           c3 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           x0 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           x1 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           x2 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           x3 : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           s : out STD_LOGIC_VECTOR (sample_size-1 downto 0));
end fir_data_path;

architecture Behavioral of fir_data_path is

    component half_mul is
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            a : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
            b : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
            c : out STD_LOGIC_VECTOR (((sample_size*2)-1) downto 0));
    end component;
    
    
    --Signals
    signal mul1, mul2 : signed (sample_size-1 downto 0) := (others => '0');
    signal sum1, sum2 : signed (sample_size*2 - 1 downto 0) := (others => '0');
    signal s_out, next_s_out :  signed (sample_size-1 downto 0) := (others => '0');
    signal sum1_std : STD_LOGIC_VECTOR(sample_size*2 -1 downto 0) := (others => '0');

begin

    U0 : half_mul port map(
        clk => clk,
        reset => reset,
        a => std_logic_vector(mul1),
        b => std_logic_vector(mul2),
        c => sum1_std
    );
    
    
    
    -- Register
        process (clk, reset) begin
            if reset = '1' then
                mul1 <= (others => '0');
                mul2 <= (others => '0');
                sum1 <= (others => '0');
                sum2 <= (others => '0');
                s_out <= (others => '0');
            elsif rising_edge(clk) then
                s_out <= next_s_out;
            end if;
        end process;
    
    
    -- Next state logic
        next_s_out <= sum1 + sum2;
    
    -- Output logic
        s <= std_logic_vector(s_out);

end Behavioral;
