LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY led_line IS
PORT(
	clk : IN std_logic;
	buttons : IN std_logic_vector(1 DOWNTO 0);
	leds : OUT std_logic_vector(3 DOWNTO 0) );
END led_line;
ARCHITECTURE synthesis1 OF led_line IS
	constant CLOCK_FREQ: INTEGER := 16384;  

	SIGNAL count : unsigned(32 DOWNTO 0);
	SIGNAL count_pwm : unsigned(6 DOWNTO 0); --128 "ticks" per segment per frame
	SIGNAL count_segm : unsigned(1 DOWNTO 0); --4 segments
	SIGNAL count_frame : unsigned(4 DOWNTO 0); --32 frames per second
	
	SIGNAL f: std_logic;
BEGIN
	PROCESS (clk)
	BEGIN
		IF (clk'EVENT) AND (clk = '1') THEN
			count <= count + 1;
		END IF;
	END PROCESS;

	f <= count(11) WHEN (buttons = "00") ELSE
	     count(12) WHEN (buttons = "01") ELSE
		  count(13) WHEN (buttons = "10") ELSE
		  count(14);
   leds(3 downto 2) <= "10" WHEN (f = '1') ELSE
                       "01";
	leds(1 downto 0) <= "11";
END synthesis1;