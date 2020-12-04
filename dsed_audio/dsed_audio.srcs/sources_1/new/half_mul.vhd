----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2020 12:49:10
-- Design Name: 
-- Module Name: half_mul - Behavioral
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


entity half_mul is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        a : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
        b : in STD_LOGIC_VECTOR ((sample_size-1) downto 0);
        c : out STD_LOGIC_VECTOR (((sample_size*2)-2) downto 0)); -- This attribute can only be this long
                                                                  -- considering |b| < 1
end half_mul;

architecture Behavioral of half_mul is
    
    signal mult, next_mult : signed (((sample_size*2)-2) downto 0) := (others => '0');
    signal aux : signed (((sample_size*2)-1) downto 0) := (others => '0');

begin

    -- Registers
    process (clk, reset) begin
        if reset = '1' then
            mult <= (others => '0');
        elsif rising_edge(clk) then
            mult <= next_mult;
        end if;
    end process;
    
    -- Next state logic
        aux <= signed(a) * signed(b);
        next_mult <= aux(((sample_size*2)-2) downto 0);
        
    -- Output Logic
        c <= STD_LOGIC_VECTOR(mult);

end Behavioral;
