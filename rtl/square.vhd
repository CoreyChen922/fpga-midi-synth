library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
--use ieee.numeric_bit.all; 

library work;
use work.all;

entity square is 
port (
   clk   : in  std_logic;
   note  : in  std_logic_vector(6 downto 0);
   volume: in  std_logic_vector(6 downto 0);
   audio : out std_logic_vector(7 downto 0)
); 
end square; 
 
architecture rtl of square is 

signal c : integer range 0 to 6115611 := 0;
signal x : std_logic:= '0';

type note_type is array(0 to 127)of integer;
signal notes: note_type;

begin

--teiler fuer die 127 midi noten, generiert mit dem note.rb script
notes <= (
6115610,5772367,5448389,5142594,4853963,4581531,4324389,4081680,3852593,3636363,3432270,3239631,
3057805,2886183,2724194,2571297,2426981,2290765,2162194,2040840,1926296,1818181,1716135,1619815,
1528902,1443091,1362097,1285648,1213490,1145382,1081097,1020420,963148 ,909090 ,858067 ,809907,
 764451, 721545, 681048, 642824, 606745, 572691, 540548, 510210,481574 ,454545 ,429033 ,404953,
 382225, 360772, 340524, 321412, 303372, 286345, 270274, 255105,240787 ,227272 ,214516 ,202476,
 191112, 180386, 170262, 160706, 151686, 143172, 135137, 127552,120393 ,113636 ,107258 ,101238,
  95556,  90193,  85131,  80353,  75843,  71586,  67568,  63776,60196  ,56818  ,53629  ,50619,
  47778,  45096,  42565,  40176,  37921,  35793,  33784,  31888,30098  ,28409  ,26814  ,25309,
  23889,  22548,  21282,  20088,  18960,  17896,  16892,  15944,15049  ,14204  ,13407  ,12654,
  11944,  11274,  10641,  10044,   9480,   8948,   8446,   7972,7524   ,7102   ,6703   ,6327,
   5972,   5637,   5320,   5022,   4740,   4474,   4223,   3986
);

process begin  
wait until rising_edge(clk);     -- warten bis zum naechsten Takt 
   if (unsigned(note) < 128) then
      if (c<notes(to_integer(unsigned(note)))) then
         c <= c+1;               -- wenn kleiner: weiterzaehlen 
      else                       -- wenn Zaehlerende erreicht: 
         c <= 0;                 -- Zaehler zurcksetzen 
         x <= not x;             -- und Signal x togglen 
      end if;
   end if;
end process;

process begin  
wait until rising_edge(clk);     -- warten bis zum naechsten Takt 
   if (x = '1') then
      audio <= '0' & volume;
   else
      audio <= "00000000";
   end if;
end process;

end rtl;

