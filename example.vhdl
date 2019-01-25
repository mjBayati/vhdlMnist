library ieee;

use ieee.std_logic_1164.all;

use work.all;

use std.textio.all;

library textutil;       -- Synposys Text I/O package

use textutil.std_logic_textio.all;

 

entity tst_add is

end tst_add;

 

architecture readhex of tst_add is

    component adder32 is

        port (cin: in std_ulogic;

              a,b: in std_ulogic_vector(31 downto 0);

              sum: out std_ulogic_vector(31 downto 0);

              cout: out std_ulogic);

    end component;

    for all: adder32 use entity work.adder32(structural);

    signal Clk: std_ulogic;

    signal x, y: std_ulogic_vector(31 downto 0);

    signal sum: std_ulogic_vector(31 downto 0);

    signal cin, cout: std_ulogic;

 

    constant PERIOD: time := 200 ns;

 

begin

    UUT: adder32 port map (cin, x, y, sum, cout);

 

    readcmd: process

 

        -- This process loops through a file and reads one line

        -- at a time, parsing the line to get the values and

        -- expected result.

        --

        -- The file format is CI A B SUM CO, with A, B and SUM

        -- expressed as hexadecimal values.

 

        file cmdfile: TEXT;       -- Define the file 'handle'

        variable line_in,line_out: Line; -- Line buffers

        variable good: boolean;   -- Status of the read operations

 

        variable CI, CO: std_ulogic;

        variable A,B: std_ulogic_vector(31 downto 0);

        variable S: std_ulogic_vector(31 downto 0);

        constant TEST_PASSED: string := "Test passed:";

        constant TEST_FAILED: string := "Test FAILED:";

 

        -- Use a procedure to generate one clock cycle...

        procedure cycle (n: in integer) is

        begin

            for i in 1 to n loop

                Clk <= '0';

                wait for PERIOD / 2;

                Clk <= '1';

                wait for PERIOD / 2;

            end loop;

        end cycle;

 

    begin

 

        -- Open the command file...

 

        FILE_OPEN(cmdfile,"TST_ADD.DAT",READ_MODE);

 

        loop

 

            if endfile(cmdfile) then  -- Check EOF

                assert false

                    report "End of file encountered; exiting."

                    severity NOTE;

                exit;

            end if;

 

            readline(cmdfile,line_in);     -- Read a line from the file

            next when line_in'length = 0;  -- Skip empty lines

 

            read(line_in,CI,good);     -- Read the CI input

            assert good

                report "Text I/O read error"

                severity ERROR;

 

            hread(line_in,A,good);     -- Read the A argument as hex value

            assert good

                report "Text I/O read error"

                severity ERROR;

 

            hread(line_in,B,good);     -- Read the B argument

            assert good

                report "Text I/O read error"

                severity ERROR;

 

            hread(line_in,S,good);     -- Read the Sum expected resulted

            assert good

                report "Text I/O read error"

                severity ERROR;

 

      read(line_in,CO,good);     -- Read the CO expected resulted

            assert good

                report "Text I/O read error"

                severity ERROR;

 

            cin <= CI;

            x <= A;

            y <= B;

 

            wait for PERIOD;   -- Give the circuit time to stabilize

 

            if (sum = S) then

                write(line_out,TEST_PASSED);

            else

                write(line_out,TEST_FAILED);

            end if;

            write(line_out,CI,RIGHT,2);

            hwrite(line_out,A,RIGHT,9);

            hwrite(line_out,B,RIGHT,9);

            hwrite(line_out,sum,RIGHT,9);

            write(line_out,cout,RIGHT,2);

            writeline(OUTPUT,line_out);     -- write the message

 

        end loop;

 

        wait;

 

    end process;

 

end architecture readhex;