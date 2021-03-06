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

with Ada.Calendar.Formatting;
with Ada.Characters.Latin_1;
with Ada.Real_Time;
with Ada.Strings.Fixed;
with Ada.Text_IO;

with Orka.Strings;

package body Orka.Terminals is

   Style_Codes : constant array (Style) of Natural :=
     (Default   => 0,
      Bold      => 1,
      Dark      => 2,
      Italic    => 3,
      Underline => 4,
      Blink     => 5,
      Reversed  => 7,
      Cross_Out => 9);

   Foreground_Color_Codes : constant array (Color) of Natural :=
     (Default => 0,
      Grey    => 30,
      Red     => 31,
      Green   => 32,
      Yellow  => 33,
      Blue    => 34,
      Magenta => 35,
      Cyan    => 36,
      White   => 37);

   Background_Color_Codes : constant array (Color) of Natural :=
     (Default => 0,
      Grey    => 40,
      Red     => 41,
      Green   => 42,
      Yellow  => 43,
      Blue    => 44,
      Magenta => 45,
      Cyan    => 46,
      White   => 47);

   package L renames Ada.Characters.Latin_1;
   package SF renames Ada.Strings.Fixed;

   Reset : constant String := L.ESC & "[0m";

   function Sequence (Code : Natural) return String is
      Image : constant String := SF.Trim (Code'Image, Ada.Strings.Both);
   begin
      return (if Code /= 0 then L.ESC & "[" & Image & "m" else "");
   end Sequence;

   function Colorize (Text : String; Foreground, Background : Color := Default;
                      Attribute : Style := Default) return String is
      FG : constant String := Sequence (Foreground_Color_Codes (Foreground));
      BG : constant String := Sequence (Background_Color_Codes (Background));
      ST : constant String := Sequence (Style_Codes (Attribute));
   begin
      return Reset & FG & BG & ST & Text & Reset;
   end Colorize;

   -----------------------------------------------------------------------------

   Time_Zero : constant Ada.Real_Time.Time := Ada.Real_Time.Clock;

   Days_Since_Zero : Natural := 0;

   function Time_Image return String is
      use Ada.Real_Time;
      use Ada.Calendar.Formatting;

      Hour       : Hour_Number;
      Minute     : Minute_Number;
      Second     : Second_Number;
      Sub_Second : Second_Duration;

      Seconds_Since_Zero : Duration := To_Duration (Clock - Time_Zero);
   begin
      if Seconds_Since_Zero > Ada.Calendar.Day_Duration'Last then
         Seconds_Since_Zero := Seconds_Since_Zero - Ada.Calendar.Day_Duration'Last;
         Days_Since_Zero    := Days_Since_Zero + 1;
      end if;
      Split (Seconds_Since_Zero, Hour, Minute, Second, Sub_Second);

      declare
         --  Remove first character (space) from ' hhmmss' image and then pad it to six digits
         Image1 : constant String := Natural'Image
           ((Days_Since_Zero * 24 + Hour) * 1e4 + Minute * 1e2 + Second);
         Image2 : constant String := SF.Tail (Image1 (2 .. Image1'Last), 6, '0');

         --  Insert ':' characters to get 'hh:mm:ss'
         Image3 : constant String := SF.Insert (Image2, 5, ":");
         Image4 : constant String := SF.Insert (Image3, 3, ":");

         --  Take image without first character (space) and then pad it to six digits
         Image5 : constant String := Natural'Image (Natural (Sub_Second * 1e6));
         Image6 : constant String := SF.Tail (Image5 (2 .. Image5'Last), 6, '0');
      begin
         return Image4 & "." & Image6;
      end;
   end Time_Image;

   package Duration_IO is new Ada.Text_IO.Fixed_IO (Duration);

   type String_Access is not null access String;

   Suffices : constant array (1 .. 3) of String_Access
     := (new String'("s"),
         new String'("ms"),
         new String'("us"));
   Last_Suffix : constant String_Access := Suffices (Suffices'Last);

   function Image (Value : Duration) return String is
      Result : String   := "-9999.999";
      Number : Duration := Value;

      Suffix : String_Access := Suffices (Suffices'First);
   begin
      for S of Suffices loop
         Suffix := S;
         exit when Number >= 1.0 or else Number <= -1.0 or else S = Last_Suffix;
         Number := Number * 1e3;
      end loop;

      begin
         Duration_IO.Put (Result, Item => Number, Aft => 3);
      exception
         when others =>
            return Number'Image & " " & Suffix.all;
      end;
      return Result & " " & Suffix.all;
   end Image;

   function Trim (Value : String) return String renames Orka.Strings.Trim;

   function Strip_Line_Term (Value : String) return String renames Orka.Strings.Strip_Line_Term;

end Orka.Terminals;
