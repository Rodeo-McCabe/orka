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

with System;

with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

package body Orka.Loops is

   use Ada.Real_Time;

   procedure Free is new Ada.Unchecked_Deallocation
     (Behavior_Array, Behavior_Array_Access);

   function Behavior_Hash (Element : Behaviors.Behavior_Ptr) return Ada.Containers.Hash_Type is
      function Convert is new Ada.Unchecked_Conversion
        (Source => System.Address, Target => Long_Integer);
   begin
      return Ada.Containers.Hash_Type (Convert (Element.all'Address));
   end Behavior_Hash;

   procedure Fixed_Update (Delta_Time : Time_Span; Scene : Behavior_Array_Access) is
      DT : constant Duration := Ada.Real_Time.To_Duration (Delta_Time);
   begin
      for Behavior of Scene.all loop
         Behavior.Fixed_Update (DT);
      end loop;
   end Fixed_Update;

   procedure Update (Delta_Time : Time_Span; Scene : Behavior_Array_Access) is
      DT : constant Duration := Ada.Real_Time.To_Duration (Delta_Time);
   begin
      for Behavior of Scene.all loop
         Behavior.Update (DT);
      end loop;
      for Behavior of Scene.all loop
         Behavior.After_Update (DT);
      end loop;
   end Update;

   procedure Render (Scene : Behavior_Array_Access) is
   begin
      --  TODO
      null;
   end Render;

   protected body Handler is
      procedure Stop is
      begin
         Stop_Flag := True;
      end Stop;

      procedure Set_Frame_Limit (Value : Ada.Real_Time.Time_Span) is
      begin
         Limit := Value;
      end Set_Frame_Limit;

      function Frame_Limit return Ada.Real_Time.Time_Span is
        (Limit);

      function Should_Stop return Boolean is
        (Stop_Flag);
   end Handler;

   protected body Scene is
      procedure Add (Object : Behaviors.Behavior_Ptr) is
      begin
         Behaviors_Set.Insert (Object);
         Modified_Flag := True;
      end Add;

      procedure Remove (Object : Behaviors.Behavior_Ptr) is
      begin
         Behaviors_Set.Delete (Object);
         Modified_Flag := True;
      end Remove;

      procedure Replace_Array (Target : in out Behavior_Array_Access) is
         Index : Positive := 1;
      begin
         if Target /= null then
            Free (Target);
         end if;
         Target := new Behavior_Array (1 .. Positive (Behaviors_Set.Length));

         --  Copy the elements from the set to the array
         --  for faster iteration by the game loop
         for Element of Behaviors_Set loop
            Target (Index) := Element;
            Index := Index + 1;
         end loop;

         Modified_Flag := False;
      end Replace_Array;

      function Modified return Boolean is
        (Modified_Flag);
   end Scene;

   task body Game_Loop is
      Previous_Time : Time := Clock;
      Lag : Time_Span := Time_Span_Zero;
      Next_Time : Time := Previous_Time;

      Scene_Array : Behavior_Array_Access := null;
   begin
      --  TODO Synchronize with display's refresh rate
      --  Based on http://gameprogrammingpatterns.com/game-loop.html
      loop
         declare
            Current_Time : constant Time := Clock;
            Elapsed : constant Time_Span := Current_Time - Previous_Time;
         begin
            Previous_Time := Current_Time;
            Lag := Lag + Elapsed;

            Window.Process_Input;

            exit when Handler.Should_Stop or Window.Should_Close;

            while Lag > Time_Step loop
               Fixed_Update (Time_Step, Scene_Array);
               Lag := Lag - Time_Step;
            end loop;

            Update (Lag, Scene_Array);

            Window.Swap_Buffers;

            --  Render the scene *after* having swapped buffers (sync point)
            --  so that rendering on GPU happens in parallel with CPU work
            --  during the next frame
            Render (Scene_Array);

            if Scene.Modified then
               --  TODO Deallocation and allocation should not be done in render loop
               Scene.Replace_Array (Scene_Array);
            end if;

            declare
               New_Elapsed : constant Time_Span := Clock - Current_Time;
            begin
               if New_Elapsed > Handler.Frame_Limit then
                  --  TODO Should we stay synchronized with the display?
                  --  TODO In that case do Next_Time + n * Handler.Frame_Limit;
                  Next_Time := Current_Time;
               else
                  Next_Time := Next_Time + Handler.Frame_Limit;
                  delay until Next_Time;
               end if;
            end;
         end;
      end loop;
   end Game_Loop;

end Orka.Loops;
