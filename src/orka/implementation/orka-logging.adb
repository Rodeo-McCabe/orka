--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2018 onox <denkpadje@gmail.com>
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

with Ada.Text_IO;

with Orka.Terminals;

package body Orka.Logging is

   function Format_Message
     (From    : Source;
      Kind    : Message_Type;
      Level   : Severity;
      ID      : Natural;
      Message : String) return String
   is
      Level_Color : constant Terminals.Color
        := (case Level is
              when Error   => Terminals.Red,
              when Warning => Terminals.Yellow,
              when Info    => Terminals.Blue,
              when Debug   => Terminals.Green);

      Time_Image : constant String := Terminals.Time_Image;
   begin
      return Terminals.Colorize ("[" & Time_Image & " " & Level'Image & "]", Level_Color) &
             " " &
             Terminals.Colorize ("[" & From'Image & ":" & Kind'Image & "]", Terminals.Magenta) &
             ID'Image & ": " & Terminals.Strip_Line_Term (Message);
   end Format_Message;

   function Image (Value : Ada.Real_Time.Time_Span) return String is
     (Terminals.Image (Ada.Real_Time.To_Duration (Value)));

   function Trim (Value : String) return String is (Terminals.Trim (Value));

   -----------------------------------------------------------------------------

   procedure Log
     (From    : Source;
      Kind    : Message_Type;
      Level   : Severity;
      ID      : Natural;
      Message : String) is
   begin
      Ada.Text_IO.Put_Line (Format_Message (From, Kind, Level, ID, Message));
   end Log;

   package body Messages is
      Kind : constant Message_Type := Message_Type (GL.Debug.Message_Type'(GL.Debug.Other));
      --  TODO Make generic parameter

      procedure Log (Level : Severity; Message : String) is
      begin
         Orka.Logging.Log (From, Kind, Level, ID, Message);
      end Log;
   end Messages;

end Orka.Logging;
