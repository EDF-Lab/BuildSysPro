within BuildSysPro.Systems.Solar.Examples;
partial model T_SolarWall_Building
extends Modelica.Icons.Example;
  Thermal.SolarWall.ParallelTubesActiveSolarWall tubesParallelePAS(
    Stot=9,
    Tstart=293,
    n=10,
    e_isol_f=0.1)
    annotation (Placement(transformation(extent={{-12,0},{8,20}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=true)
                                                          annotation (
     Placement(transformation(extent={{-74,-10},{-62,2}})));

  BuildSysPro.Building.Zones.HeatTransfer.ZoneSlabGlazed
    zoneTerrePleinAvecVitre
    annotation (Placement(transformation(extent={{2,22},{32,42}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-96,56},{-76,76}})));
Modelica.Blocks.Math.Gain Gain(k=1)            annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-32,28})));
  BoundaryConditions.Solar.Irradiation.FLUXsurfLWRinc fLUXsurfGLOH
    annotation (Placement(transformation(extent={{-66,18},{-46,38}})));
equation
  connect(booleanConstant.y, tubesParallelePAS.ON) annotation (Line(
      points={{-61.4,-4},{-18,-4},{-18,5.9},{-10.7,5.9}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(zoneTerrePleinAvecVitre.T_int, tubesParallelePAS.Tb) annotation (Line(
      points={{25,28.8},{72,28.8},{72,11},{7,11}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile.T_dry, zoneTerrePleinAvecVitre.T_ext) annotation (Line(
      points={{-77,69},{-8,69},{-8,41},{9,41}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.T_dry, tubesParallelePAS.Tf) annotation (Line(
      points={{-77,69},{-58,69},{-58,11},{-11,11}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, zoneTerrePleinAvecVitre.G) annotation (Line(
      points={{-77,64},{-16,64},{-16,37},{9,37}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(fLUXsurfGLOH.FluxIncExt, Gain.u) annotation (Line(
      points={{-45,27.9},{-42.5,27.9},{-42.5,28},{-39.2,28}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(meteofile.G, fLUXsurfGLOH.G) annotation (Line(
      points={{-77,64},{-72,64},{-72,28},{-67,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Gain.y, tubesParallelePAS.G) annotation (Line(
      points={{-25.4,28},{-24,28},{-24,16.3},{-11.5,16.3}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics), Documentation(
        info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Emmanuel AMY DE LA BRETEQUE, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Aurélie Kaemmerlen 03/2011 : remplacement du modèle EclairementTouteSurface par FLUXsurfGLOH + Gain</p>
<p>Aurélie Kaemmerlen 09/2013 : Modèle mis en partiel pour ne plus avoir l'erreur due au manque de valeurs de paramètres lors d'un check</p>
</html>"));
end T_SolarWall_Building;
