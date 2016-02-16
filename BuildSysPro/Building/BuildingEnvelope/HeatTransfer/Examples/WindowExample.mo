within BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Examples;
model WindowExample
extends Modelica.Icons.Example;
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window vitrage1(
      useOuverture=true)
    annotation (Placement(transformation(extent={{-6,46},{14,66}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-82,44},{-62,64}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf(azimut=0,
      incl=90) annotation (Placement(transformation(extent={{-50,8},{-30,28}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=86400)
    annotation (Placement(transformation(extent={{-82,70},{-62,90}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,54})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window vitrage2(
      useOuverture=true, useVolet=true)
    annotation (Placement(transformation(extent={{-4,-8},{16,12}})));
  Modelica.Blocks.Sources.RealExpression fermeture_volet(y=abs(sin(time/10000)))
    annotation (Placement(transformation(extent={{-80,-36},{-60,-16}})));
  BoundaryConditions.Weather.ZoneWind vENTzone
    annotation (Placement(transformation(extent={{-46,36},{-26,56}})));
equation
  connect(fLUXsurf.G, meteofile.G) annotation (Line(
      points={{-51,18},{-54,18},{-54,52},{-63,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXsurf.FLUX, vitrage1.FLUX) annotation (Line(
      points={{-29,17.9},{-18,17.9},{-18,61},{1,61}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(booleanPulse.y, vitrage1.ouverture_fenetre) annotation (Line(
      points={{-61,80},{1,80},{1,56}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, vitrage1.T_int) annotation (Line(
      points={{58,54},{32,54},{32,53},{13,53}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, vitrage2.T_int) annotation (Line(
      points={{58,54},{38,54},{38,-1},{15,-1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile.Tseche, vitrage2.T_ext) annotation (Line(
      points={{-63,57},{-12,57},{-12,-1},{-3,-1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrage1.T_ext, meteofile.Tseche) annotation (Line(
      points={{-5,53},{-12,53},{-12,57},{-63,57}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXsurf.FLUX, vitrage2.FLUX) annotation (Line(
      points={{-29,17.9},{-18,17.9},{-18,7},{3,7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(booleanPulse.y, vitrage2.ouverture_fenetre) annotation (Line(
      points={{-61,80},{3,80},{3,2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(fermeture_volet.y, vitrage2.fermeture_volet) annotation (Line(
      points={{-59,-26},{-38,-26},{-38,9},{-3,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.V, vENTzone.V) annotation (Line(
      points={{-63,49},{-56.5,49},{-56.5,45.9},{-46.9,45.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTSud, vitrage1.V) annotation (Line(
      points={{-25,46.4},{-24,46.4},{-24,56},{-5,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTSud, vitrage2.V) annotation (Line(
      points={{-25,46.4},{-25,2},{-3,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    experiment(StopTime=3.1536e+007, Interval=1800),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end WindowExample;
