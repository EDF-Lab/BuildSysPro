within BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing;
record SettingsPicasso
  constant Modelica.Units.SI.Volume VolumePicasso=71.60;
  constant Modelica.Units.SI.Area Surf_Cloison=28.05;
  constant Modelica.Units.SI.Area Surf_PorteEntree=1.60;
  constant Modelica.Units.SI.Area Surf_PorteSeparations=4.50;
  constant Modelica.Units.SI.Area Surf_ParoiSousCombles=28.64;
  constant Modelica.Units.SI.Area Surf_PlancherInt=28.64;
  constant Modelica.Units.SI.Area Surf_PlancherBas=28.64;
  constant Modelica.Units.SI.Area Surf_MurEst=12.50;
  constant Modelica.Units.SI.Area Surf_MurSud=9.69;
  constant Modelica.Units.SI.Area Surf_MurOuestExt=5;
  constant Modelica.Units.SI.Area Surf_MurOuestLNC=7.5;
  constant Modelica.Units.SI.Area Surf_MurNord=13.04;
  constant Modelica.Units.SI.Area Surf_VitrageSud=4.88;
  constant Modelica.Units.SI.Area SommeDesSurfacesExterieures=Surf_PorteEntree
       + Surf_ParoiSousCombles + Surf_PlancherBas + Surf_MurEst + Surf_MurSud
       + Surf_MurOuestExt + Surf_MurOuestLNC + Surf_MurNord + Surf_VitrageSud;
  annotation (Documentation(info="<html>
<p><i><b>Record of geometric data for Picasso collective housing.</b></i></p>
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
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end SettingsPicasso;
