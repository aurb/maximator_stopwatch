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
	SIGNAL pwm_count : unsigned(6 DOWNTO 0); --128 "ticks" per frame
	
	SIGNAL f_count : unsigned(6 DOWNTO 0); --frame counter
	SIGNAL ledline_clk: std_logic;
	SIGNAL ledline_count : unsigned(3 DOWNTO 0);
	SIGNAL leds_val : unsigned(3 DOWNTO 0);
	SIGNAL leds_pval : unsigned(3 DOWNTO 0);
BEGIN
	pwm_count <= count(6 DOWNTO 0);
	f_count(2 DOWNTO 0) <= "000";
	f_count(6 DOWNTO 3) <= count(10 DOWNTO 7) WHEN (buttons = "00") ELSE
	                       count(11 DOWNTO 8) WHEN (buttons = "01") ELSE
	                       count(12 DOWNTO 9) WHEN (buttons = "10") ELSE
	                       count(13 DOWNTO 10);
	ledline_clk <= NOT f_count(6);
	
   PROCESS (clk)
	BEGIN
		IF (clk'EVENT) AND (clk = '1') THEN
			count <= count + 1;
		END IF;
	END PROCESS;

	PROCESS (ledline_clk)
	BEGIN
		IF (ledline_clk'EVENT AND ledline_clk = '1') THEN
			IF (ledline_count < 5) THEN
				ledline_count <= ledline_count + 1;
			ELSE
				ledline_count <= (others => '0');
			END IF;
		END IF;
	END PROCESS;

	WITH ledline_count SELECT
		leds_val <= "1110" WHEN X"0",
				      "1101" WHEN X"1",
	     			   "1011" WHEN X"2",
			 	      "0111" WHEN X"3",
				      "1011" WHEN X"4",
				      "1101" WHEN X"5",
				      "1111" WHEN OTHERS;

	WITH ledline_count SELECT
		leds_pval <= "1101" WHEN X"0",
				       "1110" WHEN X"1",
	     		 	    "1101" WHEN X"2",
			 	       "1011" WHEN X"3",
				       "0111" WHEN X"4",
				       "1011" WHEN X"5",
				       "1111" WHEN OTHERS;

	leds <= std_logic_vector(leds_val) WHEN (f_count > pwm_count) ELSE std_logic_vector(leds_pval);

END synthesis1;