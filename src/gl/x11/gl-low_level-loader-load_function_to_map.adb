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

with GL.GLX;
with Interfaces.C.Strings;

separate (GL.Low_Level.Loader)
procedure Load_Function_To_Map (GL_Function_Name : String;
                                Position : out Function_Maps.Cursor) is
   GL_Function_Name_C : Interfaces.C.Strings.chars_ptr
     := Interfaces.C.Strings.New_String (GL_Function_Name);

   Result : System.Address := WGL.wglGetProcAddress (GL_Function_Name_C);

   Inserted : Boolean;
begin
   Interfaces.C.Strings.Free (GL_Function_Name_C);
   Loaded.Insert (GL_Function_Name, Result, Position, Inserted);
end Load_Function_To_Map;

