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

with Ada.Containers.Hashed_Sets;
with Ada.Real_Time;

with Orka.Behaviors;
with Orka.Cameras;
with Orka.Transforms.SIMD_Vectors;
with Orka.Windows;

generic
   Time_Step, Frame_Limit : Ada.Real_Time.Time_Span;
   Window : not null access Windows.Window'Class;
   Camera : Cameras.Camera_Ptr;
   Render : access procedure (Scene : not null Behaviors.Behavior_Array_Access; Camera : Cameras.Camera_Ptr);
   with package Transforms is new Orka.Transforms.SIMD_Vectors (<>);
package Orka.Loops is

   protected Handler is
      procedure Stop;

      procedure Set_Frame_Limit (Value : Ada.Real_Time.Time_Span);

      function Frame_Limit return Ada.Real_Time.Time_Span;

      function Should_Stop return Boolean;
   private
      Limit : Ada.Real_Time.Time_Span := Orka.Loops.Frame_Limit;
      Stop_Flag : Boolean := False;
   end Handler;

   use type Behaviors.Behavior_Ptr;
   use type Behaviors.Behavior_Array_Access;

   function Behavior_Hash (Element : Behaviors.Behavior_Ptr) return Ada.Containers.Hash_Type;

   package Behavior_Sets is new Ada.Containers.Hashed_Sets
     (Behaviors.Behavior_Ptr, Behavior_Hash, "=");

   protected Scene is
      procedure Add (Object : Behaviors.Behavior_Ptr)
        with Post => Modified;

      procedure Remove (Object : Behaviors.Behavior_Ptr)
        with Post => Modified;

      procedure Replace_Array (Target : in out Behaviors.Behavior_Array_Access)
        with Pre  => Target /= null and Modified,
             Post => Target /= null and not Modified;

      function Modified return Boolean;

      procedure Set_Camera (Camera : Cameras.Camera_Ptr);

      function Camera return Cameras.Camera_Ptr;
   private
      Modified_Flag : Boolean := False;
      Behaviors_Set : Behavior_Sets.Set;
      Scene_Camera  : Cameras.Camera_Ptr := Orka.Loops.Camera;
   end Scene;

   procedure Run_Loop;

end Orka.Loops;
