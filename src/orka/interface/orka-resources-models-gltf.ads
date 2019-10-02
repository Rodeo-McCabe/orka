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

with Orka.Rendering.Vertex_Formats;
with Orka.Resources.Loaders;
with Orka.Resources.Managers;

package Orka.Resources.Models.glTF is

   function Create_Loader
     (Format  : Rendering.Vertex_Formats.Vertex_Format_Ptr;
      Manager : Managers.Manager_Ptr) return Loaders.Loader_Ptr;

end Orka.Resources.Models.glTF;
