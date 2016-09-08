--  Copyright (c) 2016 onox <denkpadje@gmail.com>
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.

package Orka.SIMD.SSE.Singles.Swizzle is
   pragma Preelaborate;

   function Shuffle (Left, Right : m128; Mask : Unsigned_32) return m128
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_shufps";
   --  Shuffle the 32-bit floats in Left and Right using the given Mask. The first
   --  and second floats (lower half) are retrieved from Left, the third and fourth
   --  floats (upper half) from Right.
   --
   --  The compiler needs access to the Mask at compile-time, thus construct it
   --  as follows:
   --
   --  Mask_d_c_b_a : constant Unsigned_32 := d * 64 or c * 16 or b * 4 or a;
   --
   --  a and b select the floats to use from Left, c and d from Right.

   function Unpack_High (Left, Right : m128) return m128
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_unpckhps";
   --  Unpack and interleave the 32-bit floats from the upper halves of
   --  Left and Right as follows: Left (3), Right (3), Left (4), Right (4)

   function Unpack_Low (Left, Right : m128) return m128
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_unpcklps";
   --  Unpack and interleave the 32-bit floats from the lower halves of
   --  Left and Right as follows: Left (1), Right (1), Left (2), Right (2)

   function Move_LH (Left, Right : m128) return m128
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_movlhps";
   --  Move the two lower floats from Right to the two upper floats of Left:
   --  Left (1), Left (2), Right (1), Right (2)

   function Move_HL (Left, Right : m128) return m128
     with Import, Convention => Intrinsic, External_Name => "__builtin_ia32_movhlps";
   --  Move the two upper floats from Right to the two lower floats of Left:
   --  Right (3), Right (4), Left (3), Left (4)

   procedure Transpose (Matrix : in out m128_Array);

   function Transpose (Matrix : m128_Array) return m128_Array;

end Orka.SIMD.SSE.Singles.Swizzle;
