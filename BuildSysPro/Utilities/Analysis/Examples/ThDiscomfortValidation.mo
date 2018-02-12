within BuildSysPro.Utilities.Analysis.Examples;
model ThDiscomfortValidation "Simple validation of thermal discomfort model"
extends Modelica.Icons.Example;
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Text(T=273.15)
    annotation (Placement(transformation(extent={{-76,-26},{-56,-6}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(
      G=2) annotation (Placement(transformation(extent={{-20,-26},{0,-6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tint
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={32,-16})));
  BuildSysPro.Utilities.Analysis.ThDiscomfort inconfortThavecPresence(
      UsePresence=true, SeuilInconfort=3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={42,-68})));
  Modelica.Blocks.Sources.Pulse pulse(
    startTime=0,
    period=7200,
    amplitude=25,
    offset=270.15 + 16)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,-14})));
  Modelica.Blocks.Sources.Step step(startTime=50000)
    annotation (Placement(transformation(extent={{-66,-56},{-46,-36}})));
  BuildSysPro.Utilities.Analysis.ThDiscomfort inconfortThsansPresence(
      SeuilInconfort=3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,58})));
  Modelica.Blocks.Sources.Constant Tclim(k=273.15 + 30)
    annotation (Placement(transformation(extent={{-86,66},{-66,86}})));
  Modelica.Blocks.Sources.Constant TChauffage(k=273.15 + 19)
    annotation (Placement(transformation(extent={{-86,36},{-66,56}})));
equation
  connect(Text.port, thermalConductor.port_a)             annotation (Line(
      points={{-56,-16},{-20,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tint.port, thermalConductor.port_b)                  annotation (
      Line(
      points={{22,-16},{0,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, Tint.T) annotation (Line(
      points={{63,-14},{53.5,-14},{53.5,-16},{44,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, inconfortThavecPresence.Presence)
                                 annotation (Line(
      points={{-45,-46},{42,-46},{42,-59.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tclim.y, inconfortThsansPresence.TconsigneRef) annotation (Line(
      points={{-65,76},{-6,76},{-6,64.6},{37.4,64.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tclim.y, inconfortThavecPresence.TconsigneRef) annotation (Line(
      points={{-65,76},{-6,76},{-6,-61.4},{33.4,-61.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TChauffage.y, inconfortThsansPresence.TconsigneChauf) annotation (
      Line(
      points={{-65,46},{10,46},{10,51.4},{37.4,51.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TChauffage.y, inconfortThavecPresence.TconsigneChauf) annotation (
      Line(
      points={{-65,46},{10,46},{10,-74.6},{33.4,-74.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tint.port, inconfortThavecPresence.Tint) annotation (Line(
      points={{22,-16},{16,-16},{16,-68},{33,-68}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tint.port, inconfortThsansPresence.Tint) annotation (Line(
      points={{22,-16},{16,-16},{16,58},{37,58}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    experiment(StopTime=21600, Interval=600),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><i><b>Assembly for validation and understanding of the thermal discomfort model</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The setpoint temperature is considered fixed at 0 &deg; C.</p>
<p>The indoor temperature varies following a +/- 10&deg;C slot around the setpoint temperature</p>
<p>The discomfort threshold is set at 9&deg;C.</p>
<p>The 2 discomfort models are identically configured but <i>inconfortTh1</i> does not take into account the presence.</p>
<p></p><p><u><b>Bibliography</b></u></p>
<p>None</p>
<p><u><b>Instructions for use</b></u></p>
<p>None</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Simulate and plot the two outputs of the two discomfort models  as well as indoor temperature and setpoint.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ThDiscomfortValidation;
