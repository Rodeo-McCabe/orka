--  SPDX-License-Identifier: Apache-2.0
--
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

package body Orka.glTF.Meshes is

   function Create_Primitive
     (Object : Types.JSON_Value) return Primitive
   is
      Attributes : constant Types.JSON_Value := Object.Get ("attributes");

      Indices  : constant Long_Integer := Object.Get ("indices", Undefined).Value;
      Material : constant Long_Integer := Object.Get ("material", Undefined).Value;
      Mode     : constant Long_Integer := Object.Get ("mode", 4).Value;

      Mode_Kind : Primitive_Mode;
      Attribute_Accessors : Attribute_Maps.Map;
   begin
      case Mode is
         when 0 =>
            Mode_Kind := GL.Types.Points;
         when 1 =>
            Mode_Kind := GL.Types.Lines;
         when 2 =>
            Mode_Kind := GL.Types.Line_Loop;
         when 3 =>
            Mode_Kind := GL.Types.Line_Strip;
         when 4 =>
            Mode_Kind := GL.Types.Triangles;
         when 5 =>
            Mode_Kind := GL.Types.Triangle_Strip;
         when 6 =>
            Mode_Kind := GL.Types.Triangle_Fan;
         when others =>
            raise Constraint_Error with "Invalid primitive.mode";
      end case;

      for Attribute of Attributes loop
         Attribute_Accessors.Insert (Attribute.Value,
           Natural (Long_Integer'(Attributes.Get (Attribute.Value).Value)));
      end loop;

      --  TODO primitive.indices: When defined, the accessor must contain
      --  indices: the bufferView referenced by the accessor should have a
      --  target equal to 34963 (ELEMENT_ARRAY_BUFFER); componentType must
      --  be 5121 (UNSIGNED_BYTE), 5123 (UNSIGNED_SHORT) or 5125 (UNSIGNED_INT)
      return Result : Primitive do
         Result.Attributes := Attribute_Accessors;
         Result.Indices  := Natural_Optional (Indices);
         Result.Material := Natural_Optional (Material);
         Result.Mode := Mode_Kind;
      end return;
   end Create_Primitive;

   function Create_Primitives
     (Primitives : Types.JSON_Value) return Primitive_Vectors.Vector
   is
      Result : Primitive_Vectors.Vector (Capacity => Primitives.Length);
   begin
      for Primitive of Primitives loop
         Result.Append (Create_Primitive (Primitive));
      end loop;
      return Result;
   end Create_Primitives;

   function Create_Mesh
     (Object : Types.JSON_Value) return Mesh is
   begin
      return Result : Mesh do
         Result.Primitives := Create_Primitives (Object.Get ("primitives"));
         Result.Name       := SU.To_Unbounded_String (Object.Get ("name").Value);
      end return;
   end Create_Mesh;

   function Get_Meshes
     (Meshes : Types.JSON_Value) return Mesh_Vectors.Vector
   is
      Result : Mesh_Vectors.Vector (Capacity => Meshes.Length);
   begin
      for Mesh of Meshes loop
         Result.Append (Create_Mesh (Mesh));
      end loop;
      return Result;
   end Get_Meshes;

end Orka.glTF.Meshes;
