--------------------------------------------------------------------------------
-- Copyright (c) 2012, Felix Krause <flyx@isobeef.org>
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

with GL.API;
with GL.Enums.Getter;

package body GL.Immediate is

   overriding procedure Finalize (Token : in out Input_Token) is
   begin
      API.GL_End;
      Error_Checking_Suspended := False;
      Check_OpenGL_Error;
   end Finalize;

   function Start (Mode : Connection_Mode) return Input_Token is
   begin
      API.GL_Begin (Mode);
      Error_Checking_Suspended := True;
      return Input_Token'(Ada.Finalization.Limited_Controlled with
                            Mode => Mode);
   end Start;

   procedure Add_Vertex (Token : Input_Token; Vertex : Vectors.Vector) is
   begin
      API.Vertex (Vertex);
   end Add_Vertex;

   procedure Set_Color (Value : Colors.Color) is
   begin
      API.Color (Value);
      Check_OpenGL_Error;
   end Set_Color;

   function Current_Color return Colors.Color is
      Ret : Colors.Color;
   begin
      API.Get_Color (Enums.Getter.Current_Color, Ret);
      Check_OpenGL_Error;
      return Ret;
   end Current_Color;

   -- UNAVAILABLE IN SOME DRIVERS
   --procedure Set_Fog_Distance (Value : Real) is
   --begin
   --   API.Fog_Coord (Value);
   --   Check_OpenGL_Error;
   --end Set_Fog_Distance;

   function Current_Fog_Distance return Real is
      Value : aliased Real;
   begin
      API.Get_Double (Enums.Getter.Current_Fog_Coord, Value'Access);
      Check_OpenGL_Error;
      return Value;
   end Current_Fog_Distance;

   procedure Set_Normal (Value : Normals.Normal) is
   begin
      API.Normal (Value);
      Check_OpenGL_Error;
   end Set_Normal;

   function Current_Normal return Normals.Normal is
      Value : Normals.Normal;
   begin
      API.Get_Double (Enums.Getter.Current_Normal, Value (Vectors.X)'Access);
      Check_OpenGL_Error;
      return Value;
   end Current_Normal;

   procedure Set_Texture_Coordinates (Value : Vectors.Vector) is
   begin
      API.Tex_Coord (Value);
      Check_OpenGL_Error;
   end Set_Texture_Coordinates;

   function Current_Texture_Coordinates return Vectors.Vector is
      Value : Vectors.Vector;
   begin
      API.Get_Double (Enums.Getter.Current_Texture_Coords, Value (Vectors.X)'Access);
      Check_OpenGL_Error;
      return Value;
   end Current_Texture_Coordinates;

end GL.Immediate;
