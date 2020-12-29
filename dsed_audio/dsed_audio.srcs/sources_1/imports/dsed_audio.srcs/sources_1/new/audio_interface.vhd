----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2020 10:48:09
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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

entity audio_interface is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           -- Recording ports
           -- To/From the controller
           record_enable : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC;
           -- To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           -- Playing ports
           -- To/From the controller
           play_enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           -- To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           --LED ports
           --To/From PowerDisplay
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end audio_interface;

architecture Behavioral of audio_interface is
    
    component pwm is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               en_2_cycles : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
               sample_request : out STD_LOGIC;
               pwm_pulse : out STD_LOGIC);
    end component;
    
    component FSMD_microphone is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable_4_cycles : in STD_LOGIC;
               micro_data : in STD_LOGIC;
               sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC
               -- Debugging outputs
    --           count : out integer;
    --           state_num : out integer
               );
    end component;
    
    component enable_generator is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_3megas : out STD_LOGIC;
               en_2_cycles : out STD_LOGIC;
               en_4_cycles : out STD_LOGIC);
    end component;
    
    component average_power_display is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
               sample_request : in STD_LOGIC;
               LED : out STD_LOGIC_VECTOR (7 downto 0));
    end component; 
    
    --pwm signals:
        signal en_2_cycles,pwm_pulse : STD_LOGIC;
        
    -- FSMD_microphone signals:
        signal enable_4_cycles, auxiliar_enable : STD_LOGIC;
        
    -- enable_generator signals:
        signal clk_3megas : STD_LOGIC;
        
    --sample request aux signal
        signal s_request : STD_LOGIC;
        
    --pwm output aux signal
        signal jack_pwm_auxiliar : STD_LOGIC;
        
begin

    jack_sd <= '1';
    micro_LR <= '1';
    
    auxiliar_enable <= (enable_4_cycles and record_enable);
    
    
    

    U0 : pwm port map(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => en_2_cycles,
        sample_in => sample_in,
        sample_request => s_request,
        pwm_pulse => jack_pwm_auxiliar
    );
    
    U1 : FSMD_microphone port map(
        clk_12megas => clk_12megas,
        reset => reset,
        enable_4_cycles => auxiliar_enable,
        micro_data => micro_data,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready
    );
    
    U3 : enable_generator port map(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => micro_clk,
        en_2_cycles => en_2_cycles,
        en_4_cycles => enable_4_cycles
    );
    
    U4 : average_power_display port map(
        clk_12megas => clk_12megas,
       reset => reset,
       sample_in => sample_in,
       sample_request => s_request,
       LED => LED);
       
       sample_request <= s_request;
       jack_pwm <= play_enable and jack_pwm_auxiliar;

end Behavioral;
