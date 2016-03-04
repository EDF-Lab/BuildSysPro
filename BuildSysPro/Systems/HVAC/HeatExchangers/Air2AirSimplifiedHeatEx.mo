within BuildSysPro.Systems.HVAC.HeatExchangers;
model Air2AirSimplifiedHeatEx

extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

// Control parameters
parameter Boolean use_Qv_in=false "Volume flow controlled"
annotation(Evaluate=true,HideResult=true,Dialog(group="Control"),
choices(choice=true "yes", choice=false "no (constant)", radioButtons=true));
parameter Boolean use_Efficacite_in=false "Efficiency controlled"
annotation(Evaluate=true,HideResult=true,Dialog(group="Control"),
choices(choice=true "yes", choice=false "no (constant)", radioButtons=true));
parameter Real Qv=0 "Constant ventilation rate [m3/h]"
    annotation(Dialog(group="Control",enable=not use_Qv_in));
parameter Real Efficacite=0.5 "Constant exchanger efficiency [0-1]"
    annotation(Dialog(group="Control",enable=not use_Efficacite_in));

// Air properties
parameter Modelica.SIunits.Density rho=1.24 "Air density" annotation(Dialog(group="Air properties"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp=1005
    "Specific heat capacity of air"                                                    annotation(Dialog(group="Air properties"));

// Public connectors
  Modelica.Blocks.Interfaces.RealInput Qv_in if use_Qv_in
    "Scenario of controlled ventilation rate [m3/h]"
                                     annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={52,80}),                          iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={48,28})));
Modelica.Blocks.Interfaces.RealInput Efficacite_in if use_Efficacite_in
    "Scenario of double flow efficiency [0-1]"
                                     annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-30,80}),                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-54,28})));

Modelica.SIunits.Temperature Tentree "Inlet temperature of the exchanger";

// Internal connectors
protected
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Internal connector required in the case of conditional connection";
Modelica.Blocks.Interfaces.RealInput Efficacite_in_internal
    "Internal connector required in the case of conditional connection";

equation
  connect(Qv_in, Qv_in_internal);
  if not use_Qv_in then
    Qv_in_internal= Qv;
  end if;

  connect(Efficacite_in, Efficacite_in_internal);
  if not use_Efficacite_in then
    Efficacite_in_internal= Efficacite;
  end if;

 Tentree = Efficacite_in_internal* port_b.T  + (1-Efficacite_in_internal)* port_a.T;
 Q_flow = rho * Cp * (Qv_in_internal/3600) *(Tentree-port_b.T);

  annotation (
Documentation(info="<html>
<p><b>Simplified model of an exchanger in pure thermal modelling considering exchanger efficiency and a ventilation rate</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The value of the volume flow can be controlled or fixed throughout the simulation as well as the exchanger efficiency.</p>
<p>Note: modification of a former exchanger model whose rate was given in vol/h instead of m3/h like in this model.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The port_a is to be connected to the outdoor temperature and the port_b to inside.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Lou Chesne 10/2011, Aurélie Kaemmerlen 10/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Lou CHESNE, Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),      graphics={
        Line(
          points={{-78,8},{74,8},{64,14}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,8},{74,8},{64,2}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-6},{74,-6},{64,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-6},{74,-6},{64,-12}},
          color={0,128,255},
          smooth=Smooth.None)}),
    DymolaStoredErrors,
    Diagram(graphics));
end Air2AirSimplifiedHeatEx;
