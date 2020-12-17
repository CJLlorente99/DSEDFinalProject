----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2020 10:48:09
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

entity dsed_audio is
    Port ( clk_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           -- Control ports
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           SW0 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           -- To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           -- To/From the mini_jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           LED : out STD_LOGIC_VECTOR(7 downto 0)
           );
end dsed_audio;

architecture Behavioral of dsed_audio is

    component audio_interface is
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
    end component;
    
    -- clock wizard component declaration
    component clk_wiz_12mhz is
        Port ( clk_100Mhz : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_12Mhz : out STD_LOGIC);
    end component;
    
    -- RAM wizard component declaration
    component blk_mem_gen_0 IS
        Port (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    end component; 
    
    component fir_filter is
        Port ( clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
            sample_in_enable : in STD_LOGIC;
            filter_select : in STD_LOGIC;
            sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
            sample_out_ready : out STD_LOGIC);
    end component;

    -- signals declaration
        -- Audio Interface
        signal clk_12Mhz, rec_ready, sample_request : STD_LOGIC;
        signal data_audio : STD_LOGIC_VECTOR (sample_size -1 downto 0);
        
        -- RAM
        signal clka, ena : STD_LOGIC := '0';
        signal wea : STD_LOGIC_VECTOR(0 downto 0) := (others => '0');
        signal addra : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
        signal dina : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        signal data_ram : STD_LOGIC_VECTOR(7 downto 0);
        
        -- Filter
        signal sample_in_enable, filter_select : STD_LOGIC := '0';
        signal data_filter : STD_LOGIC_VECTOR(7 downto 0);
        signal data_filter_ready : STD_LOGIC;
        
        -- Extra signals
        signal signal_speaker : STD_LOGIC_VECTOR (sample_size -1 downto 0);

begin
    -- clk wizard instantiation
    CLK_WIZ : clk_wiz_12mhz
        port map ( clk_100Mhz => clk_100Mhz,
                   reset => reset,
                   clk_12Mhz => clk_12Mhz);
                   
    -- audio interface instantiation
    AUDIO_INTER : audio_interface
        port map ( clk_12megas => clk_12Mhz,
                   reset => reset,
                   record_enable => '1',
                   sample_out => data_audio,
                   sample_out_ready => rec_ready,
                   micro_clk => micro_clk,
                   micro_data => micro_data,
                   micro_LR => micro_LR,
                   play_enable => '1',
                   sample_in => signal_speaker,
                   sample_request => sample_request,
                   jack_sd => jack_sd,
                   jack_pwm => jack_pwm,
                   LED => LED);
    
    -- ram instantation
    RAM : blk_mem_gen_0 
        port map ( clka => clk_12Mhz,
                   ena => ena,
                   wea => wea,
                   addra => addra,
                   dina => data_audio,
                   douta => data_ram);
    
    -- filter instantation
    FILTER : fir_filter 
        port map ( clk => clk_12Mhz,
                   reset => reset,
                   sample_in => data_ram,
                   sample_in_enable => sample_in_enable,
                   filter_select => filter_select,
                   sample_out => data_filter,
                   sample_out_ready => data_filter_ready);
                   
                   
                   
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
                   -- QUE NO SE NOS OLVIDE HACER EL CAMBIO DE CA2 A BINARIO Y VICEVERSA 
    
    
end Behavioral;
