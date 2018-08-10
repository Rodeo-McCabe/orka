--  Copyright (c) 2016 onox <denkpadje@gmail.com>
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

with Ada.Real_Time;
with Ada.Unchecked_Deallocation;

private with Orka.glTF.Buffers;
private with Orka.glTF.Accessors;
private with Orka.glTF.Meshes;
private with Orka.glTF.Scenes;

private with Orka.Jobs;
private with Orka.Resources.Locations;

with Orka.Resources.Loaders;
with Orka.Resources.Managers;

package Orka.Resources.Models.glTF is

   function Create_Loader
     (Format  : Rendering.Vertex_Formats.Vertex_Format_Ptr;
      Transforms   : not null access Rendering.Programs.Uniforms.Uniform_Sampler;
      Index_Offset : not null access Rendering.Programs.Uniforms.Uniform;
      Manager : Managers.Manager_Ptr) return Loaders.Loader_Ptr;

private

   use Ada.Real_Time;

   type JSON_Value_Access is access Orka.glTF.Types.JSON_Value'Class;

   procedure Free_JSON is new Ada.Unchecked_Deallocation
     (Object => Orka.glTF.Types.JSON_Value'Class, Name => JSON_Value_Access);

   type Times_Data is record
      Reading    : Time_Span;
      Parsing    : Time_Span;
      Processing : Time_Span;
      Scene      : Time_Span;
      Buffers    : Time_Span;
   end record;

   type GLTF_Data is limited record
      JSON      : JSON_Value_Access;
      Directory : SU.Unbounded_String;
      Location  : Locations.Location_Ptr;
      Buffers   : Orka.glTF.Buffers.Buffer_Vectors.Vector;
      Views     : Orka.glTF.Buffers.Buffer_View_Vectors.Vector;
      Accessors : Orka.glTF.Accessors.Accessor_Vectors.Vector;
      Meshes    : Orka.glTF.Meshes.Mesh_Vectors.Vector;
      Nodes     : Orka.glTF.Scenes.Node_Vectors.Vector;
      Scenes    : Orka.glTF.Scenes.Scene_Vectors.Vector;
      Times     : Times_Data := (others => Time_Span_Zero);
      Start_Time : Time;
      Format    : Rendering.Vertex_Formats.Vertex_Format_Ptr;
      Transforms   : not null access Rendering.Programs.Uniforms.Uniform_Sampler;
      Index_Offset : not null access Rendering.Programs.Uniforms.Uniform;
      Manager   : Managers.Manager_Ptr;
   end record;

   type GLTF_Data_Access is access GLTF_Data;

   procedure Free_Data is new Ada.Unchecked_Deallocation
     (Object => GLTF_Data, Name => GLTF_Data_Access);

   type GLTF_Parse_Job is new Jobs.Abstract_Job with record
      Data     : Loaders.Resource_Data;
      Format   : Rendering.Vertex_Formats.Vertex_Format_Ptr;
      Transforms   : not null access Rendering.Programs.Uniforms.Uniform_Sampler;
      Index_Offset : not null access Rendering.Programs.Uniforms.Uniform;
      Manager  : Managers.Manager_Ptr;
      Location : Locations.Location_Ptr;
   end record;

   overriding
   procedure Execute
     (Object  : GLTF_Parse_Job;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

   type GLTF_Process_Buffers_Job is new Jobs.Abstract_Job with record
      Data : not null GLTF_Data_Access;
   end record;

   overriding
   procedure Execute
     (Object  : GLTF_Process_Buffers_Job;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

   type GLTF_Process_Accessors_Job is new Jobs.Abstract_Job with record
      Data : not null GLTF_Data_Access;
   end record;

   overriding
   procedure Execute
     (Object  : GLTF_Process_Accessors_Job;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

   type GLTF_Process_Meshes_Job is new Jobs.Abstract_Job with record
      Data : not null GLTF_Data_Access;
   end record;

   overriding
   procedure Execute
     (Object  : GLTF_Process_Meshes_Job;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

   type GLTF_Process_Nodes_Job is new Jobs.Abstract_Job with record
      Data : not null GLTF_Data_Access;
   end record;

   overriding
   procedure Execute
     (Object  : GLTF_Process_Nodes_Job;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

   type GLTF_Finish_Processing_Job is new Jobs.Abstract_Job with record
      Data : not null GLTF_Data_Access;
      Path : SU.Unbounded_String;
      Processing_Start_Time : Ada.Real_Time.Time;
   end record;

   overriding
   procedure Execute
     (Object  : GLTF_Finish_Processing_Job;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

   type GLTF_Create_Buffers_Job is new Jobs.Abstract_Job and Jobs.GPU_Job with record
      Data  : not null GLTF_Data_Access;
      Path  : SU.Unbounded_String;
      Scene : Model_Scene_Ptr;
      Vertices, Indices : Natural;
   end record;

   overriding
   procedure Execute
     (Object  : GLTF_Create_Buffers_Job;
      Enqueue : not null access procedure (Element : Jobs.Job_Ptr));

end Orka.Resources.Models.glTF;
