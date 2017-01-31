within BuildSysPro.BuildingStock.Examples;
model MozartGV "GV calculation of MozartMonozone"
  extends Modelica.Icons.Example;

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartMonozone mozartMonozone(redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.MozartBefore1974
      paraMaisonRT)
    annotation (Placement(transformation(extent={{-32,-32},{30,38}})));
  Modelica.Blocks.Sources.RealExpression G[10](y=fill(0, 10))
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=293.15)
    annotation (Placement(transformation(extent={{68,-24},{48,-4}})));
equation
  connect(G.y, mozartMonozone.G) annotation (Line(
      points={{-79,28},{-58,28},{-58,28.4545},{-38.2,28.4545}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port, mozartMonozone.Text) annotation (Line(
      points={{-80,0},{-60,0},{-60,3},{-35.1,3}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mozartMonozone.Tair, fixedTemperature1.port) annotation (Line(
      points={{13.57,-9.72727},{29.785,-9.72727},{29.785,-14},{48,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Example of GV calculation (heat losses of a building for a 1°C difference between inside and outside) for the <code>MozartMonozone</code> model (constant interior temperature, no internal gains, no solar gains).</p>
<p>The result can be read when the balance is reached, calculating the ratio between the power injected to the building heatport by the <code>FixedTemperature</code> model and the temperature gap between inside and outside.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MozartGV;
