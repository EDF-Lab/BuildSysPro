within BuildSysPro.Systems.Controls;
model ControlTemperature

protected
   Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-26,-4},{-20,2}})));
  Modelica.Blocks.Math.MultiProduct Season(nu=2) annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={0,4})));
  BuildSysPro.Utilities.Math.RealExpression
                                          ModifPLR_int(y=ModifPLR_int.u)
    annotation (Placement(transformation(
        extent={{2,-2},{-2,2}},
        rotation=270,
        origin={0,14})));
  Modelica.Blocks.Logical.GreaterEqualThreshold ConditionChargeE(threshold=
        0.005) annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=0,
        origin={6,10})));
  Modelica.Blocks.Math.BooleanToReal GenBooleanToRealE
    annotation (Placement(transformation(extent={{12,-4},{16,0}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpressionE(y=1)
    annotation (Placement(transformation(extent={{10,6},{14,12}})));
public
  Modelica.Blocks.Continuous.Integrator TpsFonctionnementE
    annotation (Placement(transformation(extent={{20,-4},{24,0}})));
  Modelica.Blocks.MathInteger.TriggeredAdd CountE
    annotation (Placement(transformation(extent={{18,6},{24,12}})));
public
  Modelica.Blocks.Continuous.LimPID                PID_int(
    yMin=0.1,
    Ti=600,
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1)
          annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={0,-10})));
  Modelica.Blocks.Interfaces.BooleanInput U1 "Seasonal OnOff" annotation (
      Placement(transformation(extent={{-44,-6},{-34,4}}, rotation=0),
        iconTransformation(extent={{-100,-13},{-76,12}})));
  Modelica.Blocks.Interfaces.RealOutput Y1 "Ratio modifier of PLR" annotation (
      Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={0,38}), iconTransformation(
        extent={{-11.5,-11.5},{11.5,11.5}},
        rotation=90,
        origin={0.5,87.5})));
public
 Modelica.Blocks.Interfaces.RealInput T1 "Air temperature" annotation (
      Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={39,-9}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={89,-3})));
public
 Modelica.Blocks.Interfaces.RealInput T2 "Air temperature setpoint" annotation (
     Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={1,-29}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={0,-88})));
equation
  connect(booleanToReal.y,Season. u[1]) annotation (Line(
      points={{-19.7,-1},{-2,-1},{-2,0},{-1.4,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ModifPLR_int.u,Season. y) annotation (Line(
      points={{0,11.6},{0,8.68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GenBooleanToRealE.y,TpsFonctionnementE. u) annotation (Line(
      points={{16.2,-2},{19.6,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integerExpressionE.y,CountE. u) annotation (Line(
      points={{14.2,9},{16.8,9}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(Season.y,ConditionChargeE. u) annotation (Line(
      points={{0,8.68},{0,10},{3.6,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ConditionChargeE.y,CountE. trigger) annotation (Line(
      points={{8.2,10},{8,10},{8,4},{19.2,4},{19.2,5.4}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(ConditionChargeE.y,GenBooleanToRealE. u) annotation (Line(
      points={{8.2,10},{8,10},{8,-2},{11.6,-2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(PID_int.y,Season. u[2]) annotation (Line(
      points={{0,-5.6},{0,0},{1.4,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanToReal.u, U1) annotation (Line(points={{-26.6,-1},{-31.3,-1},{
          -31.3,-1},{-39,-1}}, color={255,0,255}));
  connect(ModifPLR_int.y, Y1)
    annotation (Line(points={{0,16.2},{0,38}},        color={0,0,127}));
  connect(PID_int.u_m, T1)
    annotation (Line(points={{4.8,-10},{39,-10},{39,-9}}, color={0,0,127}));
  connect(PID_int.u_s, T2)
    annotation (Line(points={{0,-14.8},{1,-14.8},{1,-29}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-76,-76},{78,76}},
          lineColor={135,135,135},
          lineThickness=1,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid), Text(
          extent={{-52,46},{60,-48}},
          lineColor={135,135,135},
          lineThickness=1,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Temperature control")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Generic model of air temperature control based on a PID model.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 01/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI EDF (2013)<br>
--------------------------------------------------------------</b></p></html>"));
end ControlTemperature;
