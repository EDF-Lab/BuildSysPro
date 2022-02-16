﻿within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM;
record BuildingType
  "List of unheated wall collective housing construction dates"
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall PlancherBas
    "Building floor";
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall MurExt
    "Exterior wall";
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    PlancherInterm "Common floor";
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    ParoiSousCombles "Building ceiling";
  parameter Modelica.Units.SI.Area S_LNC=27.5 "Surface of unheated room";
  parameter Real TauxRenouvAir "Air renewal rate in vol/h";
  parameter Real b_SousSol;
  // Thermal bridges
  replaceable parameter Modelica.Units.SI.ThermalConductance PontsTh_Generique
    "Value of thermal bridge common to all possible positions of the apartment (used in complete collective housing building assembly)";
  replaceable parameter Modelica.Units.SI.ThermalConductance PontsTh_Bas
    "Value of thermal bridge specific to an apartment on first floor (used in complete collective housing building assembly)";
  replaceable parameter Modelica.Units.SI.ThermalConductance PontsTh_Haut
    "Value of thermal bridge specific to an apartment on last floor (used in complete collective housing building assembly)";
  // Global exchange coefficients (convective and radiative)
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Hsext=25
    "Surface exchange coefficient on the outer face of vertical walls";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Hsint=7.69
    "Surface exchange coefficient on the inner face of vertical walls";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer HsParoiSousCombles=10
    "Surface exchange coefficient on the inner face of horizontal walls when the thermal flow is upwards";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer HsPlancherBas=5.88
    "Surface exchange coefficient on the inner face of horizontal walls when the thermal flow is downwards";
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState;
  parameter Real alpha_ext=0.6
    "Absorption coefficient of exterior walls in the visible spectrum";
    /*annotation(Dialog(enable=(not ParoiInterne), group="Propriétés générales de la paroi"))*/
  parameter Real eps=0.6
    "Emissivity of exterior walls for long wavelength radiation";
      /*annotation(Dialog(enable=GLOext, group="Propriétés générales de la paroi"))*/

 annotation (Documentation(info="<html>
<p><i><b>Record of unheated room collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Notes H-E10-1996-02908-FR  and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end BuildingType;