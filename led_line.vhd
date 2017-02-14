LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY led_line IS
PORT(
	clk : IN std_logic;
	leds : OUT std_logic_vector(1 DOWNTO 0) );
END led_line;
ARCHITECTURE synthesis1 OF led_line IS
	SIGNAL count : unsigned(15 DOWNTO 0);
	SIGNAL f: std_logic;
BEGIN
--leds <= "10";
	PROCESS (clk)
	BEGIN
		IF (clk'EVENT) AND (clk = '1') THEN
			count <= count + 1;
			IF (count > X"8000") THEN
				leds <= "10";
		   ELSE
				leds <= "01";
			END IF;
		END IF;
	END PROCESS;
END synthesis1;