within BuildSysPro.Systems.Controls;
model PIDFixedDualMode "Heating and cooling setpoints"
parameter Modelica.SIunits.Power PuissanceNom=1000
    "Nominal power of the system";
parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tc=20
    "Heating setpoint temperature";
parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tf=27
    "Cooling setpoint temperature";
parameter Real k(min=0) = 1000 "Gain of controller";
parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small, start=0.5)=0.01
    "Time constant of Integrator block";
parameter Modelica.SIunits.Time Td(min=0, start= 0.1)=0
    "Time constant of Derivative block";

  Modelica.Blocks.Continuous.LimPID PID(
    Ni=0.1,
    yMin=0.,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    yMax=PuissanceNom,
    k=k,
    Ti=Ti,
    Td=Td) if Test
    annotation (Placement(transformation(extent={{40,0},{20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedChauffage if Test
    annotation (Placement(transformation(extent={{-20,-18},{-40,2}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor Flux
    annotation (Placement(transformation(extent={{-64,-20},{-84,0}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor MesureTint
    annotation (Placement(transformation(extent={{90,16},{70,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_room annotation (
     Placement(transformation(extent={{80,60},{100,80}}), iconTransformation(
          extent={{80,60},{100,80}})));
  Modelica.Blocks.Interfaces.RealOutput Besoin
    "Flux of heating and cooling system" annotation (Placement(
        transformation(extent={{78,-93},{100,-71}}), iconTransformation(extent={
            {80,-80},{100,-60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedClimatisation if Test
    annotation (Placement(transformation(extent={{-20,-48},{-40,-28}})));
  Modelica.Blocks.Continuous.LimPID PID1(
    Ni=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    yMax=0,
    yMin=-PuissanceNom,
    k=k,
    Ti=Ti,
    Td=Td) if Test
    annotation (Placement(transformation(extent={{40,-42},{20,-62}})));
  Modelica.Blocks.Sources.Constant const(k=Tc)
    annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Modelica.Blocks.Sources.Constant const1(k=Tf)
    annotation (Placement(transformation(extent={{100,-60},{80,-40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature prescribedT(T=Tc +
        273.15) if not Test
    annotation (Placement(transformation(extent={{-22,14},{-38,30}})));

protected
  parameter Boolean Test= (Tc <> Tf);
equation
  connect(MesureTint.port, T_room) annotation (Line(
      points={{90,26},{98,26},{98,70},{90,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID.u_m, MesureTint.T) annotation (Line(
      points={{30,2},{30,26},{70,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedChauffage.Q_flow, PID.y)
                                            annotation (Line(
      points={{-20,-8},{7.5,-8},{7.5,-10},{19,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedClimatisation.Q_flow, PID1.y)
                                              annotation (Line(
      points={{-20,-38},{10,-38},{10,-52},{19,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID1.u_m, MesureTint.T) annotation (Line(
      points={{30,-40},{30,-30},{56,-30},{56,26},{70,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, PID.u_s) annotation (Line(
      points={{79,-10},{42,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, PID1.u_s) annotation (Line(
      points={{79,-50},{60,-50},{60,-52},{42,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedChauffage.port, Flux.port_a) annotation (Line(points={{-40,-8},
          {-52.5,-8},{-52.5,-10},{-64,-10}},         color={191,0,0}));
  connect(prescribedClimatisation.port, Flux.port_a) annotation (Line(points={{-40,-38},
          {-40,-40},{-64,-40},{-64,-10}},            color={191,0,0}));
  connect(prescribedT.port, Flux.port_a)
    annotation (Line(points={{-38,22},{-64,22},{-64,-10}}, color={191,0,0}));
  connect(Flux.port_b, T_room) annotation (Line(points={{-84,-10},{-92,-10},{-92,
          70},{90,70}}, color={191,0,0}));
  connect(Besoin, Flux.Q_flow) annotation (Line(points={{89,-82},{12,-82},{-74,
          -82},{-74,-20},{-74,-20}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),           Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{12,0},{90,0}},  color={0,0,255}),
        Line(points={{-90,0},{-12,0}},  color={191,0,0}),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,80},
              {12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,40},{12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Text(
          extent={{-110,134},{112,96}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Simple model of heating and air conditioning with constant temperature setpoints.</p>
<p>The output <b>Besoin</b> is positive when heating is needed, and negative when cooling is needed.<p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Of course, this model should not be used if Tc &lt; Tf.</p>
<p>Safeguards should be added to prevent bug.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (BESTEST) - Aurélie Kaemmerlen 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Yu Lu 08/2011 : Modification du nom du connecteur FluxCR en Besoin pour rendre sa signification plus triviale</p>
<p>Aurélie Kaemmerlen 10/2011 : Ajout du cas particulier où Tc=Tf</p>
</html>"));
end PIDFixedDualMode;
