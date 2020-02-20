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

with System;

with Orka.Rendering.Buffers.Pointers;

package body Orka.Rendering.Buffers is

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Kind   : Types.Element_Type;
      Length : Natural) return Buffer
   is
      Bytes : Natural;

      Storage_Length : Natural;
      Storage_Kind   : GL.Types.Numeric_Type;
   begin
      return Result : Buffer (Kind => Kind) do
         case Kind is
            --  Composite types
            when Single_Vector_Type =>
               Storage_Length := Length * 4;
               Storage_Kind   := Single_Type;
            when Double_Vector_Type =>
               Storage_Length := Length * 4;
               Storage_Kind   := Double_Type;
            when Single_Matrix_Type =>
               Storage_Length := Length * 16;
               Storage_Kind   := Single_Type;
            when Double_Matrix_Type =>
               Storage_Length := Length * 16;
               Storage_Kind   := Double_Type;
            when Arrays_Command_Type =>
               Bytes := Indirect.Arrays_Indirect_Command'Size / System.Storage_Unit;
               Storage_Length := Length * Bytes;
               Storage_Kind   := Byte_Type;
            when Elements_Command_Type =>
               Bytes := Indirect.Elements_Indirect_Command'Size / System.Storage_Unit;
               Storage_Length := Length * Bytes;
               Storage_Kind   := Byte_Type;
            when Dispatch_Command_Type =>
               Bytes := Indirect.Dispatch_Indirect_Command'Size / System.Storage_Unit;
               Storage_Length := Length * Bytes;
               Storage_Kind   := Byte_Type;
            --  Numeric types
            when others =>
               Storage_Length := Length;
               Storage_Kind   := Convert (Kind);
         end case;

         Result.Buffer.Allocate (Long (Storage_Length), Storage_Kind, Flags);
         Result.Length := Length;
      end return;
   end Create_Buffer;

   -----------------------------------------------------------------------------

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Half_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Half_Type) do
         Pointers.Half.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Single_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Single_Type) do
         Pointers.Single.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Double_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Double_Type) do
         Pointers.Double.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Int_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Int_Type) do
         Pointers.Int.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : UInt_Array) return Buffer is
   begin
      return Result : Buffer (Kind => UInt_Type) do
         Pointers.UInt.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Singles.Vector4_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Single_Vector_Type) do
         Pointers.Single_Vector4.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Singles.Matrix4_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Single_Matrix_Type) do
         Pointers.Single_Matrix4.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Doubles.Vector4_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Double_Vector_Type) do
         Pointers.Double_Vector4.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Doubles.Matrix4_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Double_Matrix_Type) do
         Pointers.Double_Matrix4.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Indirect.Arrays_Indirect_Command_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Arrays_Command_Type) do
         Pointers.Arrays_Command.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Indirect.Elements_Indirect_Command_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Elements_Command_Type) do
         Pointers.Elements_Command.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Indirect.Dispatch_Indirect_Command_Array) return Buffer is
   begin
      return Result : Buffer (Kind => Dispatch_Command_Type) do
         Pointers.Dispatch_Command.Load_To_Immutable_Buffer (Result.Buffer, Data, Flags);
         Result.Length := Data'Length;
      end return;
   end Create_Buffer;

   -----------------------------------------------------------------------------

   function GL_Buffer (Object : Buffer) return GL.Objects.Buffers.Buffer
     is (Object.Buffer);

   overriding
   function Length (Object : Buffer) return Natural is (Object.Length);

   overriding
   procedure Bind (Object : Buffer; Target : Indexable_Buffer_Target; Index : Natural) is
   begin
      case Target is
         when Uniform =>
            GL.Objects.Buffers.Uniform_Buffer.Bind_Base (Object.Buffer, Index);
         when Shader_Storage =>
            GL.Objects.Buffers.Shader_Storage_Buffer.Bind_Base (Object.Buffer, Index);
         when Atomic_Counter =>
            GL.Objects.Buffers.Atomic_Counter_Buffer.Bind_Base (Object.Buffer, Index);
      end case;
   end Bind;

   -----------------------------------------------------------------------------

   procedure Set_Data
     (Object : Buffer;
      Data   : Half_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Half.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Single_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Single.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Double_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Double.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Int_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Int.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : UInt_Array;
      Offset : Natural := 0) is
   begin
      Pointers.UInt.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Singles.Vector4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Single_Vector4.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Singles.Matrix4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Single_Matrix4.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Doubles.Vector4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Double_Vector4.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Doubles.Matrix4_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Double_Matrix4.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Indirect.Arrays_Indirect_Command_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Arrays_Command.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Indirect.Elements_Indirect_Command_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Elements_Command.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   procedure Set_Data
     (Object : Buffer;
      Data   : Indirect.Dispatch_Indirect_Command_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Dispatch_Command.Set_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Set_Data;

   -----------------------------------------------------------------------------

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Half_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Half.Get_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Get_Data;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Single_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Single.Get_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Get_Data;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Double_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Double.Get_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Get_Data;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Int_Array;
      Offset : Natural := 0) is
   begin
      Pointers.Int.Get_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Get_Data;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out UInt_Array;
      Offset : Natural := 0) is
   begin
      Pointers.UInt.Get_Sub_Data (Object.Buffer, Int (Offset), Data);
   end Get_Data;

   -----------------------------------------------------------------------------

   procedure Copy_Data
     (Object : Buffer;
      Target : Buffer)
   is
      use Orka.Types;

      Length : constant Size := Size (Object.Length);
   begin
      case Object.Kind is
         --  Numeric types
         when UByte_Type =>
            Pointers.UByte.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when UShort_Type =>
            Pointers.UShort.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when UInt_Type =>
            Pointers.UInt.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Byte_Type =>
            Pointers.Byte.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Short_Type =>
            Pointers.Short.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Int_Type =>
            Pointers.Int.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Half_Type =>
            Pointers.Half.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Single_Type =>
            Pointers.Single.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Double_Type =>
            Pointers.Double.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         --  Composite types
         when Single_Vector_Type =>
            Pointers.Single_Vector4.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Double_Vector_Type =>
            Pointers.Double_Vector4.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Single_Matrix_Type =>
            Pointers.Single_Matrix4.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Double_Matrix_Type =>
            Pointers.Double_Matrix4.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Arrays_Command_Type =>
            Pointers.Arrays_Command.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Elements_Command_Type =>
            Pointers.Elements_Command.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
         when Dispatch_Command_Type =>
            Pointers.Dispatch_Command.Copy_Sub_Data (Object.Buffer, Target.Buffer, 0, 0, Length);
      end case;
   end Copy_Data;

end Orka.Rendering.Buffers;
