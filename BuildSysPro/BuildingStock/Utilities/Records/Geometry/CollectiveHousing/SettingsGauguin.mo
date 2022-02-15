within BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing;
record SettingsGauguin
  constant Modelica.Units.SI.Volume VolumeGauguin=238.48;
  constant Modelica.Units.SI.Area Surf_Refends=15.75;
  constant Modelica.Units.SI.Area Surf_Cloison=49.88;
  constant Modelica.Units.SI.Area Surf_PorteEntree=1.60;
  constant Modelica.Units.SI.Area Surf_PorteSeparations=15.00;
  constant Modelica.Units.SI.Area Surf_ParoiSousCombles=95.39;
  constant Modelica.Units.SI.Area Surf_PlancherBas=95.39;
  constant Modelica.Units.SI.Area Surf_MurEstMit=12.28;
  constant Modelica.Units.SI.Area Surf_MurEstCage=6.89;
  constant Modelica.Units.SI.Area Surf_MurEstPal=1.46;
  constant Modelica.Units.SI.Area Surf_MurSud=17.01;
  constant Modelica.Units.SI.Area Surf_MurOuest=25.25;
  constant Modelica.Units.SI.Area Surf_MurNord=16.83;
  constant Modelica.Units.SI.Area Surf_VitrageSud=7.05;
  constant Modelica.Units.SI.Area Surf_VitrageNord=7.05;
  constant Modelica.Units.SI.Area Surf_PlancherInt=95.39;
  constant Modelica.Units.SI.Area SommeDesSurfacesExterieures=Surf_PorteEntree
       + Surf_ParoiSousCombles + Surf_PlancherBas + Surf_MurEstMit +
      Surf_MurEstCage + Surf_MurEstPal + Surf_MurSud + Surf_MurOuest +
      Surf_MurNord + Surf_VitrageSud + Surf_VitrageNord;
  annotation (Documentation(info="<html>
<p><i><b>Record of geometric data for Gauguin collective housing.</b></i></p>
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
end SettingsGauguin;
