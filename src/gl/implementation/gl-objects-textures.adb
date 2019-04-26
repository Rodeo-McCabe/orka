--  Copyright (c) 2012 Felix Krause <contact@flyx.org>
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

with GL.API;
with GL.Helpers;
with GL.Enums.Getter;
with GL.Enums.Indexes;
with GL.Enums.Textures;

package body GL.Objects.Textures is

   function Get_Dimensions (Kind : LE.Texture_Kind) return Dimension_Count is
   begin
      case Kind is
         when Texture_1D =>
            return One;
         when Texture_2D | Texture_2D_Multisample | Texture_1D_Array |
           Texture_Rectangle | Texture_Cube_Map =>
            return Two;
         when Texture_3D | Texture_2D_Array | Texture_2D_Multisample_Array |
           Texture_Cube_Map_Array =>
            return Three;
         when Texture_Buffer =>
            raise Constraint_Error;
      end case;
   end Get_Dimensions;

   function Dimensions (Object : Texture) return Dimension_Count is (Object.Dimensions);

   function Allocated (Object : Texture) return Boolean is (Object.Allocated);

   function Width (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Width, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Width;

   function Height (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Height, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Height;

   function Depth (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Depth, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Depth;

   function Internal_Format (Object : Texture; Level : Mipmap_Level)
     return Pixels.Internal_Format is
      Ret : Pixels.Internal_Format := Pixels.Internal_Format'First;
   begin
      API.Get_Texture_Level_Parameter_Format (Object.Reference.GL_Id, Level,
                                              Enums.Textures.Internal_Format, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Internal_Format;

   function Compressed_Format (Object : Texture; Level : Mipmap_Level)
     return Pixels.Compressed_Format is
      Ret : Pixels.Compressed_Format := Pixels.Compressed_Format'First;
   begin
      API.Get_Texture_Level_Parameter_Format (Object.Reference.GL_Id, Level,
                                              Enums.Textures.Internal_Format, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Compressed_Format;

   function Red_Type (Object : Texture; Level : Mipmap_Level)
     return Pixels.Channel_Data_Type is
      Ret : Pixels.Channel_Data_Type := Pixels.Channel_Data_Type'First;
   begin
      API.Get_Texture_Level_Parameter_Type (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Red_Type, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Red_Type;

   function Green_Type (Object : Texture; Level : Mipmap_Level)
     return Pixels.Channel_Data_Type is
      Ret : Pixels.Channel_Data_Type := Pixels.Channel_Data_Type'First;
   begin
      API.Get_Texture_Level_Parameter_Type (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Green_Type, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Green_Type;

   function Blue_Type (Object : Texture; Level : Mipmap_Level)
     return Pixels.Channel_Data_Type is
      Ret : Pixels.Channel_Data_Type := Pixels.Channel_Data_Type'First;
   begin
      API.Get_Texture_Level_Parameter_Type (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Blue_Type, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blue_Type;

   function Alpha_Type (Object : Texture; Level : Mipmap_Level)
     return Pixels.Channel_Data_Type is
      Ret : Pixels.Channel_Data_Type := Pixels.Channel_Data_Type'First;
   begin
      API.Get_Texture_Level_Parameter_Type (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Alpha_Type, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Alpha_Type;

   function Depth_Type (Object : Texture; Level : Mipmap_Level)
     return Pixels.Channel_Data_Type is
      Ret : Pixels.Channel_Data_Type := Pixels.Channel_Data_Type'First;
   begin
      API.Get_Texture_Level_Parameter_Type (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Depth_Type, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Depth_Type;

   function Red_Size (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Red_Size, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Red_Size;

   function Green_Size (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Green_Size, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Green_Size;

   function Blue_Size (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Blue_Size, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Blue_Size;

   function Alpha_Size (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Alpha_Size, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Alpha_Size;

   function Depth_Size (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Depth_Size, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Depth_Size;

   function Compressed (Object : Texture; Level : Mipmap_Level) return Boolean is
      Ret : Low_Level.Bool := Low_Level.Bool'First;
   begin
      API.Get_Texture_Level_Parameter_Bool (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Compressed, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Boolean (Ret);
   end Compressed;

   function Compressed_Image_Size (Object : Texture; Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Compressed_Image_Size,
                                            Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Compressed_Image_Size;

   function Buffer_Offset (Object : Texture;
                           Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Buffer_Offset, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Buffer_Offset;

   function Buffer_Size (Object : Texture;
                         Level : Mipmap_Level) return Size is
      Ret : Size := 0;
   begin
      API.Get_Texture_Level_Parameter_Size (Object.Reference.GL_Id, Level,
                                            Enums.Textures.Buffer_Size, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Buffer_Size;

   procedure Bind_Texture_Unit (Object : Texture_Base; Unit : Texture_Unit) is
   begin
      API.Bind_Texture_Unit (Unit, Object.Reference.GL_Id);
      Raise_Exception_On_OpenGL_Error;
   end Bind_Texture_Unit;

   procedure Bind_Image_Texture (Object : Texture_Base; Unit : Image_Unit) is
      Arr : constant Low_Level.UInt_Array := (1 => Object.Reference.GL_Id);
   begin
      API.Bind_Image_Textures (Unit, 1, Arr);
      Raise_Exception_On_OpenGL_Error;
   end Bind_Image_Texture;

   overriding
   procedure Initialize_Id (Object : in out Texture_Base) is
      New_Id : UInt := 0;
   begin
      API.Create_Textures (Object.Kind, 1, New_Id);
      Raise_Exception_On_OpenGL_Error;
      Object.Reference.GL_Id := New_Id;
      Object.Reference.Initialized := True;
   end Initialize_Id;

   overriding
   procedure Delete_Id (Object : in out Texture_Base) is
      Arr : constant Low_Level.UInt_Array := (1 => Object.Reference.GL_Id);
   begin
      API.Delete_Textures (1, Arr);
      Raise_Exception_On_OpenGL_Error;
      Object.Reference.GL_Id := 0;
      Object.Reference.Initialized := False;
   end Delete_Id;
   
   procedure Invalidate_Image (Object : Texture_Base; Level : Mipmap_Level) is
   begin
      API.Invalidate_Tex_Image (Object.Reference.GL_Id, Level);
      Raise_Exception_On_OpenGL_Error;
   end Invalidate_Image;
   
   procedure Invalidate_Sub_Image (Object : Texture_Base; Level : Mipmap_Level;
                                   X, Y, Z : Int; Width, Height, Depth : Size)
   is
   begin
      API.Invalidate_Tex_Sub_Image (Object.Reference.GL_Id, Level, X, Y, Z,
                                    Width, Height, Depth);
      Raise_Exception_On_OpenGL_Error;
   end Invalidate_Sub_Image;

   procedure Set_Minifying_Filter (Object : Texture;
                                   Filter : Minifying_Function) is
   begin
      API.Texture_Parameter_Min_Filter (Object.Reference.GL_Id,
                                        Enums.Textures.Min_Filter, Filter);
      Raise_Exception_On_OpenGL_Error;
   end Set_Minifying_Filter;

   function Minifying_Filter (Object : Texture)
                              return Minifying_Function is
      Ret : Minifying_Function := Minifying_Function'First;
   begin
      API.Get_Texture_Parameter_Min_Filter (Object.Reference.GL_Id,
                                            Enums.Textures.Min_Filter, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Minifying_Filter;

   procedure Set_Magnifying_Filter (Object : Texture;
                                    Filter : Magnifying_Function) is
   begin
      API.Texture_Parameter_Mag_Filter (Object.Reference.GL_Id,
                                        Enums.Textures.Mag_Filter, Filter);
      Raise_Exception_On_OpenGL_Error;
   end Set_Magnifying_Filter;

   function Magnifying_Filter (Object : Texture)
                               return Magnifying_Function is
      Ret : Magnifying_Function := Magnifying_Function'First;
   begin
      API.Get_Texture_Parameter_Mag_Filter (Object.Reference.GL_Id,
                                            Enums.Textures.Mag_Filter, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Magnifying_Filter;

   procedure Set_Minimum_LoD (Object : Texture; Level : Double) is
   begin
      API.Texture_Parameter_Float (Object.Reference.GL_Id,
                                   Enums.Textures.Min_LoD, Single (Level));
      Raise_Exception_On_OpenGL_Error;
   end Set_Minimum_LoD;

   function Minimum_LoD (Object : Texture) return Double is
      Ret : Low_Level.Single_Array (1 .. 1);
   begin
      API.Get_Texture_Parameter_Floats (Object.Reference.GL_Id,
                                        Enums.Textures.Min_LoD, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Double (Ret (1));
   end Minimum_LoD;

   procedure Set_Maximum_LoD (Object : Texture; Level : Double) is
   begin
      API.Texture_Parameter_Float (Object.Reference.GL_Id,
                                   Enums.Textures.Max_LoD, Single (Level));
      Raise_Exception_On_OpenGL_Error;
   end Set_Maximum_LoD;

   function Maximum_LoD (Object : Texture) return Double is
      Ret : Low_Level.Single_Array (1 .. 1);
   begin
      API.Get_Texture_Parameter_Floats (Object.Reference.GL_Id,
                                       Enums.Textures.Max_LoD, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Double (Ret (1));
   end Maximum_LoD;

   procedure Set_Lowest_Mipmap_Level (Object : Texture; Level : Mipmap_Level) is
   begin
      API.Texture_Parameter_Int (Object.Reference.GL_Id,
                                 Enums.Textures.Base_Level, Level);
      Raise_Exception_On_OpenGL_Error;
   end Set_Lowest_Mipmap_Level;

   function Lowest_Mipmap_Level (Object : Texture) return Mipmap_Level is
      Ret : Mipmap_Level := Mipmap_Level'First;
   begin
      API.Get_Texture_Parameter_Int (Object.Reference.GL_Id,
                                     Enums.Textures.Base_Level, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Lowest_Mipmap_Level;

   procedure Set_Highest_Mipmap_Level (Object : Texture; Level : Mipmap_Level) is
   begin
      API.Texture_Parameter_Int (Object.Reference.GL_Id,
                                 Enums.Textures.Max_Level, Level);
      Raise_Exception_On_OpenGL_Error;
   end Set_Highest_Mipmap_Level;

   function Highest_Mipmap_Level (Object : Texture)
                                  return Mipmap_Level is
      Ret : Mipmap_Level := Mipmap_Level'First;
   begin
      API.Get_Texture_Parameter_Int (Object.Reference.GL_Id,
                                     Enums.Textures.Max_Level, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Highest_Mipmap_Level;

   function Mipmap_Levels (Object : Texture) return Mipmap_Level is
      Result : Mipmap_Level := Mipmap_Level'First;
   begin
      API.Get_Texture_Parameter_Int
        (Object.Reference.GL_Id, Enums.Textures.Immutable_Levels, Result);
      Raise_Exception_On_OpenGL_Error;
      return Result;
   end Mipmap_Levels;

   procedure Set_Seamless_Filtering (Object : Texture; Enable : Boolean) is
   begin
      API.Texture_Parameter_Bool
        (Object.Reference.GL_Id, Enums.Textures.Cube_Map_Seamless,
         Low_Level.Bool (Enable));
      Raise_Exception_On_OpenGL_Error;
   end Set_Seamless_Filtering;

   function Seamless_Filtering   (Object : Texture) return Boolean is
      Result : Low_Level.Bool := Low_Level.Bool'First;
   begin
      API.Get_Texture_Parameter_Bool
        (Object.Reference.GL_Id, Enums.Textures.Cube_Map_Seamless, Result);
      Raise_Exception_On_OpenGL_Error;
      return Boolean (Result);
   end Seamless_Filtering;

   procedure Set_Max_Anisotropy (Object : Texture; Degree : Double) is
   begin
      API.Texture_Parameter_Float (Object.Reference.GL_Id,
                                   Enums.Textures.Max_Anisotropy,
                                   Single (Degree));
      Raise_Exception_On_OpenGL_Error;
   end Set_Max_Anisotropy;

   function Max_Anisotropy (Object : Texture) return Double is
      Ret : Low_Level.Single_Array (1 .. 1);
   begin
      API.Get_Texture_Parameter_Floats (Object.Reference.GL_Id,
                                        Enums.Textures.Max_Anisotropy, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Double (Ret (1));
   end Max_Anisotropy;

   procedure Set_X_Wrapping (Object : Texture; Mode : Wrapping_Mode) is
   begin
      API.Texture_Parameter_Wrap_Mode (Object.Reference.GL_Id,
                                       Enums.Textures.Wrap_S,
                                       Mode);
      Raise_Exception_On_OpenGL_Error;
   end Set_X_Wrapping;

   function X_Wrapping (Object : Texture) return Wrapping_Mode is
      Ret : Wrapping_Mode := Wrapping_Mode'First;
   begin
      API.Get_Texture_Parameter_Wrap_Mode (Object.Reference.GL_Id,
                                           Enums.Textures.Wrap_S, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end X_Wrapping;

   procedure Set_Y_Wrapping (Object : Texture; Mode : Wrapping_Mode) is
   begin
      API.Texture_Parameter_Wrap_Mode (Object.Reference.GL_Id,
                                       Enums.Textures.Wrap_T,
                                       Mode);
      Raise_Exception_On_OpenGL_Error;
   end Set_Y_Wrapping;

   function Y_Wrapping (Object : Texture) return Wrapping_Mode is
      Ret : Wrapping_Mode := Wrapping_Mode'First;
   begin
      API.Get_Texture_Parameter_Wrap_Mode (Object.Reference.GL_Id,
                                           Enums.Textures.Wrap_T, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Y_Wrapping;

   procedure Set_Z_Wrapping (Object : Texture; Mode : Wrapping_Mode) is
   begin
      API.Texture_Parameter_Wrap_Mode (Object.Reference.GL_Id,
                                       Enums.Textures.Wrap_R,
                                       Mode);
      Raise_Exception_On_OpenGL_Error;
   end Set_Z_Wrapping;

   function Z_Wrapping (Object : Texture) return Wrapping_Mode is
      Ret : Wrapping_Mode := Wrapping_Mode'First;
   begin
      API.Get_Texture_Parameter_Wrap_Mode (Object.Reference.GL_Id,
                                           Enums.Textures.Wrap_R, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Z_Wrapping;

   procedure Set_Border_Color (Object : Texture; Color : Colors.Color) is

      Raw : constant Low_Level.Single_Array := Helpers.Float_Array (Color);
   begin
      API.Texture_Parameter_Floats (Object.Reference.GL_Id,
                                    Enums.Textures.Border_Color,
                                    Raw);
      Raise_Exception_On_OpenGL_Error;
   end Set_Border_Color;

   function Border_Color (Object : Texture) return Colors.Color is
      Raw : Low_Level.Single_Array (1 .. 4);
   begin
      API.Get_Texture_Parameter_Floats (Object.Reference.GL_Id,
                                        Enums.Textures.Border_Color, Raw);
      Raise_Exception_On_OpenGL_Error;
      return Helpers.Color (Raw);
   end Border_Color;

   procedure Toggle_Compare_X_To_Texture (Object : Texture;
                                          Enabled : Boolean) is
      Value : Enums.Textures.Compare_Kind;
   begin
      if Enabled then
         Value := Enums.Textures.Compare_R_To_Texture;
      else
         Value := Enums.Textures.None;
      end if;
      API.Texture_Parameter_Compare_Mode (Object.Reference.GL_Id,
                                          Enums.Textures.Compare_Mode,
                                          Value);
      Raise_Exception_On_OpenGL_Error;
   end Toggle_Compare_X_To_Texture;

   function Compare_X_To_Texture_Enabled (Object : Texture)
                                          return Boolean is
      use type Enums.Textures.Compare_Kind;

      Value : Enums.Textures.Compare_Kind := Enums.Textures.Compare_Kind'First;
   begin
      API.Get_Texture_Parameter_Compare_Mode (Object.Reference.GL_Id,
                                              Enums.Textures.Compare_Mode, Value);
      Raise_Exception_On_OpenGL_Error;
      return Value = Enums.Textures.Compare_R_To_Texture;
   end Compare_X_To_Texture_Enabled;

   procedure Set_Compare_Function (Object : Texture;
                                   Func   : Compare_Function) is
   begin
      API.Texture_Parameter_Compare_Func (Object.Reference.GL_Id,
                                          Enums.Textures.Compare_Func,
                                          Func);
      Raise_Exception_On_OpenGL_Error;
   end Set_Compare_Function;

   function Current_Compare_Function (Object : Texture)
                                     return Compare_Function is
      Value : Compare_Function := Compare_Function'First;
   begin
      API.Get_Texture_Parameter_Compare_Func (Object.Reference.GL_Id,
                                              Enums.Textures.Compare_Func,
                                              Value);
      Raise_Exception_On_OpenGL_Error;
      return Value;
   end Current_Compare_Function;

   procedure Clear_Using_Data
     (Object : Texture; Level : Mipmap_Level;
      Source_Format : Pixels.Format;
      Source_Type   : Pixels.Data_Type;
      Source        : System.Address) is
   begin
      API.Clear_Tex_Image
        (Object.Reference.GL_Id, Level, Source_Format, Source_Type, Source);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Using_Data;

   procedure Clear_Using_Zeros
     (Object : Texture; Level : Mipmap_Level) is
   begin
      API.Clear_Tex_Image
        (Object.Reference.GL_Id, Level, Pixels.Format'First,
         Pixels.Data_Type'First, System.Null_Address);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Using_Zeros;

   procedure Generate_Mipmap (Object : Texture) is
   begin
      API.Generate_Texture_Mipmap (Object.Reference.GL_Id);
      Raise_Exception_On_OpenGL_Error;
   end Generate_Mipmap;

   function Active_Unit return Texture_Unit is
      function Maximum return Int is
         Max : Int := 0;
      begin
         API.Get_Integer (Enums.Getter.Max_Combined_Texture_Image_Units, Max);
         Raise_Exception_On_OpenGL_Error;
         return Max - 1;
      end Maximum;

      package Texture_Indexing is new Enums.Indexes
        (Enums.Textures.Texture_Unit_Start_Rep, Maximum);

      Raw_Unit : Int := Enums.Textures.Texture_Unit_Start_Rep;
   begin
      API.Get_Integer (Enums.Getter.Active_Texture, Raw_Unit);
      Raise_Exception_On_OpenGL_Error;
      return UInt (Texture_Indexing.Value (Raw_Unit));
   end Active_Unit;

   function Texture_Unit_Count return Natural is
      Count : Int := 0;
   begin
      API.Get_Integer (Enums.Getter.Max_Combined_Texture_Image_Units, Count);
      Raise_Exception_On_OpenGL_Error;
      return Natural (Count);
   end Texture_Unit_Count;

   function Maximum_Anisotropy return Single is
      Ret : Single := 16.0;
   begin
      API.Get_Single (Enums.Getter.Max_Texture_Max_Anisotropy, Ret);
      Raise_Exception_On_OpenGL_Error;
      return Ret;
   end Maximum_Anisotropy;

   -----------------------------------------------------------------------------
   --                        Buffer Texture Loading                           --
   -----------------------------------------------------------------------------

   procedure Attach_Buffer (Object : Buffer_Texture;
                            Internal_Format : Pixels.Internal_Format_Buffer_Texture;
                            Buffer : Objects.Buffers.Buffer) is
   begin
      API.Texture_Buffer (Object.Reference.GL_Id, Internal_Format, Buffer.Raw_Id);
      Raise_Exception_On_OpenGL_Error;
   end Attach_Buffer;

   procedure Attach_Buffer (Object : Buffer_Texture;
                            Internal_Format : Pixels.Internal_Format_Buffer_Texture;
                            Buffer : Objects.Buffers.Buffer;
                            Offset, Size : Types.Size) is
   begin
      API.Texture_Buffer_Range (Object.Reference.GL_Id, Internal_Format, Buffer.Raw_Id,
                                Low_Level.IntPtr (Offset), Size);
      Raise_Exception_On_OpenGL_Error;
   end Attach_Buffer;

   -----------------------------------------------------------------------------
   --                           Texture Loading                               --
   -----------------------------------------------------------------------------

   procedure Allocate_Storage
     (Object : in out Texture;
      Levels, Samples : Types.Size;
      Format : Pixels.Internal_Format;
      Width, Height, Depth : Types.Size;
      Fixed_Locations : Boolean := True) is
   begin
      if Object.Kind in Texture_2D_Multisample | Texture_2D_Multisample_Array then
         case Object.Dimensions is
            when One =>
               raise Program_Error;
            when Two =>
               API.Texture_Storage_2D_Multisample
                 (Object.Reference.GL_Id, Samples,
                  Format, Width, Height, Low_Level.Bool (Fixed_Locations));
            when Three =>
               API.Texture_Storage_3D_Multisample
                 (Object.Reference.GL_Id, Samples,
                  Format, Width, Height, Depth, Low_Level.Bool (Fixed_Locations));
         end case;
      else
         case Object.Dimensions is
            when One =>
               API.Texture_Storage_1D
                 (Object.Reference.GL_Id, Levels, Format, Width);
            when Two =>
               API.Texture_Storage_2D
                 (Object.Reference.GL_Id, Levels, Format, Width, Height);
            when Three =>
               API.Texture_Storage_3D
                 (Object.Reference.GL_Id, Levels, Format, Width, Height, Depth);
         end case;
      end if;
      Raise_Exception_On_OpenGL_Error;
      Object.Allocated := True;
   end Allocate_Storage;

   procedure Allocate_Storage
     (Object : in out Texture;
      Levels, Samples : Types.Size;
      Format : Pixels.Compressed_Format;
      Width, Height, Depth : Types.Size;
      Fixed_Locations : Boolean := True) is
   begin
      if Object.Kind in Texture_2D_Multisample | Texture_2D_Multisample_Array then
         case Object.Dimensions is
            when One =>
               raise Program_Error;
            when Two =>
               API.Texture_Storage_2D_Multisample
                 (Object.Reference.GL_Id, Samples,
                  Format, Width, Height, Low_Level.Bool (Fixed_Locations));
            when Three =>
               API.Texture_Storage_3D_Multisample
                 (Object.Reference.GL_Id, Samples,
                  Format, Width, Height, Depth, Low_Level.Bool (Fixed_Locations));
         end case;
      else
         case Object.Dimensions is
            when One =>
               raise Program_Error;
            when Two =>
               API.Texture_Storage_2D
                 (Object.Reference.GL_Id, Levels, Format, Width, Height);
            when Three =>
               API.Texture_Storage_3D
                 (Object.Reference.GL_Id, Levels, Format, Width, Height, Depth);
         end case;
      end if;
      Raise_Exception_On_OpenGL_Error;
      Object.Allocated := True;
   end Allocate_Storage;

   procedure Load_From_Data
     (Object : Texture;
      Level  : Mipmap_Level;
      X, Y, Z              : Types.Size := 0;
      Width, Height, Depth : Types.Positive_Size;
      Source_Format : Pixels.Format;
      Source_Type   : Pixels.Data_Type;
      Source        : System.Address)
   is
      --  Data is considered to be packed. When loading it to a texture,
      --  it will be unpacked. Therefore, each row must be a multiple of the
      --  current unpack alignment. Call Set_Unpack_Alignment if necessary.
      Alignment : constant Byte_Count := PE.Byte_Alignment (Pixels.Unpack_Alignment);
      pragma Assert ((Width * PE.Bytes (Source_Type)) mod Alignment = 0);

      --  Texture_Cube_Map uses 2D storage, but 3D load operation
      --  according to table 8.15 of the OpenGL specification
      Dimensions : constant Dimension_Count
        := (if Object.Kind = Texture_Cube_Map then Three else Object.Dimensions);
   begin
      case Dimensions is
         when One =>
            API.Texture_Sub_Image_1D
              (Object.Reference.GL_Id, Level, X, Width, Source_Format,
               Source_Type, Source);
         when Two =>
            API.Texture_Sub_Image_2D
              (Object.Reference.GL_Id, Level, X, Y, Width, Height,
               Source_Format, Source_Type, Source);
         when Three =>
            API.Texture_Sub_Image_3D
              (Object.Reference.GL_Id, Level, X, Y, Z, Width, Height, Depth,
               Source_Format, Source_Type, Source);
      end case;
      Raise_Exception_On_OpenGL_Error;
   end Load_From_Data;

   procedure Load_From_Data
     (Object : Texture;
      Level  : Mipmap_Level;
      X, Y, Z              : Types.Size := 0;
      Width, Height, Depth : Types.Positive_Size;
      Source_Format : Pixels.Compressed_Format;
      Image_Size    : Types.Size;
      Source        : System.Address)
   is
      --  Texture_Cube_Map uses 2D storage, but 3D load operation
      --  according to table 8.15 of the OpenGL specification
      Dimensions : constant Dimension_Count
        := (if Object.Kind = Texture_Cube_Map then Three else Object.Dimensions);
   begin
      case Dimensions is
         when One =>
            raise Program_Error;
         when Two =>
            API.Compressed_Texture_Sub_Image_2D
              (Object.Reference.GL_Id, Level, X, Y, Width, Height,
               Source_Format, Image_Size, Source);
         when Three =>
            API.Compressed_Texture_Sub_Image_3D
              (Object.Reference.GL_Id, Level, X, Y, Z, Width, Height, Depth,
               Source_Format, Image_Size, Source);
      end case;
      Raise_Exception_On_OpenGL_Error;
   end Load_From_Data;

   procedure Copy_Data
     (Object  : Texture;
      Subject : Texture;
      Source_Level, Target_Level : Mipmap_Level) is
   begin
      Object.Copy_Sub_Data
        (Subject, Source_Level, Target_Level, 0, 0, 0, 0, 0, 0,
         Object.Width (Source_Level), Object.Height (Source_Level),
         Object.Depth (Source_Level));
   end Copy_Data;

   procedure Copy_Sub_Data
     (Object  : Texture;
      Subject : Texture;
      Source_Level, Target_Level : Mipmap_Level;
      Source_X, Source_Y, Source_Z : Types.Size := 0;
      Target_X, Target_Y, Target_Z : Types.Size := 0;
      Width, Height, Depth : Types.Size) is
   begin
      API.Copy_Image_Sub_Data
        (Object.Reference.GL_Id, Object.Kind, Source_Level,
         Source_X, Source_Y, Source_Z,
         Subject.Reference.GL_Id, Subject.Kind, Target_Level,
         Target_X, Target_Y, Target_Z,
         Width, Height, Depth);
      Raise_Exception_On_OpenGL_Error;
   end Copy_Sub_Data;

   procedure Clear_Using_Data
     (Object : Texture;
      Level  : Mipmap_Level;
      X, Y, Z              : Types.Size := 0;
      Width, Height, Depth : Types.Positive_Size;
      Source_Format : Pixels.Format;
      Source_Type   : Pixels.Data_Type;
      Source        : System.Address) is
   begin
      API.Clear_Tex_Sub_Image
        (Object.Reference.GL_Id, Level, X, Y, Z, Width, Height, Depth,
         Source_Format, Source_Type, Source);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Using_Data;

   procedure Clear_Using_Zeros
     (Object : Texture;
      Level  : Mipmap_Level;
      X, Y, Z              : Types.Size := 0;
      Width, Height, Depth : Types.Positive_Size) is
   begin
      API.Clear_Tex_Sub_Image
        (Object.Reference.GL_Id, Level, X, Y, Z, Width, Height, Depth,
         Pixels.Format'First, Pixels.Data_Type'First, System.Null_Address);
      Raise_Exception_On_OpenGL_Error;
   end Clear_Using_Zeros;

   -----------------------------------------------------------------------------

   function Get_Compressed_Data
     (Object : Texture;
      Level  : Mipmap_Level;
      X, Y, Z              : Types.Size := 0;
      Width, Height, Depth : Types.Positive_Size;
      Format : Pixels.Compressed_Format) return not null Types.UByte_Array_Access
   is
      Blocks : constant Int := ((Width + 3) / 4) * ((Height + 3) / 4) * Depth;
      Number_Of_Bytes : constant Int := Blocks * PE.Block_Bytes (Format);

      Result : constant Types.UByte_Array_Access
        := new UByte_Array (1 .. Number_Of_Bytes);
   begin
      API.Get_Compressed_Texture_Sub_Image
        (Object.Reference.GL_Id, Level, X, Y, Z, Width, Height, Depth,
         Number_Of_Bytes, Result);
      Raise_Exception_On_OpenGL_Error;
      return Result;
   end Get_Compressed_Data;

   package body Texture_Pointers is

      procedure Get_Texture_Sub_Image is new API.Loader.Procedure_With_12_Params
        ("glGetTextureSubImage", UInt, Objects.Textures.Mipmap_Level,
         Int, Int, Int, Size, Size, Size, Pixels.Format, Pixels.Data_Type,
         Size, Element_Array_Access);

      function Get_Data
        (Object    : Texture;
         Level     : Mipmap_Level;
         X, Y, Z              : Types.Size := 0;
         Width, Height, Depth : Types.Positive_Size;
         Format    : Pixels.Format;
         Data_Type : PE.Non_Packed_Data_Type) return not null Element_Array_Access
      is
         --  Texture data is considered to be unpacked. When retrieving
         --  it from a texture, it will be packed. Therefore, each row
         --  must be a multiple of the current pack alignment. Call
         --  Set_Pack_Alignment if necessary.
         Alignment : constant Byte_Count := PE.Byte_Alignment (Pixels.Pack_Alignment);
         pragma Assert ((Width * PE.Bytes (Data_Type)) mod Alignment = 0);

         Bytes_Per_Element : constant Int := Pointers.Element'Size / System.Storage_Unit;
         Bytes_Per_Texel   : constant Int := PE.Components (Format) * PE.Bytes (Data_Type);
         --  TODO Handle packed data types and depth/stenil formats
         pragma Assert (Bytes_Per_Texel rem Bytes_Per_Element = 0);

         Texels : constant Size := Width * Height * Depth;
         pragma Assert (Texels > 0);

         Number_Of_Bytes : constant Int := Texels * Bytes_Per_Texel;
         Length : constant Long := Long (Texels * (Bytes_Per_Texel / Bytes_Per_Element));

         I1 : constant Pointers.Index := Pointers.Index'First;
         I2 : constant Pointers.Index := Pointers.Index'Val (Pointers.Index'Pos (I1) + Length);
         Result : constant Element_Array_Access
           := new Pointers.Element_Array (I1 .. Pointers.Index'Pred (I2));
         pragma Assert (Result'Length > 0);
      begin
         Get_Texture_Sub_Image
           (Object.Reference.GL_Id, Level, X, Y, Z, Width, Height, Depth,
            Format, Data_Type, Number_Of_Bytes, Result);
         Raise_Exception_On_OpenGL_Error;
         return Result;
      end Get_Data;

   end Texture_Pointers;

end GL.Objects.Textures;
