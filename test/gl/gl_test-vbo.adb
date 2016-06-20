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

with Ada.Text_IO;

with GL.Attributes;
with GL.Buffers;
with GL.Drawing;
with GL.Files;
with GL.Objects.Buffers;
with GL.Objects.Shaders;
with GL.Objects.Programs;
with GL.Objects.Vertex_Arrays;
with GL.Types;

with GL_Test.Display_Backend;

procedure GL_Test.VBO is
   use GL.Buffers;
   use GL.Types;
   use GL.Objects.Vertex_Arrays;

   procedure Load_Vectors is new GL.Objects.Buffers.Load_To_Buffer
     (Single_Pointers);

   procedure Load_Data (Array1  : Vertex_Array_Object;
                        Buffer1 : GL.Objects.Buffers.Buffer;
                        Program : GL.Objects.Programs.Program) is
      use GL.Objects.Buffers;
      use GL.Attributes;

      Vertices : constant Single_Array
        := (-0.5, -0.5,     1.0, 0.0, 0.0,
             0.5, -0.5,     0.0, 1.0, 0.0,
             0.0,  0.5,     0.0, 0.0, 1.0);

      Attrib_Pos   : constant Attribute := Program.Attrib_Location ("in_Position");
      Attrib_Color : constant Attribute := Program.Attrib_Location ("in_Color");
   begin
      --  Upload Vertices data to Buffer1
      Load_Vectors (Buffer1, Vertices, Static_Draw);

      --  Enable and set attributes for Array1 VAO
      Array1.Enable_Attribute (Attrib_Pos);
      Array1.Enable_Attribute (Attrib_Color);

      Array1.Set_Attribute_Format (Attrib_Pos, 2, Single_Type, 0);
      Array1.Set_Attribute_Format (Attrib_Color, 3, Single_Type, 2);

      Array1.Set_Attribute_Binding (Attrib_Pos, 0);
      Array1.Set_Attribute_Binding (Attrib_Color, 0);

      Array1.Bind_Vertex_Buffer (0, Buffer1, Single_Type, 0, 5);
   end Load_Data;

   procedure Load_Shaders (Vertex_Shader, Fragment_Shader : GL.Objects.Shaders.Shader;
                           Program : GL.Objects.Programs.Program) is
   begin
      --  Load shader sources and compile shaders
      GL.Files.Load_Shader_Source_From_File
        (Vertex_Shader, "../test/gl/shaders/opengl3.vert");
      GL.Files.Load_Shader_Source_From_File
        (Fragment_Shader, "../test/gl/shaders/opengl3.frag");
      
      Vertex_Shader.Compile;
      Fragment_Shader.Compile;
      
      if not Vertex_Shader.Compile_Status then
         Ada.Text_IO.Put_Line ("Compilation of vertex shader failed. log:");
         Ada.Text_IO.Put_Line (Vertex_Shader.Info_Log);
      end if;
      if not Fragment_Shader.Compile_Status then
         Ada.Text_IO.Put_Line ("Compilation of fragment shader failed. log:");
         Ada.Text_IO.Put_Line (Fragment_Shader.Info_Log);
      end if;
      
      --  Set up program
      Program.Attach (Vertex_Shader);
      Program.Attach (Fragment_Shader);
      Program.Bind_Attrib_Location (0, "in_Position");
      Program.Bind_Attrib_Location (1, "in_Color");
      Program.Link;
      if not Program.Link_Status then
         Ada.Text_IO.Put_Line ("Program linking failed. Log:");
         Ada.Text_IO.Put_Line (Program.Info_Log);
         return;
      end if;
      Program.Use_Program;

      --  Test iteration over program shaders
      Ada.Text_IO.Put_Line ("Listing shaders attached to program...");
      for Shader of Program.Attached_Shaders loop
         Ada.Text_IO.Put_Line ("  Kind: " & GL.Objects.Shaders.Shader_Type'Image (Shader.Kind));
         Ada.Text_IO.Put_Line ("  Status: " & Boolean'Image (Shader.Compile_Status));
      end loop;
   end Load_Shaders;

   Vertex_Shader   : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Vertex_Shader);
   Fragment_Shader : GL.Objects.Shaders.Shader
     (Kind => GL.Objects.Shaders.Fragment_Shader);
   Program         : GL.Objects.Programs.Program;

   Vector_Buffer1 : GL.Objects.Buffers.Buffer;
   Array1 : GL.Objects.Vertex_Arrays.Vertex_Array_Object;
begin
   Display_Backend.Init (Major => 3, Minor => 2);
   Display_Backend.Set_Not_Resizable;
   Display_Backend.Open_Window (Width => 500, Height => 500);
   Ada.Text_IO.Put_Line ("Initialized GLFW window");

   Vertex_Shader.Initialize_Id;
   Fragment_Shader.Initialize_Id;
   Program.Initialize_Id;

   Vector_Buffer1.Initialize_Id;
   Array1.Initialize_Id;

   Ada.Text_IO.Put_Line ("Initialized objects");

   Load_Shaders (Vertex_Shader, Fragment_Shader, Program);

   Ada.Text_IO.Put_Line ("Loaded shaders");

   Load_Data (Array1, Vector_Buffer1, Program);

   Ada.Text_IO.Put_Line ("Loaded data");

   while not Display_Backend.Get_Window.Should_Close loop
      Clear (Buffer_Bits'(Color => True, Depth => True, others => False));

      Array1.Bind;
      GL.Drawing.Draw_Arrays (Triangles, 0, 3);
      GL.Objects.Vertex_Arrays.Null_Array_Object.Bind;

      Display_Backend.Swap_Buffers_And_Poll_Events;
   end loop;

   Display_Backend.Shutdown;
end GL_Test.VBO;
