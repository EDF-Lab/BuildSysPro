within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.PGVH;
model PGVH_controller

  Modelica.Blocks.Interfaces.RealInput Tconsigne "Temperature wanted"
                                                 annotation (Placement(
        transformation(extent={{-114,-10},{-74,30}}),iconTransformation(extent={{-106,-2},
            {-74,30}})));
  Modelica.Blocks.Interfaces.RealOutput fraction_of_max_power
    "fraction of maximum power that the stove has to power out"
    annotation (Placement(transformation(extent={{72,-12},{104,20}})));

  parameter Modelica.Units.SI.Power Pcombmin=2220;
  parameter Modelica.Units.SI.Power Pcomb2=3330;
  parameter Modelica.Units.SI.Power Pcomb3=4550;
  parameter Modelica.Units.SI.Power Pcomb4=5680;
  parameter Modelica.Units.SI.Power Pcombmax=7650;
  Modelica.Units.SI.Power Power_forced=Pcombmax
    "Power wanted in fixed power mode";

//------------------------------------------------------------------------------------
  Modelica.Blocks.Interfaces.BooleanInput presence
    "Indicates if the user is present in the house"
    annotation (Placement(transformation(extent={{-114,58},{-74,98}}),
        iconTransformation(extent={{-106,64},{-76,94}})));
  Modelica.Blocks.Interfaces.BooleanInput marche_forcee
    "Indicates if \"fixed power\" mode is activated"    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-6,94}), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={-7,93})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tsens
    "Heat port connected to the room"
    annotation (Placement(transformation(extent={{-100,-72},{-74,-46}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-62,0},{-42,20}})));
equation

Tsens.Q_flow=0;

if marche_forcee then
  fraction_of_max_power=Power_forced/Pcombmax;
else
  if presence then
    if Tsens.T<=prescribedTemperature.port.T+1.5 and Tsens.T>=prescribedTemperature.port.T-1 then
      fraction_of_max_power=Pcombmin/Pcombmax;
    elseif Tsens.T<prescribedTemperature.port.T-1 and Tsens.T>=prescribedTemperature.port.T-1.5 then
      fraction_of_max_power=Pcomb2/Pcombmax;
    elseif Tsens.T<prescribedTemperature.port.T-1.5 and Tsens.T>=prescribedTemperature.port.T-2 then
      fraction_of_max_power=Pcomb3/Pcombmax;
    elseif Tsens.T<prescribedTemperature.port.T-2 and Tsens.T>=prescribedTemperature.port.T-2.5 then
      fraction_of_max_power=Pcomb4/Pcombmax;
    elseif Tsens.T<prescribedTemperature.port.T-2.5 then
      fraction_of_max_power=1;
    else
      fraction_of_max_power=0;
    end if;
  else
    fraction_of_max_power=0;
  end if;
end if;

  connect(Tconsigne, prescribedTemperature.T) annotation (Line(
      points={{-94,10},{-64,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={Rectangle(
          extent={{-70,74},{68,-70}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-48,54},{50,6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>PGVH PELLET'S STOVE REGULATOR</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The purpose of this model is to be part of the PGVH model</p>
<p>The control is done according to the difference between the actual romm temperature and the temperature wanted.</p>
<p>The only output is the fraction of maximum power delivered</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EIFER 08/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EIFER, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end PGVH_controller;
