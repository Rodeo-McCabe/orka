--  SPDX-License-Identifier: Apache-2.0
--
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

with Ahven.Framework;

package Test_SIMD_SSE_Math is

   type Test is new Ahven.Framework.Test_Case with null record;

   overriding
   procedure Initialize (T : in out Test);

private

   procedure Test_Max;
   procedure Test_Min;

end Test_SIMD_SSE_Math;
