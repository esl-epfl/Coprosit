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
--                            IntAdder_7_F50_uid8
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

entity IntAdder_7_F50_uid8 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          Y : in  std_logic_vector(6 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(6 downto 0)   );
end entity;

architecture arch of IntAdder_7_F50_uid8 is
signal Rtmp :  std_logic_vector(6 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_7_F50_uid10
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

entity IntAdder_7_F50_uid10 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          Y : in  std_logic_vector(6 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(6 downto 0)   );
end entity;

architecture arch of IntAdder_7_F50_uid10 is
signal Rtmp :  std_logic_vector(6 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_7_F50_uid12
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

entity IntAdder_7_F50_uid12 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          Y : in  std_logic_vector(6 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(6 downto 0)   );
end entity;

architecture arch of IntAdder_7_F50_uid12 is
signal Rtmp :  std_logic_vector(6 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_7_F50_uid14
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

entity IntAdder_7_F50_uid14 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          Y : in  std_logic_vector(6 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(6 downto 0)   );
end entity;

architecture arch of IntAdder_7_F50_uid14 is
signal Rtmp :  std_logic_vector(6 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_7_F50_uid16
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

entity IntAdder_7_F50_uid16 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          Y : in  std_logic_vector(6 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(6 downto 0)   );
end entity;

architecture arch of IntAdder_7_F50_uid16 is
signal Rtmp :  std_logic_vector(6 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            IntAdder_7_F50_uid18
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

entity IntAdder_7_F50_uid18 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          Y : in  std_logic_vector(6 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(6 downto 0)   );
end entity;

architecture arch of IntAdder_7_F50_uid18 is
signal Rtmp :  std_logic_vector(6 downto 0);
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                   RightShifterSticky7_by_max_7_F50_uid22
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
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

entity RightShifterSticky7_by_max_7_F50_uid22 is
    port (clk : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          S : in  std_logic_vector(2 downto 0);
          padBit : in  std_logic;
          R : out  std_logic_vector(6 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky7_by_max_7_F50_uid22 is
signal ps, ps_d1 :  std_logic_vector(2 downto 0);
signal Xpadded :  std_logic_vector(6 downto 0);
signal level3, level3_d1 :  std_logic_vector(6 downto 0);
signal stk2 :  std_logic;
signal level2, level2_d1 :  std_logic_vector(6 downto 0);
signal stk1 :  std_logic;
signal level1, level1_d1 :  std_logic_vector(6 downto 0);
signal stk0 :  std_logic;
signal level0 :  std_logic_vector(6 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            ps_d1 <=  ps;
            level3_d1 <=  level3;
            level2_d1 <=  level2;
            level1_d1 <=  level1;
         end if;
      end process;
   ps<= S;
   Xpadded <= X;
   level3<= Xpadded;
   stk2 <= '1' when (level3_d1(3 downto 0)/="0000" and ps_d1(2)='1')   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => padBit) & level3(6 downto 4);
   stk1 <= '1' when (level2_d1(1 downto 0)/="00" and ps_d1(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => padBit) & level2(6 downto 2);
   stk0 <= '1' when (level1_d1(0 downto 0)/="0" and ps_d1(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => padBit) & level1(6 downto 1);
   R <= level0;
   Sticky <= stk0;
end architecture;

--------------------------------------------------------------------------------
--                       PositFastEncoder_8_2_F50_uid20
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
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

entity PositFastEncoder_8_2_F50_uid20 is
    port (clk : in std_logic;
          Sign : in  std_logic;
          SF : in  std_logic_vector(6 downto 0);
          Frac : in  std_logic_vector(2 downto 0);
          Guard : in  std_logic;
          Sticky : in  std_logic;
          NZN : in  std_logic;
          R : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of PositFastEncoder_8_2_F50_uid20 is
   component RightShifterSticky7_by_max_7_F50_uid22 is
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
signal ovf, ovf_d1 :  std_logic;
signal regValue :  std_logic_vector(2 downto 0);
signal regNeg :  std_logic;
signal padBit :  std_logic;
signal inputShifter :  std_logic_vector(6 downto 0);
signal shiftedPosit :  std_logic_vector(6 downto 0);
signal stkBit :  std_logic;
signal unroundedPosit, unroundedPosit_d1 :  std_logic_vector(6 downto 0);
signal lsb, lsb_d1 :  std_logic;
signal rnd, rnd_d1 :  std_logic;
signal stk :  std_logic;
signal round :  std_logic;
signal roundedPosit :  std_logic_vector(6 downto 0);
signal unsignedPosit :  std_logic_vector(6 downto 0);
signal Sign_d1 :  std_logic;
signal Sticky_d1 :  std_logic;
signal NZN_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            ovf_d1 <=  ovf;
            unroundedPosit_d1 <=  unroundedPosit;
            lsb_d1 <=  lsb;
            rnd_d1 <=  rnd;
            Sign_d1 <=  Sign;
            Sticky_d1 <=  Sticky;
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
   RegimeGenerator: RightShifterSticky7_by_max_7_F50_uid22
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
   stk <= stkBit OR Sticky_d1;
   round <= rnd_d1 AND (lsb_d1 OR stk OR ovf_d1);
   roundedPosit <= unroundedPosit_d1 + round;
-------------------------- Check sign & Special Cases --------------------------
   unsignedPosit <= roundedPosit when NZN_d1 = '1' else (others => '0');
   R <= Sign_d1 & unsignedPosit;
---------------------------- End of vhdl generation ----------------------------
end architecture;

--------------------------------------------------------------------------------
--                                 PositSqrt
--                          (PositSqrt_8_2_F50_uid2)
-- Version: 2023.04.19 - 130639
-- VHDL generated for Kintex7 @ 50MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Raul Murillo (2021-2022)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles
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
          X : in  std_logic_vector(7 downto 0);
          R : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of PositSqrt is
   component PositFastDecoder_8_2_F50_uid4 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(7 downto 0);
             Sign : out  std_logic;
             SF : out  std_logic_vector(5 downto 0);
             Frac : out  std_logic_vector(2 downto 0);
             NZN : out  std_logic   );
   end component;

   component IntAdder_7_F50_uid8 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             Y : in  std_logic_vector(6 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(6 downto 0)   );
   end component;

   component IntAdder_7_F50_uid10 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             Y : in  std_logic_vector(6 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(6 downto 0)   );
   end component;

   component IntAdder_7_F50_uid12 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             Y : in  std_logic_vector(6 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(6 downto 0)   );
   end component;

   component IntAdder_7_F50_uid14 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             Y : in  std_logic_vector(6 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(6 downto 0)   );
   end component;

   component IntAdder_7_F50_uid16 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             Y : in  std_logic_vector(6 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(6 downto 0)   );
   end component;

   component IntAdder_7_F50_uid18 is
      port ( clk : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             Y : in  std_logic_vector(6 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(6 downto 0)   );
   end component;

   component PositFastEncoder_8_2_F50_uid20 is
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
signal X_sf :  std_logic_vector(5 downto 0);
signal X_f :  std_logic_vector(2 downto 0);
signal X_nzn :  std_logic;
signal XY_nzn :  std_logic;
signal XY_finalSgn :  std_logic;
signal odd_exp :  std_logic;
signal X_sf_3 :  std_logic_vector(6 downto 0);
signal one_bit :  std_logic;
signal r_0 :  std_logic_vector(6 downto 0);
signal q_0 :  std_logic_vector(5 downto 0);
signal real_q_0 :  std_logic_vector(5 downto 0);
signal pow_2_0 :  std_logic_vector(6 downto 0);
signal s_0 :  std_logic;
signal q_1 :  std_logic_vector(5 downto 0);
signal real_q_1 :  std_logic_vector(5 downto 0);
signal two_r_0 :  std_logic_vector(6 downto 0);
signal two_q_0 :  std_logic_vector(6 downto 0);
signal pow_2_1 :  std_logic_vector(6 downto 0);
signal n_0 :  std_logic_vector(6 downto 0);
signal r_1 :  std_logic_vector(6 downto 0);
signal rem_z_0 :  std_logic;
signal z_1 :  std_logic;
signal s_1 :  std_logic;
signal q_2 :  std_logic_vector(5 downto 0);
signal real_q_2 :  std_logic_vector(5 downto 0);
signal two_r_1 :  std_logic_vector(6 downto 0);
signal two_q_1 :  std_logic_vector(6 downto 0);
signal pow_2_2 :  std_logic_vector(6 downto 0);
signal n_1 :  std_logic_vector(6 downto 0);
signal r_2 :  std_logic_vector(6 downto 0);
signal rem_z_1 :  std_logic;
signal z_2 :  std_logic;
signal s_2 :  std_logic;
signal q_3 :  std_logic_vector(5 downto 0);
signal real_q_3 :  std_logic_vector(5 downto 0);
signal two_r_2 :  std_logic_vector(6 downto 0);
signal two_q_2 :  std_logic_vector(6 downto 0);
signal pow_2_3 :  std_logic_vector(6 downto 0);
signal n_2 :  std_logic_vector(6 downto 0);
signal r_3 :  std_logic_vector(6 downto 0);
signal rem_z_2 :  std_logic;
signal z_3 :  std_logic;
signal s_3 :  std_logic;
signal q_4 :  std_logic_vector(5 downto 0);
signal real_q_4 :  std_logic_vector(5 downto 0);
signal two_r_3 :  std_logic_vector(6 downto 0);
signal two_q_3 :  std_logic_vector(6 downto 0);
signal pow_2_4 :  std_logic_vector(6 downto 0);
signal n_3 :  std_logic_vector(6 downto 0);
signal r_4 :  std_logic_vector(6 downto 0);
signal rem_z_3 :  std_logic;
signal z_4 :  std_logic;
signal s_4 :  std_logic;
signal q_5 :  std_logic_vector(5 downto 0);
signal real_q_5 :  std_logic_vector(5 downto 0);
signal two_r_4 :  std_logic_vector(6 downto 0);
signal two_q_4 :  std_logic_vector(6 downto 0);
signal pow_2_5 :  std_logic_vector(6 downto 0);
signal n_4 :  std_logic_vector(6 downto 0);
signal r_5 :  std_logic_vector(6 downto 0);
signal rem_z_4 :  std_logic;
signal z_5, z_5_d1 :  std_logic;
signal s_5 :  std_logic;
signal q_6 :  std_logic_vector(5 downto 0);
signal real_q_6 :  std_logic_vector(5 downto 0);
signal two_r_5 :  std_logic_vector(6 downto 0);
signal two_q_5 :  std_logic_vector(6 downto 0);
signal pow_2_6 :  std_logic_vector(6 downto 0);
signal n_5 :  std_logic_vector(6 downto 0);
signal r_6, r_6_d1 :  std_logic_vector(6 downto 0);
signal rem_z_5 :  std_logic;
signal z_6 :  std_logic;
signal sqrt_f :  std_logic_vector(5 downto 0);
signal XY_sf :  std_logic_vector(6 downto 0);
signal XY_frac :  std_logic_vector(2 downto 0);
signal grd :  std_logic;
signal stk :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            z_5_d1 <=  z_5;
            r_6_d1 <=  r_6;
         end if;
      end process;
--------------------------- Start of vhdl generation ---------------------------
------------------------------- Decode X operand -------------------------------
   X_decoder: PositFastDecoder_8_2_F50_uid4
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
   X_sf_3 <= X_sf(X_sf'high) & X_sf(X_sf'high) & X_sf(5 downto 1);
----------------------------- Sqrt of the fraction -----------------------------
--------------------------- Non-Restoring algorithm ---------------------------
   one_bit <= '1';
   r_0 <= ("001" & X_f & '0') when odd_exp='1' else ("0001" & X_f);
   q_0 <= (others => '0');
   real_q_0 <= (others => '0');
   pow_2_0 <= "0100000";
   -- Iteration 1
   s_0 <= r_0(6);
   q_1 <= NOT(s_0) & "00000";
   real_q_1 <= (s_0) & "00000";
   two_r_0 <= r_0(5 downto 0) & '0';
   two_q_0 <= (others => '0');
   pow_2_1 <= '0' & pow_2_0(6 downto 1);
   n_0 <= (two_q_0 + NOT(pow_2_1)) when s_0='1' else NOT(two_q_0 + pow_2_1);
   sub_1: IntAdder_7_F50_uid8
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_0,
                 Y => n_0,
                 R => r_1);
   rem_z_0 <= '1' when r_1 = 0 else '0';
   z_1 <= rem_z_0;
   -- Iteration 2
   s_1 <= r_1(6);
   q_2 <= q_1(5 downto 5) & NOT(s_1 OR z_1) & "0000";
   real_q_2 <= q_2(4 downto 4) & '1' & "0000" when z_1='0' else real_q_1;
   two_r_1 <= r_1(5 downto 0) & '0';
   two_q_1 <= '0' & '1' & "00000";
   pow_2_2 <= '0' & pow_2_1(6 downto 1);
   n_1 <= (two_q_1 + NOT(pow_2_2)) when s_1='1' else NOT(two_q_1 + pow_2_2);
   sub_2: IntAdder_7_F50_uid10
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_1,
                 Y => n_1,
                 R => r_2);
   rem_z_1 <= '1' when r_2 = 0 else '0';
   z_2 <= rem_z_1 OR z_1;
   -- Iteration 3
   s_2 <= r_2(6);
   q_3 <= q_2(5 downto 4) & NOT(s_2 OR z_2) & "000";
   real_q_3 <= q_3(4 downto 3) & '1' & "000" when z_2='0' else real_q_2;
   two_r_2 <= r_2(5 downto 0) & '0';
   two_q_2 <= '0' & q_2(4 downto 4) & '1' & "0000";
   pow_2_3 <= '0' & pow_2_2(6 downto 1);
   n_2 <= (two_q_2 + NOT(pow_2_3)) when s_2='1' else NOT(two_q_2 + pow_2_3);
   sub_3: IntAdder_7_F50_uid12
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_2,
                 Y => n_2,
                 R => r_3);
   rem_z_2 <= '1' when r_3 = 0 else '0';
   z_3 <= rem_z_2 OR z_2;
   -- Iteration 4
   s_3 <= r_3(6);
   q_4 <= q_3(5 downto 3) & NOT(s_3 OR z_3) & "00";
   real_q_4 <= q_4(4 downto 2) & '1' & "00" when z_3='0' else real_q_3;
   two_r_3 <= r_3(5 downto 0) & '0';
   two_q_3 <= '0' & q_3(4 downto 3) & '1' & "000";
   pow_2_4 <= '0' & pow_2_3(6 downto 1);
   n_3 <= (two_q_3 + NOT(pow_2_4)) when s_3='1' else NOT(two_q_3 + pow_2_4);
   sub_4: IntAdder_7_F50_uid14
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_3,
                 Y => n_3,
                 R => r_4);
   rem_z_3 <= '1' when r_4 = 0 else '0';
   z_4 <= rem_z_3 OR z_3;
   -- Iteration 5
   s_4 <= r_4(6);
   q_5 <= q_4(5 downto 2) & NOT(s_4 OR z_4) & "0";
   real_q_5 <= q_5(4 downto 1) & '1' & "0" when z_4='0' else real_q_4;
   two_r_4 <= r_4(5 downto 0) & '0';
   two_q_4 <= '0' & q_4(4 downto 2) & '1' & "00";
   pow_2_5 <= '0' & pow_2_4(6 downto 1);
   n_4 <= (two_q_4 + NOT(pow_2_5)) when s_4='1' else NOT(two_q_4 + pow_2_5);
   sub_5: IntAdder_7_F50_uid16
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_4,
                 Y => n_4,
                 R => r_5);
   rem_z_4 <= '1' when r_5 = 0 else '0';
   z_5 <= rem_z_4 OR z_4;
   -- Iteration 6
   s_5 <= r_5(6);
   q_6 <= q_5(5 downto 1) & NOT(s_5 OR z_5) & "";
   real_q_6 <= q_6(4 downto 0) & '1' & "" when z_5='0' else real_q_5;
   two_r_5 <= r_5(5 downto 0) & '0';
   two_q_5 <= '0' & q_5(4 downto 1) & '1' & "0";
   pow_2_6 <= '0' & pow_2_5(6 downto 1);
   n_5 <= (two_q_5 + NOT(pow_2_6)) when s_5='1' else NOT(two_q_5 + pow_2_6);
   sub_6: IntAdder_7_F50_uid18
      port map ( clk  => clk,
                 Cin => one_bit,
                 X => two_r_5,
                 Y => n_5,
                 R => r_6);
   rem_z_5 <= '1' when r_6_d1 = 0 else '0';
   z_6 <= rem_z_5 OR z_5_d1;
   -- Convert the quotient to the digit set {0,1}
   sqrt_f <= q_6(4 downto 0) & '1' when z_5='0' else real_q_6; -- get the double of sqrt: first bit (=0) shifted out
----------------------------- Generate final posit -----------------------------
   XY_sf <= X_sf_3;
   XY_frac <= sqrt_f(4 downto 2);
   grd <= sqrt_f(1);
   stk <= sqrt_f(0);
   PositEncoder: PositFastEncoder_8_2_F50_uid20
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

