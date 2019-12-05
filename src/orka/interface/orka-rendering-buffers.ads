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

with GL.Objects.Buffers;
with GL.Types.Indirect;

with Orka.Types;

package Orka.Rendering.Buffers is
   pragma Preelaborate;

   use GL.Types;
   use all type Orka.Types.Element_Type;

   -----------------------------------------------------------------------------

   type Bindable_Buffer is interface;

   type Buffer_Target is (Uniform, Shader_Storage, Atomic_Counter);

   procedure Bind_Base
     (Object : Bindable_Buffer;
      Target : Buffer_Target;
      Index  : Natural) is abstract;

   function Length (Object : Bindable_Buffer) return Natural is abstract;

   -----------------------------------------------------------------------------

   type Buffer (Kind : Types.Element_Type) is new Bindable_Buffer with private;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Kind   : Types.Element_Type;
      Length : Natural) return Buffer;

   -----------------------------------------------------------------------------

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Half_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Single_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Double_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Int_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : UInt_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Singles.Vector4_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Singles.Matrix4_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Doubles.Vector4_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Orka.Types.Doubles.Matrix4_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Indirect.Arrays_Indirect_Command_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Indirect.Elements_Indirect_Command_Array) return Buffer;

   function Create_Buffer
     (Flags  : GL.Objects.Buffers.Storage_Bits;
      Data   : Indirect.Dispatch_Indirect_Command_Array) return Buffer;

   -----------------------------------------------------------------------------

   function GL_Buffer (Object : Buffer) return GL.Objects.Buffers.Buffer
     with Inline;

   overriding
   function Length (Object : Buffer) return Natural
     with Inline;

   overriding
   procedure Bind_Base (Object : Buffer; Target : Buffer_Target; Index : Natural);
   --  Bind the buffer object to the index of the target as well as to
   --  the target itself.

   -----------------------------------------------------------------------------

   procedure Set_Data
     (Object : Buffer;
      Data   : Half_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Single_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Double_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Int_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : UInt_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Singles.Vector4_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Singles.Matrix4_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Doubles.Vector4_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Orka.Types.Doubles.Matrix4_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Indirect.Arrays_Indirect_Command_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Indirect.Elements_Indirect_Command_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Set_Data
     (Object : Buffer;
      Data   : Indirect.Dispatch_Indirect_Command_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   -----------------------------------------------------------------------------

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Half_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Single_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Double_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out Int_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   procedure Get_Data
     (Object : Buffer;
      Data   : in out UInt_Array;
      Offset : Natural := 0)
   with Pre => Offset + Data'Length <= Object.Length;

   -----------------------------------------------------------------------------

   procedure Copy_Data
     (Object : Buffer;
      Target : Buffer)
   with Pre => Object.Kind = Target.Kind and then Object.Length = Target.Length;

private

   type Buffer (Kind : Types.Element_Type) is new Bindable_Buffer with record
      Buffer : GL.Objects.Buffers.Buffer;
      Length : Natural;
   end record;

end Orka.Rendering.Buffers;
