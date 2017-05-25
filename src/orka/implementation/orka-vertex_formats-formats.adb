--  Copyright (c) 2017 onox <denkpadje@gmail.com>
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

with GL.Types;

package body Orka.Vertex_Formats.Formats is

   use GL.Types;

   function Position_Normal_UV return Vertex_Format is
      procedure Add_Vertex_Attributes (Buffer : in out Vertex_Formats.Attribute_Buffer) is
      begin
         Buffer.Add_Attribute (0, 3);
         Buffer.Add_Attribute (1, 3);
         Buffer.Add_Attribute (2, 2);
      end Add_Vertex_Attributes;
   begin
      return Result : Vertex_Format := Vertex_Formats.Create_Vertex_Format (Triangles) do
         Result.Add_Attribute_Buffer (Single_Type, Add_Vertex_Attributes'Access);
      end return;
   end Position_Normal_UV;

   function Position_Normal_UV_Half_MDI return Vertex_Format is
      procedure Add_Vertex_Attributes (Buffer : in out Vertex_Formats.Attribute_Buffer) is
      begin
         Buffer.Add_Attribute (0, 3);
         Buffer.Add_Attribute (1, 3);
         Buffer.Add_Attribute (2, 2);
      end Add_Vertex_Attributes;

      procedure Add_Instance_Attribute (Buffer : in out Vertex_Formats.Attribute_Buffer) is
      begin
         Buffer.Add_Attribute (3, 1);
         Buffer.Set_Per_Instance (True);
      end Add_Instance_Attribute;
   begin
      return Result : Vertex_Format := Vertex_Formats.Create_Vertex_Format (Triangles) do
         Result.Add_Attribute_Buffer (Half_Type, Add_Vertex_Attributes'Access);
         Result.Add_Attribute_Buffer (UInt_Type, Add_Instance_Attribute'Access);
      end return;
   end Position_Normal_UV_Half_MDI;

end Orka.Vertex_Formats.Formats;
