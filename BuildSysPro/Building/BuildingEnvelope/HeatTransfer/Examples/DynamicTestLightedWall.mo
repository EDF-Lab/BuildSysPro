within BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Examples;
model DynamicTestLightedWall
  "Computation of the heat flow passing through a wall"
extends Modelica.Icons.Example;
  Wall MurSud(
    S=30.75,
    hs_ext=25,
    hs_int=7.7,
    redeclare Utilities.Data.WallData.RecentExtWall caracParoi(m={5,5,5}))
    annotation (Placement(transformation(extent={{-10,12},{10,32}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T(
        displayUnit="degC") = 293.15)
    annotation (Placement(transformation(extent={{76,10},{56,30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.HeatFlowSensor mesureFlux
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile MeteoTrappes
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf(azimut=0,
      incl=90)
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
equation

  connect(mesureFlux.port_a, fixedTemperature1.port) annotation (Line(
      points={{40,20},{56,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurSud.T_int, mesureFlux.port_b) annotation (Line(
      points={{9,19},{13.5,19},{13.5,20},{20,20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MeteoTrappes.G, fLUXsurf.G) annotation (Line(
      points={{-61,8},{-36.5,8},{-36.5,50},{-31,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXsurf.FluxIncExt, MurSud.FluxIncExt) annotation (Line(
      points={{-9,49.9},{-7.5,49.9},{-7.5,31},{-3,31}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(MeteoTrappes.T_dry, MurSud.T_ext) annotation (Line(
      points={{-61,13},{-9,13},{-9,19}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<p>Aurélie Kaemmerlen 03/2011 : Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</p>
<p>Gilles Plessis 06/2012 : Changement du modèle de parois avec paramétrage par composition de parois types.</p>
<p>Gilles Plessis 03/2013 : Modification de la consigne de 20K à 20&deg;C et des paramètres de simulation : simulation sur 1 semaine avec pas de temps de 600s.</p>
</html>",
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
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"),
    experiment(StopTime=604800, Interval=600),
    __Dymola_experimentSetupOutput);
end DynamicTestLightedWall;
