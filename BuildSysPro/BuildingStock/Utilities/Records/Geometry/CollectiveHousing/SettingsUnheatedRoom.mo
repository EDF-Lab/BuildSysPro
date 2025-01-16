within BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing;
record SettingsUnheatedRoom
  constant Modelica.Units.SI.Volume VolumeLNC=27.5*2.5;
  constant Modelica.Units.SI.Area Surf_ParoiSousCombles=27.5;
  constant Modelica.Units.SI.Area Surf_PlancherInt=27.5;
  constant Modelica.Units.SI.Area Surf_PlancherBas=27.5;
  constant Modelica.Units.SI.Area Surf_MurEst=1.05*2.5;
  constant Modelica.Units.SI.Area Surf_MurSud=5.1*2.5;
  constant Modelica.Units.SI.Area SommeDesSurfacesExterieures=
      Surf_ParoiSousCombles + Surf_PlancherBas + Surf_MurEst + Surf_MurSud;
  annotation (Documentation(info="<html>
<p><i><b>Record of geometric data for unheated rooms of collective housing.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Note H-E10-1996-02908-FR and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end SettingsUnheatedRoom;
