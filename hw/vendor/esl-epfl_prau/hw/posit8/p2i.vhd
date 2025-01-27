--------------------------------------------------------------------------------
--                        Normalizer_ZO_6_6_6_F50_uid4
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

entity Normalizer_ZO_6_6_6_F50_uid4 is
    port (clk : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          OZb : in  std_logic;
          Count : out  std_logic_vector(2 downto 0);
          R : out  std_logic_vector(5 downto 0)   );
end entity;

architecture arch of Normalizer_ZO_6_6_6_F50_uid4 is
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
--                  RightShifterSticky32_by_max_32_F50_uid6
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

entity RightShifterSticky32_by_max_32_F50_uid6 is
    port (clk : in std_logic;
          X : in  std_logic_vector(31 downto 0);
          S : in  std_logic_vector(5 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(31 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky32_by_max_32_F50_uid6 is
signal ps :  std_logic_vector(5 downto 0);
signal Xpadded :  std_logic_vector(31 downto 0);
signal level6 :  std_logic_vector(31 downto 0);
signal stk5 :  std_logic;
signal level5 :  std_logic_vector(31 downto 0);
signal stk4 :  std_logic;
signal level4 :  std_logic_vector(31 downto 0);
signal stk3 :  std_logic;
signal level3 :  std_logic_vector(31 downto 0);
signal stk2 :  std_logic;
signal level2 :  std_logic_vector(31 downto 0);
signal stk1 :  std_logic;
signal level1 :  std_logic_vector(31 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(31 downto 0);
begin
   ps<= S;
   Xpadded <= X;
   level6<= Xpadded;
   stk5 <= '1' when (level6(31 downto 0)/="00000000000000000000000000000000" and ps(5)='1')   else '0';
   level5 <=  level6 when  ps(5)='0'    else (31 downto 0 => padBit) ;
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1') or stk5 ='1'   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => padBit) & level5(31 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => padBit) & level4(31 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(31 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(31 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(31 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                                 Posit2Int
--                     (Posit2Int_8_2_to_32_NT_F50_uid2)
-- Version: 2023.06.14 - 171123
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles
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

entity Posit2Int is
    port (clk : in std_logic;
          X : in  std_logic_vector(7 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of Posit2Int is
   component Normalizer_ZO_6_6_6_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             OZb : in  std_logic;
             Count : out  std_logic_vector(2 downto 0);
             R : out  std_logic_vector(5 downto 0)   );
   end component;

   component RightShifterSticky32_by_max_32_F50_uid6 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(31 downto 0);
             S : in  std_logic_vector(5 downto 0);
             padBit : in  std_logic;
             R : out  std_logic_vector(31 downto 0);
             Sticky : out  std_logic   );
   end component;

signal sgn :  std_logic;
signal zn :  std_logic;
signal rc :  std_logic;
signal regPosit :  std_logic_vector(5 downto 0);
signal regLength :  std_logic_vector(2 downto 0);
signal shiftedPosit :  std_logic_vector(5 downto 0);
signal k :  std_logic_vector(3 downto 0);
signal exp :  std_logic_vector(1 downto 0);
signal sgnVect :  std_logic_vector(1 downto 0);
signal actualExp :  std_logic_vector(1 downto 0);
signal sf :  std_logic_vector(5 downto 0);
signal paddedFrac :  std_logic_vector(31 downto 0);
signal shiftVal :  std_logic_vector(5 downto 0);
signal shiftedFrac :  std_logic_vector(31 downto 0);
signal stk :  std_logic;
signal sticky :  std_logic;
signal rnd :  std_logic;
signal lsb :  std_logic;
signal round :  std_logic;
signal intNumber :  std_logic_vector(31 downto 0);
signal result :  std_logic_vector(31 downto 0);
begin
--------------------------- Start of vhdl generation ---------------------------
------------------------------- Extract Sign bit -------------------------------
   sgn <= X(7);
   zn <= '1' when (X(6 downto 0) = "0000000") else '0';
-------------- Count leading zeros/ones of regime & shift it out --------------
   rc <= X(6);
   regPosit <= X(5 downto 0);
   LZOCAndShifter: Normalizer_ZO_6_6_6_F50_uid4
      port map ( clk  => clk,
                 OZb => rc,
                 X => regPosit,
                 Count => regLength,
                 R => shiftedPosit);
----------------- Determine the scaling factor - regime & exp -----------------
   k <= "0" & regLength when rc /= sgn else "1" & NOT(regLength);
   exp <=  shiftedPosit(4 downto 3);
   sgnVect <=  (others => sgn);
   actualExp <=  (sgnVect XOR exp);
   sf <=  k & actualExp;
------------------------------- Extract fraction -------------------------------
   paddedFrac <= NOT(sgn) & shiftedPosit(2 downto 0) & "0000000000000000000000000000";
---------------- Shift out fraction according to scaling factor ----------------
   shiftVal <= "011110" - sf;
   RightShifterComponent: RightShifterSticky32_by_max_32_F50_uid6
      port map ( clk  => clk,
                 S => shiftVal,
                 X => paddedFrac,
                 padBit => sgn,
                 R => shiftedFrac,
                 Sticky => stk);
   sticky <= stk;
   rnd <= shiftedFrac(0);
   lsb <= shiftedFrac(1);
   round <= rnd AND (lsb OR sticky);
   intNumber <= (sgn & shiftedFrac(31 downto 1)) + round;
   result <= intNumber when zn = '0' else (sgn & "0000000000000000000000000000000");
   R <= result;
---------------------------- End of vhdl generation ----------------------------
end architecture;

