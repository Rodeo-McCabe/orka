--------------------------------------------------------------------------------
-- Copyright (c) 2012, Felix Krause <contact@flyx.org>
--
-- Permission to use, copy, modify, and/or distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;

with GL.API;
with GL.Enums.Getter;
with GL.Low_Level.Enums;

package body GL.Buffers is
   procedure Clear (Bits : Buffer_Bits) is
      use type Low_Level.Bitfield;
      function Convert is new Ada.Unchecked_Conversion
        (Source => Buffer_Bits, Target => Low_Level.Bitfield);
      Raw_Bits : constant Low_Level.Bitfield :=
        Convert (Bits) and 2#0100011100000000#;
   begin
      API.Clear (Raw_Bits);
      Raise_Exception_On_OpenGL_Error;
   end Clear;

   procedure Set_Active_Buffer (Selector : Explicit_Color_Buffer_Selector) is
   begin
      API.Draw_Buffer (Selector);
      Raise_Exception_On_OpenGL_Error;
   end Set_Active_Buffer;

   procedure Set_Active_Buffers (List : Explicit_Color_Buffer_List) is
   begin
      API.Draw_Buffers (List'Length, List);
      Raise_Exception_On_OpenGL_Error;
   end Set_Active_Buffers;

   procedure Set_Color_Clear_Value (Value : Colors.Color) is
   begin
      API.Clear_Color (Value (Colors.R), Value (Colors.G), Value (Colors.B),
                       Value (Colors.A));
      Raise_Exception_On_OpenGL_Error;
   end Set_Color_Clear_Value;

   function Color_Clear_Value return Colors.Color is
      Value : Colors.Color;
   begin
      API.Get_Color (Enums.Getter.Color_Clear_Value, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Color_Clear_Value;

   procedure Set_Depth_Clear_Value (Value : Depth) is
   begin
      API.Clear_Depth (Value);
      Raise_Exception_On_OpenGL_Error;
   end Set_Depth_Clear_Value;

   function Depth_Clear_Value return Depth is
      Value : aliased Double;
   begin
      API.Get_Double (Enums.Getter.Depth_Clear_Value, Value'Access);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Depth_Clear_Value;

   procedure Set_Stencil_Clear_Value (Value : Stencil_Index) is
   begin
      API.Clear_Stencil (Value);
      Raise_Exception_On_OpenGL_Error;
   end Set_Stencil_Clear_Value;

   function Stencil_Clear_Value return Stencil_Index is
      Value : aliased Stencil_Index;
   begin
      API.Get_Integer (Enums.Getter.Stencil_Clear_Value, Value'Access);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Stencil_Clear_Value;

   function Accum_Clear_Value return Colors.Color is
      Value : Colors.Color;
   begin
      API.Get_Color (Enums.Getter.Accum_Clear_Value, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Accum_Clear_Value;

   procedure Clear_Color_Buffers (Selector : Base_Color_Buffer_Selector;
                                  Value    : Colors.Color) is
   begin
      API.Clear_Buffer (Selector, 0, Value);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Color_Buffers;

   procedure Clear_Draw_Buffer (Index : Draw_Buffer_Index;
                                Value : Colors.Color) is
   begin
      API.Clear_Draw_Buffer (Low_Level.Enums.Color, Index, Value);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Draw_Buffer;

   procedure Clear_Depth_Buffer (Value : Depth) is
      Aliased_Value : aliased constant Depth := Value;
   begin
      API.Clear_Buffer_Depth (Low_Level.Enums.Depth_Buffer, 0,
                              Aliased_Value'Unchecked_Access);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Depth_Buffer;

   procedure Clear_Stencil_Buffer (Value : Stencil_Index) is
      Aliased_Value : aliased constant Stencil_Index := Value;
   begin
      API.Clear_Buffer_Stencil (Low_Level.Enums.Stencil, 0,
                                Aliased_Value'Unchecked_Access);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Stencil_Buffer;

   procedure Clear_Depth_And_Stencil_Buffer (Depth_Value   : Depth;
                                             Stencil_Value : Stencil_Index) is
   begin
      API.Clear_Buffer_Depth_Stencil (Low_Level.Enums.Depth_Stencil, 0,
                                      Depth_Value, Stencil_Value);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Depth_And_Stencil_Buffer;
end GL.Buffers;
