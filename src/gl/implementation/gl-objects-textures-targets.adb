--------------------------------------------------------------------------------
-- Copyright (c) 2013, Felix Krause <contact@flyx.org>
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
with GL.Enums.Textures;

package body GL.Objects.Textures.Targets is

   function Buffer_Offset (Object : Texture_Buffer_Target;
                           Level : Mipmap_Level) return Size is
      Ret : Size;
   begin
      API.Get_Tex_Level_Parameter_Size (Object.Kind, Level,
                                        Enums.Textures.Buffer_Offset, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Buffer_Offset;

   function Buffer_Size (Object : Texture_Buffer_Target;
                         Level : Mipmap_Level) return Size is
      Ret : Size;
   begin
      API.Get_Tex_Level_Parameter_Size (Object.Kind, Level,
                                        Enums.Textures.Buffer_Size, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Buffer_Size;

end GL.Objects.Textures.Targets;