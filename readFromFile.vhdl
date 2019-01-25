LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use STD.textio.all;
library textutil;       -- Synposys Text I/O package
use textutil.std_logic_textio.all;

package array_pkg is 
  type inputArray is array(natural range <>) of std_logic_vector(15 downto 0);
  type inputMatrice is array(natural range <>) of inputArray;
end package;



ENTITY read_file IS 
generic(inputRange : Integer := 62; inputCount := 750 ;
  firstlayerCount := 20;vectorLength : Integer := 16;
  secondLayaerCount := 10);
PORT(
  inputVector: out  inputMatrice(inputCount - 1 downto 0)(inputRange - 1 downto 0);
  weight1Vector: out inputMatrice(inputRange - 1 downto 0)(firstlayerCount - 1 downto 0);
  bias1Vector: out inputArray(firstlayerCount - 1 downto);
  weight2Vector: out inputMatrice(inputRange - 1 downto 0)(secondLayaerCount - 1 downto 0);
  bias2Vector: out inputArray(secondLayaerCount - 1 downto)
  );
END read_file;

ARCHITECTURE implementation OF read_file IS 

    signal  bin_value : std_logic_vector(vectorLength downto 0);
    
BEGIN
    
   --Read process
  readInput: process 
      file input_file_pointer : text;
      
      variable line_num : line;
      variable good: boolean;  

      variable lineCounter : integer := 0;
      variable indexCounter : integer := 0;

      variable char : character:='0'; 
      variable trashNumber: std_logic;
      variable hexValue: std_logic_vector(vectorLength - 1 downto 0);
   begin
        --Open the file read.txt from the specified location for reading(READ_MODE).
      file_open(input_file_pointer,"/Hex_data/Hex_FixedPoint_2SComplement/te_data_2s_comp.hex",READ_MODE);    
      
      

      while not endfile(input_file_pointer) loop --till the end of file is reached continue.
          readline (file_pointer,line_num);  --Read the whole line from the file
            --Read the contents of the line from  the file into a variable.
          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR; 

          hread(line_in,hexValue ,good);     -- Read the A argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;

          inputVector(lineCounter)(indexCounter) <= hexValue;
          indexCounter := indexCounter + 1;
          if(indexCounter = inputRange) then
            indexCounter := 0;
            lineCounter := lineCounter + 1;
          end if; 
            wait for 1 ns; --after reading each line wait for 1ns.
      end loop;
      file_close(input_file_pointer);  --after reading all the lines close the file.  
        wait;
    end process;



    readW1: process 
      file weight1_file_pointer : text;
      
      variable line_num : line;
      variable good: boolean;  

      variable lineCounter : integer := 0;
      variable indexCounter : integer := 0;

      variable char : character:='0'; 
      variable trashNumber: std_logic;
      variable hexValue: std_logic_vector(vectorLength - 1 downto 0);
   begin
        --Open the file read.txt from the specified location for reading(READ_MODE).
      file_open(weight1_file_pointer,"/Hex_data/Hex_FixedPoint_2SComplement/w1_2s_comp.hex",READ_MODE);    
      
      

      while not endfile(weight1_file_pointer) loop --till the end of file is reached continue.
          readline (weight1_file_pointer,line_num);  --Read the whole line from the file
            --Read the contents of the line from  the file into a variable.
          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR; 

          hread(line_num,hexValue ,good);     -- Read the A argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;

          weight1Vector(lineCounter)(indexCounter) <= hexValue;
          indexCounter := indexCounter + 1;
          if(indexCounter = firstlayerCount) then
            indexCounter := 0;
            lineCounter := lineCounter + 1;
          end if; 
            wait for 1 ns; --after reading each line wait for 1ns.
      end loop;
      file_close(weight1_file_pointer);  --after reading all the lines close the file.  
        wait;
    end process;




    readBias1: process 
      file bias1_file_pointer : text;
      
      variable line_num : line;
      variable good: boolean;  

      variable indexCounter : integer := 0;

      variable char : character:='0'; 
      variable trashNumber: std_logic;
      variable hexValue: std_logic_vector(vectorLength - 1 downto 0);
   begin
        --Open the file read.txt from the specified location for reading(READ_MODE).
      file_open(bias1_file_pointer,"/Hex_data/Hex_FixedPoint_2SComplement/b1_2s_comp.hex",READ_MODE);    
      
      

      while not endfile(bias1_file_pointer) loop --till the end of file is reached continue.
          readline (bias1_file_pointer,line_num);  --Read the whole line from the file
            --Read the contents of the line from  the file into a variable.
          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR; 

          hread(line_num,hexValue ,good);     -- Read the A argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;

          bias1Vector(indexCounter) <= hexValue;
          indexCounter := indexCounter + 1;
            wait for 1 ns; --after reading each line wait for 1ns.
      end loop;
      file_close(bias1_file_pointer);  --after reading all the lines close the file.  
        wait;
    end process;


    readW2: process 
      file weight2_file_pointer : text;
      
      variable line_num : line;
      variable good: boolean;  

      variable lineCounter : integer := 0;
      variable indexCounter : integer := 0;

      variable char : character:='0'; 
      variable trashNumber: std_logic;
      variable hexValue: std_logic_vector(vectorLength - 1 downto 0);
   begin
        --Open the file read.txt from the specified location for reading(READ_MODE).
      file_open(weight2_file_pointer,"/Hex_data/Hex_FixedPoint_2SComplement/w2_2s_comp.hex",READ_MODE);    
      
      

      while not endfile(weight2_file_pointer) loop --till the end of file is reached continue.
          readline (weight2_file_pointer,line_num);  --Read the whole line from the file
            --Read the contents of the line from  the file into a variable.
          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR; 

          hread(line_in,hexValue ,good);     -- Read the A argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;

          weight2Vector(lineCounter)(indexCounter) <= hexValue;
          indexCounter := indexCounter + 1;
          if(indexCounter = secondLayaerCount) then
            indexCounter := 0;
            lineCounter := lineCounter + 1;
          end if; 
            wait for 1 ns; --after reading each line wait for 1ns.
      end loop;
      file_close(weight2_file_pointer);  --after reading all the lines close the file.  
        wait;
    end process;



  ReadBias2: process 
      file bias2_file_pointer: text;
      
      variable line_num : line;
      variable good: boolean;  

      variable indexCounter : integer := 0;

      variable char : character:='0'; 
      variable trashNumber: std_logic;
      variable hexValue: std_logic_vector(vectorLength - 1 downto 0);
   begin
        --Open the file read.txt from the specified location for reading(READ_MODE).
      file_open(bias2_file_pointer,"/Hex_data/Hex_FixedPoint_2SComplement/b2_2s_comp.hex",READ_MODE);    
      
      

      while not endfile(bias2_file_pointer) loop --till the end of file is reached continue.
          readline (bias2_file_pointer,line_num);  --Read the whole line from the file
            --Read the contents of the line from  the file into a variable.
          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          READ (line_num, trashNumber, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR;

          Read (line_num, char, good);
          assert good
                report "Text I/O read error"
                severity ERROR; 

          hread(line_in,hexValue ,good);     -- Read the A argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;

          bias2Vector(indexCounter) <= hexValue;
          indexCounter := indexCounter + 1;
            wait for 1 ns; --after reading each line wait for 1ns.
      end loop;
      file_close(bias2_file_pointer);  --after reading all the lines close the file.  
        wait;
    end process;    

end implementation;






 

