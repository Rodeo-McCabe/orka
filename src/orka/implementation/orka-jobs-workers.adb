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

with System.Multiprocessors.Dispatching_Domains;

with Ada.Exceptions;
with Ada.Strings.Fixed;
with Ada.Text_IO;

with Orka.OS;

package body Orka.Jobs.Workers is

   task body Worker_Task is
      package SM renames System.Multiprocessors;
      package SF renames Ada.Strings.Fixed;

      use type SM.CPU;

      ID   : constant String := Positive'Image (Data.ID);
      Name : constant String := Prefix & " #" & SF.Trim (ID, Ada.Strings.Left);

      Job  : Job_Ptr := Null_Job;
      Stop : Boolean := False;
   begin
      --  Set the CPU affinity of the task to its corresponding CPU core
      SM.Dispatching_Domains.Set_CPU (SM.CPU (Data.ID) + 1);
      Orka.OS.Set_Task_Name (Name);

      loop
         --  TODO Handle idling > 10 s + idling > 10 ms
         Queue.Dequeue (Job, Stop);
         exit when Stop;

         Job.Execute (Queue);

         --  If another job depends on this job, decrement its dependencies counter
         --  and if it has reached zero then it can be scheduled
         if Job.Dependent /= Null_Job and then Job.Dependent.Decrement_Dependencies then
            Queue.Enqueue (Job.Dependent);
         end if;

         Free (Job);
      end loop;
   exception
      when Error : others =>
         Ada.Text_IO.Put_Line (Name & ": " & Ada.Exceptions.Exception_Information (Error));
   end Worker_Task;

   function Make_Workers return Worker_Array is
   begin
      return Result : Worker_Array (1 .. Positive (Count)) do
         for Index in Result'Range loop
            Result (Index).ID := Index;
         end loop;
      end return;
   end Make_Workers;

   procedure Shutdown is
   begin
      Queue.Shutdown;
   end Shutdown;

end Orka.Jobs.Workers;