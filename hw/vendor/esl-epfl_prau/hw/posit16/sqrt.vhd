--------------------------------------------------------------------------------
--                      Normalizer_ZO_14_14_14_F50_uid6
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

entity Normalizer_ZO_14_14_14_F50_uid6 is
    port (clk : in std_logic;
          X : in  std_logic_vector(13 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(3 downto 0);
          R : out  std_logic_vector(13 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_14_14_14_F50_uid6 is
signal level4 :  std_logic_vector(13 downto 0);
signal sozb :  std_logic;
signal count3 :  std_logic;
signal level3 :  std_logic_vector(13 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(13 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(13 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(13 downto 0);
signal sCount :  std_logic_vector(3 downto 0);
begin
   level4 <= X ;
   sozb<= OZb;
   count3<= '1' when level4(13 downto 6) = (13 downto 6=>sozb) else '0';
   level3<= level4(13 downto 0) when count3='0' else level4(5 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(13 downto 10) = (13 downto 10=>sozb) else '0';
   level2<= level3(13 downto 0) when count2='0' else level3(9 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(13 downto 12) = (13 downto 12=>sozb) else '0';
   level1<= level2(13 downto 0) when count1='0' else level2(11 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(13 downto 13) = (13 downto 13=>sozb) else '0';
   level0<= level1(13 downto 0) when count0='0' else level1(12 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                       PositFastDecoder_16_2_F50_uid4
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

entity PositFastDecoder_16_2_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(15 downto 0);
          Sign : out  std_logic;
          SF : out  std_logic_vector(6 downto 0);
          Frac : out  std_logic_vector(10 downto 0);
          NZN : out  std_logic   );
end entity;

architecture arch of PositFastDecoder_16_2_F50_uid4 is
   component Normalizer_ZO_14_14_14_F50_uid6 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(13 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(3 downto 0);
             R : out  std_logic_vector(13 downto 0)   );
   end component;

signal sgn :  std_logic;
signal pNZN :  std_logic;
signal rc :  std_logic;
signal regPosit :  std_logic_vector(13 downto 0);
signal regLength :  std_logic_vector(3 downto 0);
signal shiftedPosit :  std_logic_vector(13 downto 0);
signal k :  std_logic_vector(4 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal pSF :  std_logic_vector(6 downto 0);
signal pFrac :  std_logic_vector(10 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
--------------------------- Sign bit & special cases ---------------------------
   sgn <= X(15);
   pNZN <= '0' when (X(14 downto 0) = "000000000000000") else '1';
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= X(14);
   regPosit <= X(13 downto 0);
   RegimeCounter: Normalizer_ZO_14_14_14_F50_uid6
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= "0" & regLength when rc /= sgn else "1" & NOT(regLength);
   sgnVect <= (others => sgn);
   exp <= shiftedPosit(12 downto 11) XOR sgnVect;
   pSF <= k & exp;
------------------------------- Extract fraction -------------------------------
   pFrac <= shiftedPosit(10 downto 0);
   Sign <= sgn;
   SF <= pSF;
   Frac <= pFrac;
   NZN <= pNZN;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_15_F50_uid8
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

entity IntAdder_15_F50_uid8 is
    port (clk : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid8 is
signal Rtmp :  std_logic_vector(14 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid10
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

entity IntAdder_15_F50_uid10 is
    port (clk : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid10 is
signal Rtmp :  std_logic_vector(14 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid12
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

entity IntAdder_15_F50_uid12 is
    port (clk : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid12 is
signal Rtmp :  std_logic_vector(14 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid14
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

entity IntAdder_15_F50_uid14 is
    port (clk : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid14 is
signal Rtmp :  std_logic_vector(14 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid16
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

entity IntAdder_15_F50_uid16 is
    port (clk : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid16 is
signal Rtmp :  std_logic_vector(14 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid18
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

entity IntAdder_15_F50_uid18 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid18 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal X_d1 :  std_logic_vector(14 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               X_d1 <=  X;
               Cin_d1 <=  Cin;
            end if;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid20
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

entity IntAdder_15_F50_uid20 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid20 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               Cin_d1 <=  Cin;
            end if;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid22
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

entity IntAdder_15_F50_uid22 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid22 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               Cin_d1 <=  Cin;
            end if;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid24
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

entity IntAdder_15_F50_uid24 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid24 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               Cin_d1 <=  Cin;
            end if;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid26
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

entity IntAdder_15_F50_uid26 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid26 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               Cin_d1 <=  Cin;
            end if;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid28
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

entity IntAdder_15_F50_uid28 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid28 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               Cin_d1 <=  Cin;
            end if;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid30
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

entity IntAdder_15_F50_uid30 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid30 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               Cin_d1 <=  Cin;
            end if;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d1;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid32
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

entity IntAdder_15_F50_uid32 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid32 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal X_d1 :  std_logic_vector(14 downto 0);
signal Cin_d1, Cin_d2 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               X_d1 <=  X;
               Cin_d1 <=  Cin;
               Cin_d2 <=  Cin_d1;
            end if;
         end if;
      end process;
   Rtmp <= X_d1 + Y + Cin_d2;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_15_F50_uid34
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

entity IntAdder_15_F50_uid34 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          Y : in  std_logic_vector(14 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(14 downto 0)   );
end entity;

architecture arch of IntAdder_15_F50_uid34 is
signal Rtmp :  std_logic_vector(14 downto 0);
signal Cin_d1, Cin_d2 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               Cin_d1 <=  Cin;
               Cin_d2 <=  Cin_d1;
            end if;
         end if;
      end process;
   Rtmp <= X + Y + Cin_d2;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky15_by_max_15_F50_uid38
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

entity RightShifterSticky15_by_max_15_F50_uid38 is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(14 downto 0);
          S : in  std_logic_vector(3 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(14 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky15_by_max_15_F50_uid38 is
signal ps, ps_d1, ps_d2 :  std_logic_vector(3 downto 0);
signal Xpadded :  std_logic_vector(14 downto 0);
signal level4 :  std_logic_vector(14 downto 0);
signal stk3 :  std_logic;
signal level3 :  std_logic_vector(14 downto 0);
signal stk2 :  std_logic;
signal level2 :  std_logic_vector(14 downto 0);
signal stk1 :  std_logic;
signal level1 :  std_logic_vector(14 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(14 downto 0);
signal padBit_d1, padBit_d2 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               ps_d1 <=  ps;
               ps_d2 <=  ps_d1;
               padBit_d1 <=  padBit;
               padBit_d2 <=  padBit_d1;
            end if;
         end if;
      end process;
   ps<= S;
   Xpadded <= X;
   level4<= Xpadded;
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps_d2(3)='1')   else '0';
   level3 <=  level4 when  ps_d2(3)='0'    else (7 downto 0 => padBit_d2) & level4(14 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps_d2(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps_d2(2)='0'    else (3 downto 0 => padBit_d2) & level3(14 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps_d2(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps_d2(1)='0'    else (1 downto 0 => padBit_d2) & level2(14 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps_d2(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps_d2(0)='0'    else (0 downto 0 => padBit_d2) & level1(14 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                      PositFastEncoder_16_2_F50_uid36
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

entity PositFastEncoder_16_2_F50_uid36 is
    port (clk : in std_logic;
          en : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(7 downto 0);
          Frac : in  std_logic_vector(10 downto 0);
          Guard : in  std_logic;
          Sticky : in  std_logic;
          NZN : in  std_logic;
          R : out  std_logic_vector(15 downto 0)   );
end entity;

architecture arch of PositFastEncoder_16_2_F50_uid36 is
   component RightShifterSticky15_by_max_15_F50_uid38 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             S : in  std_logic_vector(3 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(14 downto 0);
             Sticky : out  std_logic   );
   end component;

signal rc :  std_logic;
signal rcVect :  std_logic_vector(4 downto 0);
signal k :  std_logic_vector(4 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal exp, exp_d1, exp_d2 :  std_logic_vector(1 downto 0);
signal ovf, ovf_d1, ovf_d2 :  std_logic;
signal regValue :  std_logic_vector(3 downto 0);
signal regNeg, regNeg_d1, regNeg_d2 :  std_logic;
signal padBit, padBit_d1, padBit_d2 :  std_logic;
signal inputShifter :  std_logic_vector(14 downto 0);
signal shiftedPosit :  std_logic_vector(14 downto 0);
signal stkBit :  std_logic;
signal unroundedPosit :  std_logic_vector(14 downto 0);
signal lsb :  std_logic;
signal rnd :  std_logic;
signal stk :  std_logic;
signal round :  std_logic;
signal roundedPosit :  std_logic_vector(14 downto 0);
signal unsignedPosit :  std_logic_vector(14 downto 0);
signal Sign_d1, Sign_d2 :  std_logic;
signal NZN_d1, NZN_d2 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               exp_d1 <=  exp;
               exp_d2 <=  exp_d1;
               ovf_d1 <=  ovf;
               ovf_d2 <=  ovf_d1;
               regNeg_d1 <=  regNeg;
               regNeg_d2 <=  regNeg_d1;
               padBit_d1 <=  padBit;
               padBit_d2 <=  padBit_d1;
               Sign_d1 <=  Sign;
               Sign_d2 <=  Sign_d1;
               NZN_d1 <=  NZN;
               NZN_d2 <=  NZN_d1;
            end if;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
----------------------------- Get value of regime -----------------------------
   rc <= SF(SF'high);
   rcVect <= (others => rc);
   k <= SF(6 downto 2) XOR rcVect;
   sgnVect <= (others => Sign);
   exp <= SF(1 downto 0) XOR sgnVect;
   -- Check for regime overflow
   ovf <= '1' when (k > "01101") else '0';
   regValue <= k(3 downto 0) when ovf = '0' else "1110";
-------------- Generate regime - shift out exponent and fraction --------------
   regNeg <= Sign XOR rc;
   padBit <= NOT(regNeg);
   inputShifter <= regNeg_d2 & exp_d2 & Frac & Guard;
   RegimeGenerator: RightShifterSticky15_by_max_15_F50_uid38
      port map ( clk  => clk,
                 en => en,
                 S => regValue,
                 X => inputShifter,
                 padBit => padBit,
                 R => shiftedPosit,
                 Sticky => stkBit);
   unroundedPosit <= padBit_d2 & shiftedPosit(14 downto 1);
---------------------------- Round to nearest even ----------------------------
   lsb <= shiftedPosit(1);
   rnd <= shiftedPosit(0);
   stk <= stkBit OR Sticky;
   round <= rnd AND (lsb OR stk OR ovf_d2);
   roundedPosit <= unroundedPosit + round;
-------------------------- Check sign & Special Cases --------------------------
   unsignedPosit <= roundedPosit when NZN_d2 = '1' else (others => '0');
   R <= Sign_d2 & unsignedPosit;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                 PositSqrt
--                         (PositSqrt_16_2_F50_uid2)
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles
-- Clock period (ns): 20
-- Target frequency (MHz): 50
-- Input signals: X
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity PositSqrt is
    port (clk : in std_logic;
          en : in std_logic;
          X : in  std_logic_vector(15 downto 0);
          R : out  std_logic_vector(15 downto 0)   );
end entity;

architecture arch of PositSqrt is
   component PositFastDecoder_16_2_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(15 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(6 downto 0);
             Frac : out  std_logic_vector(10 downto 0);
             NZN : out  std_logic   );
   end component;

   component IntAdder_15_F50_uid8 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid10 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid12 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid14 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid16 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid18 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid20 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid22 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid24 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid26 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid28 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid30 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid32 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component IntAdder_15_F50_uid34 is
      port ( clk : in std_logic;
             en : in std_logic;
             X : in  std_logic_vector(14 downto 0);
             Y : in  std_logic_vector(14 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(14 downto 0)   );
   end component;

   component PositFastEncoder_16_2_F50_uid36 is
      port ( clk : in std_logic; 
             en : in std_logic;
             Sign : in  std_logic;
             SF : in  std_logic_vector(7 downto 0);
             Frac : in  std_logic_vector(10 downto 0);
             Guard : in  std_logic;
             Sticky : in  std_logic;
             NZN : in  std_logic;
             R : out  std_logic_vector(15 downto 0)   );
   end component;

signal X_sgn :  std_logic;
signal X_sf :  std_logic_vector(6 downto 0);
signal X_f :  std_logic_vector(10 downto 0);
signal X_nzn :  std_logic;
signal XY_nzn :  std_logic;
signal XY_finalSgn :  std_logic;
signal odd_exp :  std_logic;
signal X_sf_3 :  std_logic_vector(7 downto 0);
signal one_bit :  std_logic;
signal r_0 :  std_logic_vector(14 downto 0);
signal q_0 :  std_logic_vector(13 downto 0);
signal real_q_0 :  std_logic_vector(13 downto 0);
signal pow_2_0 :  std_logic_vector(14 downto 0);
signal s_0 :  std_logic;
signal q_1 :  std_logic_vector(13 downto 0);
signal real_q_1 :  std_logic_vector(13 downto 0);
signal two_r_0 :  std_logic_vector(14 downto 0);
signal two_q_0 :  std_logic_vector(14 downto 0);
signal pow_2_1 :  std_logic_vector(14 downto 0);
signal n_0 :  std_logic_vector(14 downto 0);
signal r_1 :  std_logic_vector(14 downto 0);
signal rem_z_0 :  std_logic;
signal z_1 :  std_logic;
signal s_1 :  std_logic;
signal q_2 :  std_logic_vector(13 downto 0);
signal real_q_2 :  std_logic_vector(13 downto 0);
signal two_r_1 :  std_logic_vector(14 downto 0);
signal two_q_1 :  std_logic_vector(14 downto 0);
signal pow_2_2 :  std_logic_vector(14 downto 0);
signal n_1 :  std_logic_vector(14 downto 0);
signal r_2 :  std_logic_vector(14 downto 0);
signal rem_z_1 :  std_logic;
signal z_2 :  std_logic;
signal s_2 :  std_logic;
signal q_3 :  std_logic_vector(13 downto 0);
signal real_q_3 :  std_logic_vector(13 downto 0);
signal two_r_2 :  std_logic_vector(14 downto 0);
signal two_q_2 :  std_logic_vector(14 downto 0);
signal pow_2_3 :  std_logic_vector(14 downto 0);
signal n_2 :  std_logic_vector(14 downto 0);
signal r_3 :  std_logic_vector(14 downto 0);
signal rem_z_2 :  std_logic;
signal z_3 :  std_logic;
signal s_3 :  std_logic;
signal q_4 :  std_logic_vector(13 downto 0);
signal real_q_4 :  std_logic_vector(13 downto 0);
signal two_r_3 :  std_logic_vector(14 downto 0);
signal two_q_3 :  std_logic_vector(14 downto 0);
signal pow_2_4 :  std_logic_vector(14 downto 0);
signal n_3 :  std_logic_vector(14 downto 0);
signal r_4 :  std_logic_vector(14 downto 0);
signal rem_z_3 :  std_logic;
signal z_4, z_4_d1 :  std_logic;
signal s_4 :  std_logic;
signal q_5, q_5_d1 :  std_logic_vector(13 downto 0);
signal real_q_5, real_q_5_d1 :  std_logic_vector(13 downto 0);
signal two_r_4 :  std_logic_vector(14 downto 0);
signal two_q_4 :  std_logic_vector(14 downto 0);
signal pow_2_5 :  std_logic_vector(14 downto 0);
signal n_4 :  std_logic_vector(14 downto 0);
signal r_5 :  std_logic_vector(14 downto 0);
signal rem_z_4, rem_z_4_d1 :  std_logic;
signal z_5 :  std_logic;
signal s_5, s_5_d1 :  std_logic;
signal q_6 :  std_logic_vector(13 downto 0);
signal real_q_6 :  std_logic_vector(13 downto 0);
signal two_r_5 :  std_logic_vector(14 downto 0);
signal two_q_5, two_q_5_d1 :  std_logic_vector(14 downto 0);
signal pow_2_6, pow_2_6_d1 :  std_logic_vector(14 downto 0);
signal n_5 :  std_logic_vector(14 downto 0);
signal r_6 :  std_logic_vector(14 downto 0);
signal rem_z_5 :  std_logic;
signal z_6 :  std_logic;
signal s_6 :  std_logic;
signal q_7 :  std_logic_vector(13 downto 0);
signal real_q_7 :  std_logic_vector(13 downto 0);
signal two_r_6 :  std_logic_vector(14 downto 0);
signal two_q_6 :  std_logic_vector(14 downto 0);
signal pow_2_7, pow_2_7_d1 :  std_logic_vector(14 downto 0);
signal n_6 :  std_logic_vector(14 downto 0);
signal r_7 :  std_logic_vector(14 downto 0);
signal rem_z_6 :  std_logic;
signal z_7 :  std_logic;
signal s_7 :  std_logic;
signal q_8 :  std_logic_vector(13 downto 0);
signal real_q_8 :  std_logic_vector(13 downto 0);
signal two_r_7 :  std_logic_vector(14 downto 0);
signal two_q_7 :  std_logic_vector(14 downto 0);
signal pow_2_8, pow_2_8_d1 :  std_logic_vector(14 downto 0);
signal n_7 :  std_logic_vector(14 downto 0);
signal r_8 :  std_logic_vector(14 downto 0);
signal rem_z_7 :  std_logic;
signal z_8 :  std_logic;
signal s_8 :  std_logic;
signal q_9 :  std_logic_vector(13 downto 0);
signal real_q_9 :  std_logic_vector(13 downto 0);
signal two_r_8 :  std_logic_vector(14 downto 0);
signal two_q_8 :  std_logic_vector(14 downto 0);
signal pow_2_9, pow_2_9_d1 :  std_logic_vector(14 downto 0);
signal n_8 :  std_logic_vector(14 downto 0);
signal r_9 :  std_logic_vector(14 downto 0);
signal rem_z_8 :  std_logic;
signal z_9 :  std_logic;
signal s_9 :  std_logic;
signal q_10 :  std_logic_vector(13 downto 0);
signal real_q_10 :  std_logic_vector(13 downto 0);
signal two_r_9 :  std_logic_vector(14 downto 0);
signal two_q_9 :  std_logic_vector(14 downto 0);
signal pow_2_10, pow_2_10_d1 :  std_logic_vector(14 downto 0);
signal n_9 :  std_logic_vector(14 downto 0);
signal r_10 :  std_logic_vector(14 downto 0);
signal rem_z_9 :  std_logic;
signal z_10 :  std_logic;
signal s_10 :  std_logic;
signal q_11 :  std_logic_vector(13 downto 0);
signal real_q_11 :  std_logic_vector(13 downto 0);
signal two_r_10 :  std_logic_vector(14 downto 0);
signal two_q_10 :  std_logic_vector(14 downto 0);
signal pow_2_11, pow_2_11_d1 :  std_logic_vector(14 downto 0);
signal n_10 :  std_logic_vector(14 downto 0);
signal r_11 :  std_logic_vector(14 downto 0);
signal rem_z_10 :  std_logic;
signal z_11, z_11_d1 :  std_logic;
signal s_11 :  std_logic;
signal q_12, q_12_d1 :  std_logic_vector(13 downto 0);
signal real_q_12, real_q_12_d1 :  std_logic_vector(13 downto 0);
signal two_r_11 :  std_logic_vector(14 downto 0);
signal two_q_11 :  std_logic_vector(14 downto 0);
signal pow_2_12, pow_2_12_d1 :  std_logic_vector(14 downto 0);
signal n_11 :  std_logic_vector(14 downto 0);
signal r_12 :  std_logic_vector(14 downto 0);
signal rem_z_11, rem_z_11_d1 :  std_logic;
signal z_12 :  std_logic;
signal s_12, s_12_d1 :  std_logic;
signal q_13 :  std_logic_vector(13 downto 0);
signal real_q_13 :  std_logic_vector(13 downto 0);
signal two_r_12 :  std_logic_vector(14 downto 0);
signal two_q_12, two_q_12_d1 :  std_logic_vector(14 downto 0);
signal pow_2_13, pow_2_13_d1, pow_2_13_d2 :  std_logic_vector(14 downto 0);
signal n_12 :  std_logic_vector(14 downto 0);
signal r_13 :  std_logic_vector(14 downto 0);
signal rem_z_12 :  std_logic;
signal z_13 :  std_logic;
signal s_13 :  std_logic;
signal q_14 :  std_logic_vector(13 downto 0);
signal real_q_14 :  std_logic_vector(13 downto 0);
signal two_r_13 :  std_logic_vector(14 downto 0);
signal two_q_13 :  std_logic_vector(14 downto 0);
signal pow_2_14, pow_2_14_d1, pow_2_14_d2 :  std_logic_vector(14 downto 0);
signal n_13 :  std_logic_vector(14 downto 0);
signal r_14 :  std_logic_vector(14 downto 0);
signal rem_z_13 :  std_logic;
signal z_14 :  std_logic;
signal sqrt_f :  std_logic_vector(13 downto 0);
signal XY_sf :  std_logic_vector(7 downto 0);
signal XY_frac :  std_logic_vector(10 downto 0);
signal grd :  std_logic;
signal stk :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            if en = '1' then
               z_4_d1 <=  z_4;
               q_5_d1 <=  q_5;
               real_q_5_d1 <=  real_q_5;
               rem_z_4_d1 <=  rem_z_4;
               s_5_d1 <=  s_5;
               two_q_5_d1 <=  two_q_5;
               pow_2_6_d1 <=  pow_2_6;
               pow_2_7_d1 <=  pow_2_7;
               pow_2_8_d1 <=  pow_2_8;
               pow_2_9_d1 <=  pow_2_9;
               pow_2_10_d1 <=  pow_2_10;
               pow_2_11_d1 <=  pow_2_11;
               z_11_d1 <=  z_11;
               q_12_d1 <=  q_12;
               real_q_12_d1 <=  real_q_12;
               pow_2_12_d1 <=  pow_2_12;
               rem_z_11_d1 <=  rem_z_11;
               s_12_d1 <=  s_12;
               two_q_12_d1 <=  two_q_12;
               pow_2_13_d1 <=  pow_2_13;
               pow_2_13_d2 <=  pow_2_13_d1;
               pow_2_14_d1 <=  pow_2_14;
               pow_2_14_d2 <=  pow_2_14_d1;
            end if;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
------------------------------- Decode X operand -------------------------------
   X_decoder: PositFastDecoder_16_2_F50_uid4
      port map ( clk  => clk,
                 X => X,
                 Frac => X_f,
                 NZN => X_nzn,
                 SF => X_sf,
                 Sign => X_sgn);
   -- Sign and Special Cases Computation
   XY_nzn <= NOT(X_sgn) AND X_nzn;
   XY_finalSgn <= X_sgn;
----------------------------- Exponent computation -----------------------------
   odd_exp <= X_sf(0);
   -- Divide exponent by 2
   X_sf_3 <= X_sf(X_sf'high) & X_sf(X_sf'high) & X_sf(6 downto 1);
----------------------------- Sqrt of the fraction -----------------------------
--------------------------- Non-Restoring algorithm ---------------------------
   one_bit <= '1';
   r_0 <= ("001" & X_f & '0') when odd_exp='1' else ("0001" & X_f);
   q_0 <= (others => '0');
   real_q_0 <= (others => '0');
   pow_2_0 <= "010000000000000";
   -- Iteration 1
   s_0 <= r_0(14);
   q_1 <= NOT(s_0) & "0000000000000";
   real_q_1 <= (s_0) & "0000000000000";
   two_r_0 <= r_0(13 downto 0) & '0';
   two_q_0 <= (others => '0');
   pow_2_1 <= '0' & pow_2_0(14 downto 1);
   n_0 <= (two_q_0 + NOT(pow_2_1)) when s_0='1' else NOT(two_q_0 + pow_2_1);
   sub_1: IntAdder_15_F50_uid8
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_0,
                 Y => n_0,
                 R => r_1);
   rem_z_0 <= '1' when r_1 = 0 else '0';
   z_1 <= rem_z_0;
   -- Iteration 2
   s_1 <= r_1(14);
   q_2 <= q_1(13 downto 13) & NOT(s_1 OR z_1) & "000000000000";
   real_q_2 <= q_2(12 downto 12) & '1' & "000000000000" when z_1='0' else real_q_1;
   two_r_1 <= r_1(13 downto 0) & '0';
   two_q_1 <= '0' & '1' & "0000000000000";
   pow_2_2 <= '0' & pow_2_1(14 downto 1);
   n_1 <= (two_q_1 + NOT(pow_2_2)) when s_1='1' else NOT(two_q_1 + pow_2_2);
   sub_2: IntAdder_15_F50_uid10
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_1,
                 Y => n_1,
                 R => r_2);
   rem_z_1 <= '1' when r_2 = 0 else '0';
   z_2 <= rem_z_1 OR z_1;
   -- Iteration 3
   s_2 <= r_2(14);
   q_3 <= q_2(13 downto 12) & NOT(s_2 OR z_2) & "00000000000";
   real_q_3 <= q_3(12 downto 11) & '1' & "00000000000" when z_2='0' else real_q_2;
   two_r_2 <= r_2(13 downto 0) & '0';
   two_q_2 <= '0' & q_2(12 downto 12) & '1' & "000000000000";
   pow_2_3 <= '0' & pow_2_2(14 downto 1);
   n_2 <= (two_q_2 + NOT(pow_2_3)) when s_2='1' else NOT(two_q_2 + pow_2_3);
   sub_3: IntAdder_15_F50_uid12
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_2,
                 Y => n_2,
                 R => r_3);
   rem_z_2 <= '1' when r_3 = 0 else '0';
   z_3 <= rem_z_2 OR z_2;
   -- Iteration 4
   s_3 <= r_3(14);
   q_4 <= q_3(13 downto 11) & NOT(s_3 OR z_3) & "0000000000";
   real_q_4 <= q_4(12 downto 10) & '1' & "0000000000" when z_3='0' else real_q_3;
   two_r_3 <= r_3(13 downto 0) & '0';
   two_q_3 <= '0' & q_3(12 downto 11) & '1' & "00000000000";
   pow_2_4 <= '0' & pow_2_3(14 downto 1);
   n_3 <= (two_q_3 + NOT(pow_2_4)) when s_3='1' else NOT(two_q_3 + pow_2_4);
   sub_4: IntAdder_15_F50_uid14
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_3,
                 Y => n_3,
                 R => r_4);
   rem_z_3 <= '1' when r_4 = 0 else '0';
   z_4 <= rem_z_3 OR z_3;
   -- Iteration 5
   s_4 <= r_4(14);
   q_5 <= q_4(13 downto 10) & NOT(s_4 OR z_4) & "000000000";
   real_q_5 <= q_5(12 downto 9) & '1' & "000000000" when z_4='0' else real_q_4;
   two_r_4 <= r_4(13 downto 0) & '0';
   two_q_4 <= '0' & q_4(12 downto 10) & '1' & "0000000000";
   pow_2_5 <= '0' & pow_2_4(14 downto 1);
   n_4 <= (two_q_4 + NOT(pow_2_5)) when s_4='1' else NOT(two_q_4 + pow_2_5);
   sub_5: IntAdder_15_F50_uid16
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_4,
                 Y => n_4,
                 R => r_5);
   rem_z_4 <= '1' when r_5 = 0 else '0';
   z_5 <= rem_z_4_d1 OR z_4_d1;
   -- Iteration 6
   s_5 <= r_5(14);
   q_6 <= q_5_d1(13 downto 9) & NOT(s_5_d1 OR z_5) & "00000000";
   real_q_6 <= q_6(12 downto 8) & '1' & "00000000" when z_5='0' else real_q_5_d1;
   two_r_5 <= r_5(13 downto 0) & '0';
   two_q_5 <= '0' & q_5(12 downto 9) & '1' & "000000000";
   pow_2_6 <= '0' & pow_2_5(14 downto 1);
   n_5 <= (two_q_5_d1 + NOT(pow_2_6_d1)) when s_5_d1='1' else NOT(two_q_5_d1 + pow_2_6_d1);
   sub_6: IntAdder_15_F50_uid18
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_5,
                 Y => n_5,
                 R => r_6);
   rem_z_5 <= '1' when r_6 = 0 else '0';
   z_6 <= rem_z_5 OR z_5;
   -- Iteration 7
   s_6 <= r_6(14);
   q_7 <= q_6(13 downto 8) & NOT(s_6 OR z_6) & "0000000";
   real_q_7 <= q_7(12 downto 7) & '1' & "0000000" when z_6='0' else real_q_6;
   two_r_6 <= r_6(13 downto 0) & '0';
   two_q_6 <= '0' & q_6(12 downto 8) & '1' & "00000000";
   pow_2_7 <= '0' & pow_2_6(14 downto 1);
   n_6 <= (two_q_6 + NOT(pow_2_7_d1)) when s_6='1' else NOT(two_q_6 + pow_2_7_d1);
   sub_7: IntAdder_15_F50_uid20
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_6,
                 Y => n_6,
                 R => r_7);
   rem_z_6 <= '1' when r_7 = 0 else '0';
   z_7 <= rem_z_6 OR z_6;
   -- Iteration 8
   s_7 <= r_7(14);
   q_8 <= q_7(13 downto 7) & NOT(s_7 OR z_7) & "000000";
   real_q_8 <= q_8(12 downto 6) & '1' & "000000" when z_7='0' else real_q_7;
   two_r_7 <= r_7(13 downto 0) & '0';
   two_q_7 <= '0' & q_7(12 downto 7) & '1' & "0000000";
   pow_2_8 <= '0' & pow_2_7(14 downto 1);
   n_7 <= (two_q_7 + NOT(pow_2_8_d1)) when s_7='1' else NOT(two_q_7 + pow_2_8_d1);
   sub_8: IntAdder_15_F50_uid22
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_7,
                 Y => n_7,
                 R => r_8);
   rem_z_7 <= '1' when r_8 = 0 else '0';
   z_8 <= rem_z_7 OR z_7;
   -- Iteration 9
   s_8 <= r_8(14);
   q_9 <= q_8(13 downto 6) & NOT(s_8 OR z_8) & "00000";
   real_q_9 <= q_9(12 downto 5) & '1' & "00000" when z_8='0' else real_q_8;
   two_r_8 <= r_8(13 downto 0) & '0';
   two_q_8 <= '0' & q_8(12 downto 6) & '1' & "000000";
   pow_2_9 <= '0' & pow_2_8(14 downto 1);
   n_8 <= (two_q_8 + NOT(pow_2_9_d1)) when s_8='1' else NOT(two_q_8 + pow_2_9_d1);
   sub_9: IntAdder_15_F50_uid24
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_8,
                 Y => n_8,
                 R => r_9);
   rem_z_8 <= '1' when r_9 = 0 else '0';
   z_9 <= rem_z_8 OR z_8;
   -- Iteration 10
   s_9 <= r_9(14);
   q_10 <= q_9(13 downto 5) & NOT(s_9 OR z_9) & "0000";
   real_q_10 <= q_10(12 downto 4) & '1' & "0000" when z_9='0' else real_q_9;
   two_r_9 <= r_9(13 downto 0) & '0';
   two_q_9 <= '0' & q_9(12 downto 5) & '1' & "00000";
   pow_2_10 <= '0' & pow_2_9(14 downto 1);
   n_9 <= (two_q_9 + NOT(pow_2_10_d1)) when s_9='1' else NOT(two_q_9 + pow_2_10_d1);
   sub_10: IntAdder_15_F50_uid26
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_9,
                 Y => n_9,
                 R => r_10);
   rem_z_9 <= '1' when r_10 = 0 else '0';
   z_10 <= rem_z_9 OR z_9;
   -- Iteration 11
   s_10 <= r_10(14);
   q_11 <= q_10(13 downto 4) & NOT(s_10 OR z_10) & "000";
   real_q_11 <= q_11(12 downto 3) & '1' & "000" when z_10='0' else real_q_10;
   two_r_10 <= r_10(13 downto 0) & '0';
   two_q_10 <= '0' & q_10(12 downto 4) & '1' & "0000";
   pow_2_11 <= '0' & pow_2_10(14 downto 1);
   n_10 <= (two_q_10 + NOT(pow_2_11_d1)) when s_10='1' else NOT(two_q_10 + pow_2_11_d1);
   sub_11: IntAdder_15_F50_uid28
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_10,
                 Y => n_10,
                 R => r_11);
   rem_z_10 <= '1' when r_11 = 0 else '0';
   z_11 <= rem_z_10 OR z_10;
   -- Iteration 12
   s_11 <= r_11(14);
   q_12 <= q_11(13 downto 3) & NOT(s_11 OR z_11) & "00";
   real_q_12 <= q_12(12 downto 2) & '1' & "00" when z_11='0' else real_q_11;
   two_r_11 <= r_11(13 downto 0) & '0';
   two_q_11 <= '0' & q_11(12 downto 3) & '1' & "000";
   pow_2_12 <= '0' & pow_2_11(14 downto 1);
   n_11 <= (two_q_11 + NOT(pow_2_12_d1)) when s_11='1' else NOT(two_q_11 + pow_2_12_d1);
   sub_12: IntAdder_15_F50_uid30
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_11,
                 Y => n_11,
                 R => r_12);
   rem_z_11 <= '1' when r_12 = 0 else '0';
   z_12 <= rem_z_11_d1 OR z_11_d1;
   -- Iteration 13
   s_12 <= r_12(14);
   q_13 <= q_12_d1(13 downto 2) & NOT(s_12_d1 OR z_12) & "0";
   real_q_13 <= q_13(12 downto 1) & '1' & "0" when z_12='0' else real_q_12_d1;
   two_r_12 <= r_12(13 downto 0) & '0';
   two_q_12 <= '0' & q_12(12 downto 2) & '1' & "00";
   pow_2_13 <= '0' & pow_2_12(14 downto 1);
   n_12 <= (two_q_12_d1 + NOT(pow_2_13_d2)) when s_12_d1='1' else NOT(two_q_12_d1 + pow_2_13_d2);
   sub_13: IntAdder_15_F50_uid32
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_12,
                 Y => n_12,
                 R => r_13);
   rem_z_12 <= '1' when r_13 = 0 else '0';
   z_13 <= rem_z_12 OR z_12;
   -- Iteration 14
   s_13 <= r_13(14);
   q_14 <= q_13(13 downto 1) & NOT(s_13 OR z_13) & "";
   real_q_14 <= q_14(12 downto 0) & '1' & "" when z_13='0' else real_q_13;
   two_r_13 <= r_13(13 downto 0) & '0';
   two_q_13 <= '0' & q_13(12 downto 1) & '1' & "0";
   pow_2_14 <= '0' & pow_2_13(14 downto 1);
   n_13 <= (two_q_13 + NOT(pow_2_14_d2)) when s_13='1' else NOT(two_q_13 + pow_2_14_d2);
   sub_14: IntAdder_15_F50_uid34
      port map ( clk  => clk,
                 en => en,
                 Cin => one_bit,
                 X => two_r_13,
                 Y => n_13,
                 R => r_14);
   rem_z_13 <= '1' when r_14 = 0 else '0';
   z_14 <= rem_z_13 OR z_13;
   -- Convert the quotient to the digit set {0,1}
   sqrt_f <= q_14(12 downto 0) & '1' when z_13='0' else real_q_14; -- get the double of sqrt: first bit (=0) shifted out
----------------------------- Generate final posit -----------------------------
   XY_sf <= X_sf_3;
   XY_frac <= sqrt_f(12 downto 2);
   grd <= sqrt_f(1);
   stk <= sqrt_f(0);
   PositEncoder: PositFastEncoder_16_2_F50_uid36
      port map ( clk  => clk,
                 en => en,
                 Frac => XY_frac,
                 Guard => grd,
                 NZN => XY_nzn,
                 SF => XY_sf,
                 Sign => XY_finalSgn,
                 Sticky => stk,
                 R => R);
---------------------------- End of vhdl generation ----------------------------
end architecture;

