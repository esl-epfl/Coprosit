--------------------------------------------------------------------------------
--                        Normalizer_ZO_6_6_6_F50_uid6
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, (2007-2020)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X OZb
-- Output signals: Count R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Normalizer_ZO_6_6_6_F50_uid6 is
    port (clk : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(2 downto 0);
          R : out  std_logic_vector(5 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_6_6_6_F50_uid6 is
signal level3 :  std_logic_vector(5 downto 0);
signal sozb :  std_logic;
signal count2 :  std_logic;
signal level2 :  std_logic_vector(5 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(5 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(5 downto 0);
signal sCount :  std_logic_vector(2 downto 0);
begin
   level3 <= X ;
   sozb<= OZb;
   count2<= '1' when level3(5 downto 2) = (5 downto 2=>sozb) else '0';
   level2<= level3(5 downto 0) when count2='0' else level3(1 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(5 downto 4) = (5 downto 4=>sozb) else '0';
   level1<= level2(5 downto 0) when count1='0' else level2(3 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(5 downto 5) = (5 downto 5=>sozb) else '0';
   level0<= level1(5 downto 0) when count0='0' else level1(4 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                       PositFastDecoder_8_2_F50_uid4
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: Sign SF Frac NZN

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositFastDecoder_8_2_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(7 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(5 downto 0);
          Frac : out  std_logic_vector(2 downto 0);
          NZN : out  std_logic   );
end entity;

architecture arch of PositFastDecoder_8_2_F50_uid4 is
   component Normalizer_ZO_6_6_6_F50_uid6 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(2 downto 0);
             R : out  std_logic_vector(5 downto 0)   );
   end component;

signal sgn :  std_logic;
signal pNZN :  std_logic;
signal rc :  std_logic;
signal regPosit :  std_logic_vector(5 downto 0);
signal regLength :  std_logic_vector(2 downto 0);
signal shiftedPosit :  std_logic_vector(5 downto 0);
signal k :  std_logic_vector(3 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal pSF :  std_logic_vector(5 downto 0);
signal pFrac :  std_logic_vector(2 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
--------------------------- Sign bit & special cases ---------------------------
   sgn <= X(7);
   pNZN <= '0' when (X(6 downto 0) = "0000000") else '1';
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= X(6);
   regPosit <= X(5 downto 0);
   RegimeCounter: Normalizer_ZO_6_6_6_F50_uid6
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= "0" & regLength when rc /= sgn else "1" & NOT(regLength);
   sgnVect <= (others => sgn);
   exp <= shiftedPosit(4 downto 3) XOR sgnVect;
   pSF <= k & exp;
------------------------------- Extract fraction -------------------------------
   pFrac <= shiftedPosit(2 downto 0);
   Sign <= sgn;
   SF <= pSF;
   Frac <= pFrac;
   NZN <= pNZN;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                       Normalizer_ZO_6_6_6_F50_uid10
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, (2007-2020)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X OZb
-- Output signals: Count R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Normalizer_ZO_6_6_6_F50_uid10 is
    port (clk : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(2 downto 0);
          R : out  std_logic_vector(5 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_6_6_6_F50_uid10 is
signal level3 :  std_logic_vector(5 downto 0);
signal sozb :  std_logic;
signal count2 :  std_logic;
signal level2 :  std_logic_vector(5 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(5 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(5 downto 0);
signal sCount :  std_logic_vector(2 downto 0);
begin
   level3 <= X ;
   sozb<= OZb;
   count2<= '1' when level3(5 downto 2) = (5 downto 2=>sozb) else '0';
   level2<= level3(5 downto 0) when count2='0' else level3(1 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(5 downto 4) = (5 downto 4=>sozb) else '0';
   level1<= level2(5 downto 0) when count1='0' else level2(3 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(5 downto 5) = (5 downto 5=>sozb) else '0';
   level0<= level1(5 downto 0) when count0='0' else level1(4 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                       PositFastDecoder_8_2_F50_uid8
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: Sign SF Frac NZN

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositFastDecoder_8_2_F50_uid8 is
    port (clk : in std_logic;
          X : in  std_logic_vector(7 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(5 downto 0);
          Frac : out  std_logic_vector(2 downto 0);
          NZN : out  std_logic   );
end entity;

architecture arch of PositFastDecoder_8_2_F50_uid8 is
   component Normalizer_ZO_6_6_6_F50_uid10 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(2 downto 0);
             R : out  std_logic_vector(5 downto 0)   );
   end component;

signal sgn :  std_logic;
signal pNZN :  std_logic;
signal rc :  std_logic;
signal regPosit :  std_logic_vector(5 downto 0);
signal regLength :  std_logic_vector(2 downto 0);
signal shiftedPosit :  std_logic_vector(5 downto 0);
signal k :  std_logic_vector(3 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal pSF :  std_logic_vector(5 downto 0);
signal pFrac :  std_logic_vector(2 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
--------------------------- Sign bit & special cases ---------------------------
   sgn <= X(7);
   pNZN <= '0' when (X(6 downto 0) = "0000000") else '1';
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= X(6);
   regPosit <= X(5 downto 0);
   RegimeCounter: Normalizer_ZO_6_6_6_F50_uid10
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= "0" & regLength when rc /= sgn else "1" & NOT(regLength);
   sgnVect <= (others => sgn);
   exp <= shiftedPosit(4 downto 3) XOR sgnVect;
   pSF <= k & exp;
------------------------------- Extract fraction -------------------------------
   pFrac <= shiftedPosit(2 downto 0);
   Sign <= sgn;
   SF <= pSF;
   Frac <= pFrac;
   NZN <= pNZN;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_5_F50_uid14
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_5_F50_uid14 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of IntAdder_5_F50_uid14 is
signal Rtmp :  std_logic_vector(4 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_5_F50_uid16
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_5_F50_uid16 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of IntAdder_5_F50_uid16 is
signal Rtmp :  std_logic_vector(4 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_5_F50_uid18
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_5_F50_uid18 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of IntAdder_5_F50_uid18 is
signal Rtmp :  std_logic_vector(4 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_5_F50_uid20
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_5_F50_uid20 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of IntAdder_5_F50_uid20 is
signal Rtmp :  std_logic_vector(4 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_5_F50_uid22
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_5_F50_uid22 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of IntAdder_5_F50_uid22 is
signal Rtmp :  std_logic_vector(4 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_5_F50_uid24
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_5_F50_uid24 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of IntAdder_5_F50_uid24 is
signal Rtmp :  std_logic_vector(4 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_5_F50_uid26
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_5_F50_uid26 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of IntAdder_5_F50_uid26 is
signal Rtmp :  std_logic_vector(4 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_9_F50_uid28
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_9_F50_uid28 is
    port (clk : in std_logic;
          X : in  std_logic_vector(8 downto 0);
          Y : in  std_logic_vector(8 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(8 downto 0)   );
end entity;

architecture arch of IntAdder_9_F50_uid28 is
signal Rtmp :  std_logic_vector(8 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_9_F50_uid30
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y Cin
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_9_F50_uid30 is
    port (clk : in std_logic;
          X : in  std_logic_vector(8 downto 0);
          Y : in  std_logic_vector(8 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(8 downto 0)   );
end entity;

architecture arch of IntAdder_9_F50_uid30 is
signal Rtmp :  std_logic_vector(8 downto 0);
signal X_d1 :  std_logic_vector(8 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Cin_d1 <=  Cin;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            FixDiv_1_3_F50_uid12
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FixDiv_1_3_F50_uid12 is
    port (clk : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : in  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of FixDiv_1_3_F50_uid12 is
   component IntAdder_5_F50_uid14 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(4 downto 0)   );
   end component;

   component IntAdder_5_F50_uid16 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(4 downto 0)   );
   end component;

   component IntAdder_5_F50_uid18 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(4 downto 0)   );
   end component;

   component IntAdder_5_F50_uid20 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(4 downto 0)   );
   end component;

   component IntAdder_5_F50_uid22 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(4 downto 0)   );
   end component;

   component IntAdder_5_F50_uid24 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(4 downto 0)   );
   end component;

   component IntAdder_5_F50_uid26 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(4 downto 0)   );
   end component;

   component IntAdder_9_F50_uid28 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(8 downto 0);
             Y : in  std_logic_vector(8 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(8 downto 0)   );
   end component;

   component IntAdder_9_F50_uid30 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(8 downto 0);
             Y : in  std_logic_vector(8 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(8 downto 0)   );
   end component;

signal X_minus_two :  std_logic;
signal Y_plus_one :  std_logic;
signal corner_case, corner_case_d1 :  std_logic;
signal X_sign, X_sign_d1 :  std_logic;
signal div :  std_logic_vector(4 downto 0);
signal div_sign, div_sign_d1 :  std_logic;
signal diff_signs :  std_logic;
signal div_ge_tmp :  std_logic;
signal div_gr, div_gr_d1 :  std_logic;
signal n_0 :  std_logic_vector(4 downto 0);
signal append_0 :  std_logic;
signal neg_div :  std_logic_vector(4 downto 0);
signal one_bit :  std_logic;
signal s_1 :  std_logic;
signal r_0 :  std_logic_vector(4 downto 0);
signal pm_div_1 :  std_logic_vector(4 downto 0);
signal n_1 :  std_logic_vector(4 downto 0);
signal rem_z_0 :  std_logic;
signal z_1 :  std_logic;
signal s_2 :  std_logic;
signal r_1 :  std_logic_vector(4 downto 0);
signal pm_div_2 :  std_logic_vector(4 downto 0);
signal n_2 :  std_logic_vector(4 downto 0);
signal rem_z_1 :  std_logic;
signal z_2 :  std_logic;
signal s_3 :  std_logic;
signal r_2 :  std_logic_vector(4 downto 0);
signal pm_div_3 :  std_logic_vector(4 downto 0);
signal n_3 :  std_logic_vector(4 downto 0);
signal rem_z_2 :  std_logic;
signal z_3 :  std_logic;
signal s_4 :  std_logic;
signal r_3 :  std_logic_vector(4 downto 0);
signal pm_div_4 :  std_logic_vector(4 downto 0);
signal n_4 :  std_logic_vector(4 downto 0);
signal rem_z_3 :  std_logic;
signal z_4 :  std_logic;
signal s_5 :  std_logic;
signal r_4 :  std_logic_vector(4 downto 0);
signal pm_div_5 :  std_logic_vector(4 downto 0);
signal n_5 :  std_logic_vector(4 downto 0);
signal rem_z_4 :  std_logic;
signal z_5 :  std_logic;
signal s_6 :  std_logic;
signal r_5 :  std_logic_vector(4 downto 0);
signal pm_div_6 :  std_logic_vector(4 downto 0);
signal n_6 :  std_logic_vector(4 downto 0);
signal rem_z_5 :  std_logic;
signal z_6, z_6_d1 :  std_logic;
signal s_7 :  std_logic;
signal r_6 :  std_logic_vector(4 downto 0);
signal pm_div_7 :  std_logic_vector(4 downto 0);
signal n_7, n_7_d1 :  std_logic_vector(4 downto 0);
signal rem_z_6 :  std_logic;
signal z_7 :  std_logic;
signal q_1 :  std_logic_vector(8 downto 0);
signal q_2 :  std_logic_vector(8 downto 0);
signal quotient_tmp :  std_logic_vector(8 downto 0);
signal rem_sign, rem_sign_d1 :  std_logic;
signal rem_div_sign :  std_logic;
signal rem_dvr_sign :  std_logic;
signal div_div_sign, div_div_sign_d1 :  std_logic;
signal interm_zero_rem :  std_logic;
signal q_config :  std_logic_vector(4 downto 0);
signal zz :  std_logic;
signal sub_add_ulp :  std_logic_vector(8 downto 0);
signal quotient_aux :  std_logic_vector(8 downto 0);
signal quotient :  std_logic_vector(7 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            corner_case_d1 <=  corner_case;
            X_sign_d1 <=  X_sign;
            div_sign_d1 <=  div_sign;
            div_gr_d1 <=  div_gr;
            z_6_d1 <=  z_6;
            n_7_d1 <=  n_7;
            rem_sign_d1 <=  rem_sign;
            div_div_sign_d1 <=  div_div_sign;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------- Non-Restoring Division algorithm -----------------------
   X_minus_two <= '1' when X = "10000" else '0';
   Y_plus_one <= '1' when Y = "01000" else '0';
   corner_case <= X_minus_two AND Y_plus_one;
   X_sign <= X(4);
   div <= Y;
   div_sign <= Y(4);
   diff_signs <= X_sign XOR div_sign;
   div_ge_tmp <= '1' when Y(3 downto 0) > X(3 downto 0) else '0';
   div_gr <= '0';
   n_0 <= X when div_gr='1' else (X(4) & X(4 downto 1));
   append_0 <= '0' when div_gr='1' else X(0);
   neg_div <= NOT(Y);
   one_bit <= '1' ;
   -- Iteration 1
   s_1 <= NOT(n_0(4) XOR div_sign);
   r_0 <= n_0(3 downto 0) & append_0;
   pm_div_1 <= div when s_1='0' else neg_div;
   sub_0: IntAdder_5_F50_uid14
      port map ( clk  => clk,
                 Cin => s_1,
                 X => r_0,
                 Y => pm_div_1,
                 R => n_1);
   rem_z_0 <= '1' when n_1 = 0 else '0';
   z_1 <= rem_z_0;
   -- Iteration 2
   s_2 <= NOT(n_1(4) XOR div_sign);
   r_1 <= n_1(3 downto 0) & '0';
   pm_div_2 <= div when s_2='0' else neg_div;
   sub_1: IntAdder_5_F50_uid16
      port map ( clk  => clk,
                 Cin => s_2,
                 X => r_1,
                 Y => pm_div_2,
                 R => n_2);
   rem_z_1 <= '1' when n_2 = 0 else '0';
   z_2 <= rem_z_1 OR z_1;
   -- Iteration 3
   s_3 <= NOT(n_2(4) XOR div_sign);
   r_2 <= n_2(3 downto 0) & '0';
   pm_div_3 <= div when s_3='0' else neg_div;
   sub_2: IntAdder_5_F50_uid18
      port map ( clk  => clk,
                 Cin => s_3,
                 X => r_2,
                 Y => pm_div_3,
                 R => n_3);
   rem_z_2 <= '1' when n_3 = 0 else '0';
   z_3 <= rem_z_2 OR z_2;
   -- Iteration 4
   s_4 <= NOT(n_3(4) XOR div_sign);
   r_3 <= n_3(3 downto 0) & '0';
   pm_div_4 <= div when s_4='0' else neg_div;
   sub_3: IntAdder_5_F50_uid20
      port map ( clk  => clk,
                 Cin => s_4,
                 X => r_3,
                 Y => pm_div_4,
                 R => n_4);
   rem_z_3 <= '1' when n_4 = 0 else '0';
   z_4 <= rem_z_3 OR z_3;
   -- Iteration 5
   s_5 <= NOT(n_4(4) XOR div_sign);
   r_4 <= n_4(3 downto 0) & '0';
   pm_div_5 <= div when s_5='0' else neg_div;
   sub_4: IntAdder_5_F50_uid22
      port map ( clk  => clk,
                 Cin => s_5,
                 X => r_4,
                 Y => pm_div_5,
                 R => n_5);
   rem_z_4 <= '1' when n_5 = 0 else '0';
   z_5 <= rem_z_4 OR z_4;
   -- Iteration 6
   s_6 <= NOT(n_5(4) XOR div_sign);
   r_5 <= n_5(3 downto 0) & '0';
   pm_div_6 <= div when s_6='0' else neg_div;
   sub_5: IntAdder_5_F50_uid24
      port map ( clk  => clk,
                 Cin => s_6,
                 X => r_5,
                 Y => pm_div_6,
                 R => n_6);
   rem_z_5 <= '1' when n_6 = 0 else '0';
   z_6 <= rem_z_5 OR z_5;
   -- Iteration 7
   s_7 <= NOT(n_6(4) XOR div_sign);
   r_6 <= n_6(3 downto 0) & '0';
   pm_div_7 <= div when s_7='0' else neg_div;
   sub_6: IntAdder_5_F50_uid26
      port map ( clk  => clk,
                 Cin => s_7,
                 X => r_6,
                 Y => pm_div_7,
                 R => n_7);
   rem_z_6 <= '1' when n_7_d1 = 0 else '0';
   z_7 <= rem_z_6 OR z_6_d1;
   -- Convert the quotient to the digit set {0,1}
   q_1 <= "00" & s_1 & s_2 & s_3 & s_4 & s_5 & s_6 & s_7 ;
   q_2 <= "11" & s_1 & s_2 & s_3 & s_4 & s_5 & s_6 & s_7 ;
   sub_quotient: IntAdder_9_F50_uid28
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => q_1,
                 Y => q_2,
                 R => quotient_tmp);
   -- Correction step
   rem_sign <= n_7(4);
   rem_div_sign <= NOT(rem_z_6) AND (rem_sign_d1 XOR X_sign_d1);
   rem_dvr_sign <= rem_sign_d1 XOR div_sign_d1;
   div_div_sign <= X_sign XOR div_sign;
   interm_zero_rem <= NOT(rem_z_6) AND z_7;
   q_config <= '0' & div_div_sign_d1 & interm_zero_rem & rem_dvr_sign & corner_case_d1;
   zz <= '0';
   with q_config  select  sub_add_ulp <= 
      "111111111" when "10000" | "10010" | "10100" | "10110",
      "00000000" & '1' when "11000" | "11010" | "11100" | "11110",
      "111111111" when "00110" | "01110",
      "00000000" & '1' when "00100" | "01100",
      "111111111" when "00001" | "00011" | "00101" | "00111" | "01001" | "01011" | "01101" | "01111" | "10001" | "10011" | "10101" | "10111" | "11001" | "11011" | "11101" | "11111",
      "000000000" when others;
   correct_quotient: IntAdder_9_F50_uid30
      port map ( clk  => clk,
                 Cin => zz,
                 X => quotient_tmp,
                 Y => sub_add_ulp,
                 R => quotient_aux);
   quotient <= quotient_aux(8 downto 1) when div_gr_d1='1' else (quotient_aux(7 downto 0));
   R <= quotient;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                   RightShifterSticky7_by_max_7_F50_uid34
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X S padBit
-- Output signals: R Sticky

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity RightShifterSticky7_by_max_7_F50_uid34 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          S : in  std_logic_vector(2 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(6 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky7_by_max_7_F50_uid34 is
signal ps :  std_logic_vector(2 downto 0);
signal Xpadded :  std_logic_vector(6 downto 0);
signal level3 :  std_logic_vector(6 downto 0);
signal stk2 :  std_logic;
signal level2 :  std_logic_vector(6 downto 0);
signal stk1 :  std_logic;
signal level1 :  std_logic_vector(6 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(6 downto 0);
begin
   ps<= S;
   Xpadded <= X;
   level3<= Xpadded;
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1')   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(6 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(6 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(6 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                       PositFastEncoder_8_2_F50_uid32
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: Sign SF Frac Guard Sticky NZN
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositFastEncoder_8_2_F50_uid32 is
    port (clk : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(6 downto 0);
          Frac : in  std_logic_vector(2 downto 0);
          Guard : in  std_logic;
          Sticky : in  std_logic;
          NZN : in  std_logic;
          R : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of PositFastEncoder_8_2_F50_uid32 is
   component RightShifterSticky7_by_max_7_F50_uid34 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             S : in  std_logic_vector(2 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(6 downto 0);
             Sticky : out  std_logic   );
   end component;

signal rc :  std_logic;
signal rcVect :  std_logic_vector(3 downto 0);
signal k :  std_logic_vector(3 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal ovf :  std_logic;
signal regValue :  std_logic_vector(2 downto 0);
signal regNeg :  std_logic;
signal padBit :  std_logic;
signal inputShifter :  std_logic_vector(6 downto 0);
signal shiftedPosit :  std_logic_vector(6 downto 0);
signal stkBit :  std_logic;
signal unroundedPosit :  std_logic_vector(6 downto 0);
signal lsb :  std_logic;
signal rnd :  std_logic;
signal stk :  std_logic;
signal round :  std_logic;
signal roundedPosit :  std_logic_vector(6 downto 0);
signal unsignedPosit :  std_logic_vector(6 downto 0);
signal NZN_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            NZN_d1 <=  NZN;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------------- Get value of regime -----------------------------
   rc <= SF(SF'high);
   rcVect <= (others => rc);
   k <= SF(5 downto 2) XOR rcVect;
   sgnVect <= (others => Sign);
   exp <= SF(1 downto 0) XOR sgnVect;
   -- Check for regime overflow
   ovf <= '1' when (k > "0101") else '0';
   regValue <= k(2 downto 0) when ovf = '0' else "110";
-------------- Generate regime - shift out exponent and fraction --------------
   regNeg <= Sign XOR rc;
   padBit <= NOT(regNeg);
   inputShifter <= regNeg & exp & Frac & Guard;
   RegimeGenerator: RightShifterSticky7_by_max_7_F50_uid34
      port map ( clk  => clk,
                 S => regValue,
                 X => inputShifter,
                 padBit => padBit,
                 R => shiftedPosit,
                 Sticky => stkBit);
   unroundedPosit <= padBit & shiftedPosit(6 downto 1);
---------------------------- Round to nearest even ----------------------------
   lsb <= shiftedPosit(1);
   rnd <= shiftedPosit(0);
   stk <= stkBit OR Sticky;
   round <= rnd AND (lsb OR stk OR ovf);
   roundedPosit <= unroundedPosit + round;
-------------------------- Check sign & Special Cases --------------------------
   unsignedPosit <= roundedPosit when NZN_d1 = '1' else (others => '0');
   R <= Sign & unsignedPosit;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                  PositDiv
--                          (PositDiv_8_2_F50_uid2)
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X Y
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositDiv is
    port (clk : in std_logic;
          X : in  std_logic_vector(7 downto 0);
          Y : in  std_logic_vector(7 downto 0);
          R : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of PositDiv is
   component PositFastDecoder_8_2_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(7 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(5 downto 0);
             Frac : out  std_logic_vector(2 downto 0);
             NZN : out  std_logic   );
   end component;

   component PositFastDecoder_8_2_F50_uid8 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(7 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(5 downto 0);
             Frac : out  std_logic_vector(2 downto 0);
             NZN : out  std_logic   );
   end component;

   component FixDiv_1_3_F50_uid12 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : in  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(7 downto 0)   );
   end component;

   component PositFastEncoder_8_2_F50_uid32 is
      port ( clk : in std_logic;
             Sign : in  std_logic;
             SF : in  std_logic_vector(6 downto 0);
             Frac : in  std_logic_vector(2 downto 0);
             Guard : in  std_logic;
             Sticky : in  std_logic;
             NZN : in  std_logic;
             R : out  std_logic_vector(7 downto 0)   );
   end component;

signal X_sgn :  std_logic;
signal X_sf, X_sf_d1 :  std_logic_vector(5 downto 0);
signal X_f :  std_logic_vector(2 downto 0);
signal X_nzn :  std_logic;
signal Y_sgn :  std_logic;
signal Y_sf, Y_sf_d1 :  std_logic_vector(5 downto 0);
signal Y_f :  std_logic_vector(2 downto 0);
signal Y_nzn :  std_logic;
signal XY_nzn, XY_nzn_d1 :  std_logic;
signal X_nar, X_nar_d1 :  std_logic;
signal Y_nar, Y_nar_d1 :  std_logic;
signal Y_zero, Y_zero_d1 :  std_logic;
signal XX_f :  std_logic_vector(4 downto 0);
signal YY_f :  std_logic_vector(4 downto 0);
signal XY_f :  std_logic_vector(7 downto 0);
signal XY_sgn :  std_logic;
signal shift_1 :  std_logic;
signal shift_2 :  std_logic;
signal shift_case :  std_logic_vector(1 downto 0);
signal XY_frac :  std_logic_vector(2 downto 0);
signal grd :  std_logic;
signal stk_tmp :  std_logic_vector(2 downto 0);
signal stk :  std_logic;
signal XY_sf :  std_logic_vector(6 downto 0);
signal XY_finalSgn :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_sf_d1 <=  X_sf;
            Y_sf_d1 <=  Y_sf;
            XY_nzn_d1 <=  XY_nzn;
            X_nar_d1 <=  X_nar;
            Y_nar_d1 <=  Y_nar;
            Y_zero_d1 <=  Y_zero;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
---------------------------- Decode X & Y operands ----------------------------
   X_decoder: PositFastDecoder_8_2_F50_uid4
      port map ( clk  => clk,
                 X => X,
                 Frac => X_f,
                 NZN => X_nzn,
                 SF => X_sf,
                 Sign => X_sgn);
   Y_decoder: PositFastDecoder_8_2_F50_uid8
      port map ( clk  => clk,
                 X => Y,
                 Frac => Y_f,
                 NZN => Y_nzn,
                 SF => Y_sf,
                 Sign => Y_sgn);
--------------------------------- Divide X & Y ---------------------------------
   -- Sign and Special Cases Computation
   XY_nzn <= X_nzn AND Y_nzn;
   X_nar <= X_sgn AND NOT(X_nzn);
   Y_nar <= Y_sgn AND NOT(Y_nzn);
   Y_zero <= NOT(Y_sgn OR Y_nzn);
   -- Divide the fractions (using FloPoCo module FixDivider)
   XX_f <= X_sgn & NOT(X_sgn) & X_f;
   YY_f <= Y_sgn & NOT(Y_sgn) & Y_f;
   FracDivider: FixDiv_1_3_F50_uid12
      port map ( clk  => clk,
                 X => XX_f,
                 Y => YY_f,
                 R => XY_f);
   -- Normalize fraction
   XY_sgn <= XY_f(7);
   shift_1 <= XY_f(7) XNOR XY_f(6);
   shift_2 <= XY_f(7) AND XY_f(6) AND XY_f(5);
   shift_case <= shift_1 & shift_2;
   with shift_case  select  XY_frac <= 
      XY_f(3 downto 1) when "11",
      XY_f(4 downto 2) when "10",
      XY_f(5 downto 3) when others;
   with shift_case  select  grd <= 
      XY_f(0) when "11",
      XY_f(1) when "10",
      XY_f(2) when others;
   with shift_case  select  stk_tmp <= 
      "000" when "11",
      XY_f(0 downto 0) & "00" when "10",
      XY_f(1 downto 0) & "0" when others;
   stk <= '0' when (stk_tmp=0) else '1';
   -- Subtract the exponent values
   XY_sf <= (X_sf_d1(X_sf_d1'high) & X_sf_d1) - (Y_sf_d1(Y_sf_d1'high) & Y_sf_d1) - shift_1 - shift_2;
----------------------------- Generate final posit -----------------------------
   XY_finalSgn <= XY_sgn when XY_nzn_d1 = '1' else (X_nar_d1 OR Y_nar_d1 OR Y_zero_d1);
   PositEncoder: PositFastEncoder_8_2_F50_uid32
      port map ( clk  => clk,
                 Frac => XY_frac,
                 Guard => grd,
                 NZN => XY_nzn,
                 SF => XY_sf,
                 Sign => XY_finalSgn,
                 Sticky => stk,
                 R => R);
---------------------------- End of vhdl generation ----------------------------
end architecture;

