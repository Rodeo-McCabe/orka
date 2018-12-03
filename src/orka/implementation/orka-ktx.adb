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

with Interfaces.C.Extensions;

with Ada.Characters.Latin_1;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Unchecked_Conversion;

with GL.Pixels.Extensions;

package body Orka.KTX is

   package ICE renames Interfaces.C.Extensions;

   use Ada.Streams;

   type Four_Bytes_Array is array (Positive range 1 .. 4) of Stream_Element
     with Size => 32, Pack;

   function Convert_Size is new Ada.Unchecked_Conversion
     (Source => Four_Bytes_Array, Target => ICE.Unsigned_32);

   type Header_Array is array (Positive range 1 .. 13 * 4) of Stream_Element
     with Size => 32 * 13, Pack;

   type Internal_Header is record
      Endianness           : ICE.Unsigned_32;
      Data_Type            : ICE.Unsigned_32;
      Type_Size            : ICE.Unsigned_32;
      Format               : ICE.Unsigned_32;
      Internal_Format      : ICE.Unsigned_32;
      Base_Internal_Format : ICE.Unsigned_32;
      Width                : ICE.Unsigned_32;
      Height               : ICE.Unsigned_32;
      Depth                : ICE.Unsigned_32;
      Array_Elements       : ICE.Unsigned_32;
      Faces                : ICE.Unsigned_32;
      Mipmap_Levels        : ICE.Unsigned_32;
      Bytes_Key_Value_Data : ICE.Unsigned_32;
   end record
     with Size => 32 * 13, Pack;

   Identifier : constant Resources.Byte_Array
     := (16#AB#, 16#4B#, 16#54#, 16#58#, 16#20#, 16#31#,
         16#31#, 16#BB#, 16#0D#, 16#0A#, 16#1A#, 16#0A#);

   Endianness_Reference : constant := 16#04030201#;

   function Valid_Identifier (Bytes : Bytes_Reference) return Boolean is
     (Identifier = Bytes (Bytes.Value'First .. Bytes.Value'First + Identifier'Length - 1));

   function Get_Header (Bytes : Bytes_Reference) return Header is
      use type ICE.Unsigned_32;

      function Convert is new Ada.Unchecked_Conversion
        (Source => Header_Array, Target => Internal_Header);

      function Convert_To_Data_Type is new Ada.Unchecked_Conversion
        (Source => ICE.Unsigned_32, Target => GL.Pixels.Data_Type);
      function Convert_To_Format is new Ada.Unchecked_Conversion
        (Source => ICE.Unsigned_32, Target => GL.Pixels.Format);
      function Convert_To_Internal_Format is new Ada.Unchecked_Conversion
        (Source => ICE.Unsigned_32, Target => GL.Pixels.Internal_Format);
      function Convert_To_Compressed_Format is new Ada.Unchecked_Conversion
        (Source => ICE.Unsigned_32, Target => GL.Pixels.Compressed_Format);

      Offset : constant Stream_Element_Offset := Bytes.Value'First + Identifier'Length;
      File_Header : constant Internal_Header := Convert (Header_Array
        (Bytes (Offset .. Offset + Header_Array'Length - 1)));

      Compressed : constant Boolean := File_Header.Data_Type = 0;
   begin
      pragma Assert (File_Header.Endianness = Endianness_Reference);
      pragma Assert (File_Header.Type_Size in 1 | 2 | 4);

      return Result : Header (Compressed) do
         pragma Assert (File_Header.Width > 0);
         if File_Header.Depth > 0 then
            pragma Assert (File_Header.Height > 0);
         end if;

         --  Set dimensions of a single texture
         Result.Width  := GL.Types.Size (File_Header.Width);
         Result.Height := GL.Types.Size (File_Header.Height);
         Result.Depth  := GL.Types.Size (File_Header.Depth);

         --  Set texture kind based on faces, array elements, and dimensions
         if File_Header.Faces = 6 then
            pragma Assert (File_Header.Width = File_Header.Height);
            pragma Assert (File_Header.Depth = 0);

            if File_Header.Array_Elements > 0 then
               Result.Kind := Texture_Cube_Map_Array;
               Result.Depth := GL.Types.Size (File_Header.Array_Elements * File_Header.Faces);
            else
               Result.Kind := Texture_Cube_Map;
            end if;
         else
            if File_Header.Array_Elements > 0 then
               if File_Header.Depth > 0 then
                  raise Constraint_Error with "OpenGL does not support 3D texture arrays";
               elsif File_Header.Height > 0 then
                  Result.Kind := Texture_2D_Array;
                  Result.Depth := GL.Types.Size (File_Header.Array_Elements);
               else
                  Result.Kind := Texture_1D_Array;
                  Result.Height := GL.Types.Size (File_Header.Array_Elements);
               end if;
            else
               if File_Header.Depth > 0 then
                  Result.Kind := Texture_3D;
               elsif File_Header.Height > 0 then
                  Result.Kind := Texture_2D;
               else
                  Result.Kind := Texture_1D;
               end if;
            end if;
         end if;

         Result.Array_Elements := GL.Types.Size (File_Header.Array_Elements);
         Result.Mipmap_Levels  := GL.Types.Size (File_Header.Mipmap_Levels);
         --  If mipmap levels is 0, then client should generate full
         --  mipmap pyramid

         Result.Bytes_Key_Value := GL.Types.Size (File_Header.Bytes_Key_Value_Data);

         if Compressed then
            pragma Assert (File_Header.Format = 0);
            pragma Assert (File_Header.Type_Size = 1);
            pragma Assert (File_Header.Mipmap_Levels > 0);

            --  Format / Internal format
            begin
               Result.Compressed_Format
                 := Convert_To_Compressed_Format (File_Header.Internal_Format);
            exception
               when Constraint_Error =>
                  raise Invalid_Enum_Error with "invalid internal format (" &
                    ICE.Unsigned_32'Image (File_Header.Internal_Format) & ")";
            end;
         else
            --  Data type
            begin
               Result.Data_Type := Convert_To_Data_Type (File_Header.Data_Type);
            exception
               when Constraint_Error =>
                  raise Invalid_Enum_Error with "invalid data type (" &
                    ICE.Unsigned_32'Image (File_Header.Data_Type) & ")";
            end;

            --  Format
            begin
               Result.Format := Convert_To_Format (File_Header.Format);
            exception
               when Constraint_Error =>
                  raise Invalid_Enum_Error with "invalid format (" &
                    ICE.Unsigned_32'Image (File_Header.Format) & ")";
            end;

            --  Internal format
            begin
               Result.Internal_Format
                 := Convert_To_Internal_Format (File_Header.Internal_Format);
            exception
               when Constraint_Error =>
                  raise Invalid_Enum_Error with "invalid internal format (" &
                    ICE.Unsigned_32'Image (File_Header.Internal_Format) & ")";
            end;
         end if;
      end return;
   end Get_Header;

   function Get_Key_Value_Map
     (Bytes  : Bytes_Reference;
      Length : GL.Types.Size) return KTX.String_Maps.Map
   is
      Result : KTX.String_Maps.Map;

      Non_Header_Index : constant Stream_Element_Offset
        := Bytes.Value'First + Identifier'Length + Header_Array'Length;
      Data_Index : constant Stream_Element_Offset
        := Non_Header_Index + Stream_Element_Offset (Length);
      pragma Assert (Data_Index <= Bytes.Value'Last);

      Bytes_Remaining : Natural := Natural (Length);
      Pair_Index : Stream_Element_Offset := Non_Header_Index;
   begin
      while Bytes_Remaining > 0 loop
         declare
            Size_Bytes : constant Four_Bytes_Array := Four_Bytes_Array
              (Bytes (Pair_Index .. Pair_Index + 4 - 1));

            Key_Value_Size : constant Natural := Natural (Convert_Size (Size_Bytes));
            Padding_Size   : constant Natural := 3 - ((Key_Value_Size + 3) mod 4);

            Pair_Size : constant Natural := 4 + Key_Value_Size + Padding_Size;

            type Key_Value_Array is array (Positive range 1 .. Key_Value_Size) of Stream_Element
              with Pack;
            type Character_Array is array (Positive range 1 .. Key_Value_Size) of Character
              with Pack;

            function Convert_Pair is new Ada.Unchecked_Conversion
              (Source => Key_Value_Array, Target => Character_Array);

            Key_Value_Pair : constant Key_Value_Array := Key_Value_Array (Bytes
              (Pair_Index + 4 .. Pair_Index + 4 + Stream_Element_Offset (Key_Value_Size) - 1));
            Key_Value : constant String := String (Convert_Pair (Key_Value_Pair));

            Position_NUL : constant Natural := Ada.Strings.Fixed.Index
              (Key_Value, Ada.Strings.Maps.To_Set (Ada.Characters.Latin_1.NUL));
            pragma Assert (Position_NUL > 0);
         begin
            --  Extract key and value here
            declare
               Key   : constant String := Key_Value (1 .. Position_NUL - 1);
               Value : constant String := Key_Value (Position_NUL + 1 .. Key_Value'Last);
            begin
               Result.Insert (Key, Value);
            end;

            Bytes_Remaining := Bytes_Remaining - Pair_Size;
            Pair_Index := Pair_Index + Stream_Element_Offset (Pair_Size);
         end;
      end loop;
      pragma Assert (Pair_Index = Data_Index);
      return Result;
   end Get_Key_Value_Map;

   function Get_Length
     (Bytes  : Bytes_Reference;
      Offset : Stream_Element_Offset) return Natural
   is
      Size_Bytes : constant Four_Bytes_Array := Four_Bytes_Array
        (Bytes (Offset .. Offset + 4 - 1));
   begin
      return Natural (Convert_Size (Size_Bytes));
   end Get_Length;

   function Get_Data_Offset
     (Bytes  : Bytes_Reference;
      Bytes_Key_Value : GL.Types.Size) return Stream_Element_Offset
   is (Bytes.Value'First + Identifier'Length + Header_Array'Length
        + Stream_Element_Offset (Bytes_Key_Value));

   function Create_KTX_Bytes
     (KTX_Header : Header;
      Data       : Bytes_Reference) return Resources.Byte_Array_Pointers.Pointer
   is
      pragma Assert (KTX_Header.Mipmap_Levels = 1);
      --  TODO Data is 1 pointer to a Byte_Array, so only supporting 1 mipmap
      --  level at the moment

      function Convert is new Ada.Unchecked_Conversion
        (Source => Internal_Header, Target => Header_Array);
      function Convert is new Ada.Unchecked_Conversion
        (Source => ICE.Unsigned_32, Target => Four_Bytes_Array);

      function Convert is new Ada.Unchecked_Conversion
        (Source => GL.Pixels.Data_Type,         Target => ICE.Unsigned_32);
      function Convert is new Ada.Unchecked_Conversion
        (Source => GL.Pixels.Format,            Target => ICE.Unsigned_32);
      function Convert is new Ada.Unchecked_Conversion
        (Source => GL.Pixels.Internal_Format,   Target => ICE.Unsigned_32);
      function Convert is new Ada.Unchecked_Conversion
        (Source => GL.Pixels.Compressed_Format, Target => ICE.Unsigned_32);

      package PE renames GL.Pixels.Extensions;
      use type ICE.Unsigned_32;

      Compressed : Boolean renames KTX_Header.Compressed;

      pragma Assert (if not Compressed then Data.Value'Length mod 4 = 0);
      --  Data must be a multiple of 4 bytes because of the requirement
      --  of GL.Pixels.Unpack_Alignment = Words (= 4)
      --  Note: assertion is not precise because length of a row might
      --  not be a multiple of 4 bytes
      --  Note: Cube padding and mipmap padding can be assumed to be 0

      Type_Size : constant GL.Types.Size
        := (if Compressed then 1 else PE.Bytes (KTX_Header.Data_Type));

      Faces : constant ICE.Unsigned_32
        := (if KTX_Header.Kind in Texture_Cube_Map | Texture_Cube_Map_Array then 6 else 1);

      File_Header : constant Internal_Header
        := (Endianness           => Endianness_Reference,
            Data_Type            => (if Compressed then 0 else Convert (KTX_Header.Data_Type)),
            Type_Size            => ICE.Unsigned_32 (if Compressed then 1 else Type_Size),
            Format               => (if Compressed then 0 else Convert (KTX_Header.Format)),
            Internal_Format      =>
              (if Compressed then
                 Convert (KTX_Header.Compressed_Format)
               else
                 Convert (KTX_Header.Internal_Format)),
            Base_Internal_Format =>
              (if Compressed then
                 Convert (KTX_Header.Compressed_Format)
               else
                 Convert (KTX_Header.Format)),
            Width                => ICE.Unsigned_32 (KTX_Header.Width),
            Height               => ICE.Unsigned_32 (KTX_Header.Height),
            Depth                => ICE.Unsigned_32 (if Faces = 6 then 0 else KTX_Header.Depth),
            Array_Elements       => ICE.Unsigned_32 (KTX_Header.Array_Elements),
            Faces                => Faces,
            Mipmap_Levels        => ICE.Unsigned_32 (KTX_Header.Mipmap_Levels),
            Bytes_Key_Value_Data => 0);
      --  TODO Support key value map?

      Pointer : Resources.Byte_Array_Pointers.Pointer;

      Result : constant not null Resources.Byte_Array_Access := new Resources.Byte_Array
        (1 .. Identifier'Length + Header_Array'Length + 4 + Data.Value'Length);
      --  TODO Supports just 1 level at the moment

      Image_Size : constant ICE.Unsigned_32
        := (if KTX_Header.Kind = Texture_Cube_Map then
              Data.Value'Length / 6
            else
              Data.Value'Length);

      Header_Offset : constant Stream_Element_Offset := Result'First + Identifier'Length;
      Size_Offset   : constant Stream_Element_Offset := Header_Offset + Header_Array'Length;
      Data_Offset   : constant Stream_Element_Offset := Size_Offset + 4;
   begin
      Result (Result'First .. Header_Offset - 1) := Identifier;
      Result (Header_Offset .. Size_Offset - 1)  := Stream_Element_Array (Convert (File_Header));
      Result (Size_Offset .. Data_Offset - 1)    := Stream_Element_Array (Convert (Image_Size));
      Result (Data_Offset .. Result'Last)        := Data;
      Pointer.Set (Result);
      return Pointer;
   end Create_KTX_Bytes;

end Orka.KTX;
