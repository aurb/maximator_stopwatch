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
	SIGNAL f_count : unsigned(3 DOWNTO 0);
BEGIN
	f <= count(10) WHEN (buttons = "00") ELSE
	     count(11) WHEN (buttons = "01") ELSE
		  count(12) WHEN (buttons = "10") ELSE
		  count(13);

   PROCESS (clk)
	BEGIN
		IF (clk'EVENT) AND (clk = '1') THEN
			count <= count + 1;
		END IF;
	END PROCESS;

	PROCESS (f)
	BEGIN
		IF (f'EVENT AND f = '1') THEN
			IF (f_count < 5) THEN
				f_count <= f_count + 1;
			ELSE
				f_count <= (others => '0');
			END IF;
		END IF; --(f'EVENT AND f = '1')
	END PROCESS;

	WITH f_count SELECT
		leds <= "1110" WHEN X"0",
				  "1101" WHEN X"1",
				  "1011" WHEN X"2",
				  "0111" WHEN X"3",
				  "1011" WHEN X"4",
				  "1101" WHEN X"5",
				  "1111" WHEN OTHERS;
END synthesis1;