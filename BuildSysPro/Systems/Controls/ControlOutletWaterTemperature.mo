within BuildSysPro.Systems.Controls;
model ControlOutletWaterTemperature

parameter Boolean RegTOR = true "On/Off control ?";
  parameter Real table[:,2]=[-20, 60; -7, 52; 0, 43; 7, 37; 20, 20]
    "Table of water design curve : exterior temperature (°C) in 1st row and setpoint of system output temperature (°C) in 2nd row";

  parameter Modelica.Units.SI.TemperatureDifference THyst=1
    "Upper and lower tolerance compared with the setpoint"
    annotation (dialog(enable=RegTOR));
public
  WaterDesignTemperature        LoiDEau(
    table=table,
    THyst=THyst,
    RegTOR=RegTOR) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={14,18})));
  Modelica.Blocks.Math.Gain PLR(k=100) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={0,-22})));
protected
  Modelica.Blocks.Logical.GreaterEqualThreshold ConditionChargeG(threshold=
        0.005) annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=90,
        origin={-26,-24})));
public
  Modelica.Blocks.Continuous.Integrator TpsFonctionnementG
    annotation (Placement(transformation(extent={{-14,-22},{-10,-18}})));
  Modelica.Blocks.Math.BooleanToReal GenBooleanToRealG
    annotation (Placement(transformation(extent={{-22,-22},{-18,-18}})));
  Modelica.Blocks.MathInteger.TriggeredAdd CountG
    annotation (Placement(transformation(extent={{-16,-12},{-10,-6}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpressionG(y=1)
    annotation (Placement(transformation(extent={{-32,-12},{-28,-6}})));
public
  Modelica.Blocks.Continuous.LimPID                PID_d(
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    k=1,
    Ti=600,
    yMin=0.1)
          annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={0,-8})));
public
 Modelica.Blocks.Interfaces.RealInput T2 "External temperature" annotation (
      Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={99,19}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={89,9})));
  Modelica.Blocks.Interfaces.RealOutput Y2 "Ratio modifier of PLR"
                                                 annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={0,-98}), iconTransformation(
        extent={{-11.5,-11.5},{11.5,11.5}},
        rotation=270,
        origin={0.5,-88.5})));
  Modelica.Blocks.Interfaces.RealInput TM[2]
    "Secondary circuit / 1- fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{106,-24},{92,-10}}),
        iconTransformation(extent={{100,-62},{78,-40}})));
equation
  connect(GenBooleanToRealG.y,TpsFonctionnementG. u) annotation (Line(
      points={{-17.8,-20},{-14.4,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integerExpressionG.y,CountG. u) annotation (Line(
      points={{-27.8,-9},{-17.2,-9}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(ConditionChargeG.y,CountG. trigger) annotation (Line(
      points={{-26,-21.8},{-26,-14},{-14.8,-14},{-14.8,-12.6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(ConditionChargeG.y,GenBooleanToRealG. u) annotation (Line(
      points={{-26,-21.8},{-26,-20},{-22.4,-20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(ConditionChargeG.u,PLR. y) annotation (Line(
      points={{-26,-26.4},{-26,-28},{0,-28},{0,-26.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(LoiDEau.T_sp, PID_d.u_s) annotation (Line(
      points={{3.4,18},{0,18},{0,-3.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_d.y,PLR. u) annotation (Line(
      points={{0,-12.4},{0,-17.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2, LoiDEau.T_ext) annotation (Line(points={{99,19},{61.5,19},{61.5,
          18},{23,18}}, color={0,0,127}));
  connect(PLR.y, Y2)
    annotation (Line(points={{0,-26.4},{0,-98}}, color={0,0,127}));
  connect(TM, LoiDEau.RetourDEau) annotation (Line(points={{99,-17},{34,-17},{
          34,15},{23,15}}, color={0,0,127}));
  connect(TM[1], PID_d.u_m) annotation (Line(points={{99,-20.5},{51.5,-20.5},{
          51.5,-8},{4.8,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{78,34},{-78,-76}},
          lineColor={135,135,135},
          lineThickness=1,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid), Text(
          extent={{-60,24},{52,-70}},
          lineColor={135,135,135},
          lineThickness=1,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Outlet water temperature control")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    conversion(noneFromVersion=""),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Generic model of water outlet temperature of a heating system based on a PID model and a water design table. The main output is the part load ratio that should be connected to the system (10&#37; - 100&#37;).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 01/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ControlOutletWaterTemperature;
