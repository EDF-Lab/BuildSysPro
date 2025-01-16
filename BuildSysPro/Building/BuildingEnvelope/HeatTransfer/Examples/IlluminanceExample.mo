within BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Examples;
model IlluminanceExample
  "Example of glazings assembly to compute natural lighting"
extends Modelica.Icons.Example;
  Window vitrageSud(useEclairement=true)
    annotation (Placement(transformation(extent={{6,-34},{26,-14}})));
  Window vitrageNord(useEclairement=true, useVolet=false)
    annotation (Placement(transformation(extent={{6,14},{26,34}})));
  BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  BoundaryConditions.Solar.SolarMasks.FLUXsurfMask MasqueSud(
    TypeMasque=2,
    MasqueLointain=true,
    useEclairement=true)
    annotation (Placement(transformation(extent={{-38,-36},{-10,-8}})));
  BoundaryConditions.Solar.Irradiation.NaturalIlluminance eclairementNaturel(
      Aecl_nat=50)
    annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  BoundaryConditions.Scenarios.ScenarioRT scenarioRT
    annotation (Placement(transformation(extent={{6,62},{36,94}})));
  Modelica.Blocks.Sources.RealExpression Null[3](y={0,0,0})
    annotation (Placement(transformation(extent={{8,-70},{28,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-36})));
equation

  connect(fLUXzone.FluxIncExtNorth, vitrageNord.FluxIncExt) annotation (Line(
      points={{-49,4.2},{-24,4.2},{-24,29},{13,29}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.IlluNorth, vitrageNord.Ecl) annotation (Line(
      points={{-66,11},{-66,34},{7,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.G, fLUXzone.G) annotation (Line(
      points={{-81,48},{-76,48},{-76,0.5},{-70.3,0.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.G, MasqueSud.G) annotation (Line(
      points={{-81,48},{-76,48},{-76,-19.2},{-36.6,-19.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXzone.IlluSouth, MasqueSud.Ecl) annotation (Line(
      points={{-63,11},{-63,18},{-42,18},{-42,-25.64},{-36.6,-25.64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MasqueSud.FluxMasques, vitrageSud.FluxIncExt) annotation (Line(
      points={{-8.32,-22},{-4,-22},{-4,-19},{13,-19}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(MasqueSud.EclMasques, vitrageSud.Ecl) annotation (Line(
      points={{-17,-25.64},{0,-25.64},{0,-14},{7,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT.Presence, eclairementNaturel.Occupation) annotation (Line(
      points={{35,62},{59,62},{59,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT.ComEclairage, eclairementNaturel.ConsigneEclairage)
    annotation (Line(
      points={{35,66},{65.2,66},{65.2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vitrageNord.Flum, eclairementNaturel.FlumNord) annotation (Line(
      points={{25,34},{36,34},{36,3.4},{53,3.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vitrageSud.Flum, eclairementNaturel.FlumSud) annotation (Line(
      points={{25,-14},{36,-14},{36,-0.2},{53,-0.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Null.y, eclairementNaturel.FlumPlafond) annotation (Line(
      points={{29,-60},{40,-60},{40,7},{53,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Null.y, eclairementNaturel.FlumEst) annotation (Line(
      points={{29,-60},{40,-60},{40,-3.8},{53,-3.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Null.y, eclairementNaturel.FlumOuest) annotation (Line(
      points={{29,-60},{40,-60},{40,-7.2},{53,-7.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port, vitrageSud.T_int) annotation (Line(
      points={{58,-36},{30,-36},{30,-27},{25,-27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, vitrageNord.T_int) annotation (Line(
      points={{58,-36},{30,-36},{30,21},{25,21}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile.T_dry, vitrageNord.T_ext) annotation (Line(
      points={{-81,53},{2,53},{2,21},{7,21}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile.T_dry, vitrageSud.T_ext) annotation (Line(
      points={{-81,53},{2,53},{2,-27},{7,-27}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    experiment(StopTime=3.1536e+007),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
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
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
end IlluminanceExample;
