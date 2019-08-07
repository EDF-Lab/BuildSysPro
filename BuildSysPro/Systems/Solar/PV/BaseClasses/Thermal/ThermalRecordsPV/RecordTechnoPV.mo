within BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal.ThermalRecordsPV;
record RecordTechnoPV
  "Record to keep for each PV technology a set of characteristics to be used in thermal models"

  parameter Integer n=7 "Number of layers of the PV panel";
  parameter Integer ncell=3
    "Level at which the PV cell is located (from the front face)";
  parameter BuildSysPro.Utilities.Records.GenericSolid mat[n]
    "Constituent materials of the PV panel (from front face to back face)";
  parameter Modelica.SIunits.Length epaisseur[n]
    "Layers thickness of the PV panel (from front face to back face)";
  parameter Integer[n] m=fill(1, n)
    "Number of meshes per layer (from front face to back face)";
  parameter Real cp_surf "Heat capacity of the PV panel per m² (J/K.m²)";
  parameter Modelica.SIunits.Emissivity eps_fg "Front face emissivity in LWR";
  parameter Modelica.SIunits.Emissivity eps_bg "Back face emissivity in LWR";
  parameter Real alpha_tau_n
    "Transmission - absorption of PV panel at normal incidence";

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated record - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p></html>"));
end RecordTechnoPV;
