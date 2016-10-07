within BuildSysPro.Systems.Distribution;
model ThermostaticValve "Thermostatic Radiator Valve"

Modelica.SIunits.MassFlowRate debit_rad "Effective flow rate of the radiator";
Modelica.SIunits.Temperature T_sensorZ1( start=292.15);
Real TO "Opening rate of the thermostatic valve";
Modelica.SIunits.Time S_T_C=1250 "Sensor time constant";

  Modelica.Blocks.Interfaces.RealInput HOT_IN[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput RAD_COLD[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,90}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={26,90})));
  Modelica.Blocks.Interfaces.RealInput COLD_IN[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{100,-68},{80,-48}}),
        iconTransformation(extent={{100,-68},{80,-48}})));
  Modelica.Blocks.Interfaces.RealOutput HOT_OUT[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{82,-10},{102,10}})));
  Modelica.Blocks.Interfaces.RealOutput COLD_OUT[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,-56})));
  Modelica.Blocks.Interfaces.RealOutput RAD_HOT[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-34,90})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b T_room
    "Room temperature"
    annotation (Placement(transformation(extent={{70,70},{108,108}})));
  Modelica.Blocks.Interfaces.RealInput T_sp
    "Room setpoint temperature" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-22,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-100})));
  Modelica.Blocks.Interfaces.RealInput D_max "Maximum flow rate of the radiator"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={22,-100})));
// Connections 1:Temp / 2:m_flow
  Modelica.Blocks.Continuous.FirstOrder T_sp_filtered(y_start=292.15, T=
       5)
    annotation (Placement(transformation(extent={{-16,-70},{4,-50}})));
equation
S_T_C*der(T_sensorZ1)=(T_room.T-T_sensorZ1);
TO = 1-1/(1+exp(-(T_sensorZ1-T_sp_filtered.y)));

debit_rad  = max(TO*D_max,0.00001);

RAD_HOT[2]  = min(debit_rad,HOT_IN[2]);
HOT_OUT[2]  = max(HOT_IN[2]-RAD_HOT[2],0.00001);
COLD_OUT[2] = min(HOT_IN[2],RAD_COLD[2]+COLD_IN[2]);

RAD_HOT[1]              = HOT_IN[1];
HOT_IN[2]*HOT_IN[1]     = RAD_HOT[2]*RAD_HOT[1]+HOT_OUT[2]*HOT_OUT[1];
COLD_OUT[2]*COLD_OUT[1] = RAD_COLD[2]*RAD_COLD[1]+COLD_IN[2]*COLD_IN[1];

T_room.Q_flow = 0;

  connect(T_sp, T_sp_filtered.u) annotation (Line(points={{-22,-100},{-22,-100},
          {-22,-60},{-18,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics={
        Rectangle(
          extent={{-80,6},{84,-6}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-43,4},{43,-4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-34,37},
          rotation=90),
        Rectangle(
          extent={{-80,-50},{84,-62}},
          lineColor={85,85,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-65,4},{65,-4}},
          lineColor={85,85,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          origin={26,15},
          rotation=90),
        Rectangle(extent={{30,76},{80,6}}, lineColor={0,0,255})}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This component has two purposes:</p>
<ul>
<li>Actuate as a thermostatic radiator valve in order to <b>control the water mass flow rate entering the radiator</b>. The mass flow rate depends on the indoor air temperature (T_room port) and the indoor setpoint air temperature (T_sp real input).</li>
<li><b>Distribute the mass flow rate into the radiator</b> (RAD_HOT and RAD_COLD ports) and the <b>distribution pipe</b> which continuos the circuit to other radiators (HOT_IN, HOT_OUT, COLD_IN and COLD_OUT ports).</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alberto Tejeda 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Alberto TEJEDA, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ThermostaticValve;
