within BuildSysPro.Utilities.Analysis;
model DHWDiscomfort
  "Measure of cold discomfort of DHW temperature relative to the setpoint"
  import BuildSysPro;

parameter Real DisconfortThreshold= 1 "Comfort range";
parameter Boolean UseDHWdrawing=false
    "Consider DHW scenario (by default DHW discomfort will be evaluated at all times)"                        annotation(Evaluate=true,HideResult=true,choices(choice=true "yes", choice=false "no", radioButtons=true));
  // Public components
  Modelica.Blocks.Interfaces.RealInput TsetpointDHW
    "DHW setpoint temperature in Kelvin" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,50}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-86,66})));

  Modelica.Blocks.Interfaces.RealInput DHWdrawing if UseDHWdrawing
    "DHW use 1 / No DHW use 0"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,100}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={1.77636e-015,86})));
  Modelica.Blocks.Interfaces.RealOutput OutColdDiscomfort
    "Cold discomfort measurement in [C°.h]"
                                          annotation (Placement(transformation(
          extent={{90,10},{110,30}}), iconTransformation(extent={{100,6},{120,26}})));
  Modelica.Blocks.Interfaces.RealOutput OutNbHourColdDiscomfort
    "Number of cold discomfort hours [h]" annotation (Placement(transformation(
          extent={{90,-30},{110,-10}}),
                                      iconTransformation(extent={{100,-24},{120,
            -4}})));

// Internal components

protected
  Modelica.Blocks.Interfaces.RealInput DHWdrawing_internal
    "Internal connector required in the case of conditional connection"
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-50,70})));

  BuildSysPro.Utilities.Analysis.TimeIntegral IntegraleTempFroid(Dt=3600)
    "Hour degrees below the threshold of discomfort" annotation (Placement(
        transformation(
        extent={{-9,-8},{9,8}},
        rotation=0,
        origin={75,-6})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=IntegraleTempFroid.It)
    annotation (Placement(transformation(extent={{42,28},{80,52}})));

  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{28,14},{40,26}})));

  Modelica.Blocks.Sources.RealExpression realExpression3(y=max(0,
        TsetpointDHW - Twatertank - DisconfortThreshold))
    annotation (Placement(transformation(extent={{-40,24},{-2,48}})));

  BuildSysPro.Utilities.Analysis.TimeIntegral IntegraleTempFroid1(Dt=3600)
    "Hour degrees below the threshold of discomfort" annotation (Placement(
        transformation(
        extent={{-9,-8},{9,8}},
        rotation=0,
        origin={23,-26})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=IntegraleTempFroid1.It)
    annotation (Placement(transformation(extent={{42,-46},{80,-22}})));

  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-44,-38},{-24,-18}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-14,-38},{6,-18}})));
public
  Modelica.Blocks.Interfaces.RealInput Twatertank
    "Temperature of the water tank" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-10}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-86,-66})));
equation
  connect(DHWdrawing, DHWdrawing_internal);

  if not UseDHWdrawing then
    DHWdrawing_internal= 1;
  end if;
  connect(realExpression.y, OutColdDiscomfort) annotation (Line(
      points={{81.9,40},{86,40},{86,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.u2, DHWdrawing_internal) annotation (Line(
      points={{26.8,16.4},{26.8,-1.8},{-50,-1.8},{-50,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression3.y, product1.u1) annotation (Line(
      points={{-0.1,36},{12,36},{12,23.6},{26.8,23.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, IntegraleTempFroid.u) annotation (Line(
      points={{40.6,20},{52,20},{52,-6},{64.2,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression6.y, OutNbHourColdDiscomfort) annotation (Line(
      points={{81.9,-34},{88,-34},{88,-20},{100,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanToReal.y, IntegraleTempFroid1.u) annotation (Line(
      points={{7,-28},{10,-28},{10,-26},{12.2,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean.y, booleanToReal.u) annotation (Line(
      points={{-23,-28},{-16,-28}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(realToBoolean.u, realExpression3.y) annotation (Line(
      points={{-46,-28},{-56,-28},{-56,-10},{12,-10},{12,36},{-0.1,36}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,80},{76,20}},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{56,-34},{36,-34},{36,-40},{56,-40},{56,-34}},
          lineColor={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{42,-34},{42,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{44,-34},{44,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{46,-34},{46,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{48,-34},{48,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{50,-34},{50,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-40,-96},{0,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-18},{-8,-66}},
          lineColor={0,107,208},
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-18},{-32,82},{-30,88},{-26,90},{-20,92},{-14,90},{-10,88},
              {-8,82},{-8,-18},{-32,-18}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(points={{-60,-18},{-32,-18}}, color={0,0,0}),
        Line(points={{-60,22},{-32,22}}, color={0,0,0}),
        Line(points={{-60,62},{-32,62}}, color={0,0,0}),
        Line(
          points={{-8,-18},{-8,-62}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-32,-18},{-32,-62}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{16,-20},{76,-80}},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{32,-10},{38,-16}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,128,255}),
        Ellipse(
          extent={{54,-10},{60,-16}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,128,255}),
        Line(
          points={{38,-34},{38,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{40,-34},{40,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{54,-34},{54,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{52,-34},{52,-40}},
          color={0,128,255},
          smooth=Smooth.None),
        Text(
          extent={{-94,140},{96,114}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{26,2},{68,-50}},   lineColor={0,0,0}),
        Polygon(
          points={{42,62},{42,48},{34,42},{34,40},{54,40},{54,42},{46,48},{46,62},
              {42,62}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{32,34},{30,28},{34,28},{32,34}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{40,38},{38,32},{42,32},{40,38}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{48,40},{46,34},{50,34},{48,40}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{46,30},{44,24},{48,24},{46,30}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{38,28},{36,22},{40,22},{38,28}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{30,22},{28,16},{32,16},{30,22}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{56,34},{54,28},{58,28},{56,34}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{54,24},{52,18},{56,18},{54,24}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{44,20},{42,14},{46,14},{44,20}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{36,16},{34,10},{38,10},{36,16}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{53,14},{51,8},{55,8},{53,14}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{62,14},{60,8},{64,8},{62,14}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{44,10},{42,4},{46,4},{44,10}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{28,10},{26,4},{30,4},{28,10}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{36,4},{34,-2},{38,-2},{36,4}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{56,4},{54,-2},{58,-2},{56,4}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{46,0},{44,-6},{48,-6},{46,0}},
          lineColor={0,107,208},
          lineThickness=0.5,
          fillColor={0,107,208},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier)}),
    Documentation(info="<html>
<p><i><b>This model calculates the hourly integral characterising DHW cold discomfort</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model calculates the hourly integral of the difference between water tank temperature and thermally-acceptable condition range.</p>
<p>This range is defined by the parameter <i>DiscomfortThreshold</i> around the setpoint temperature.</p>
<p><u><b>Bibliography</b></u></p>
<p>Model adapted from <a href=\"modelica://BuildSysPro.Utilities.Analysis.ThDiscomfort\"><code>ThDiscomfort</code></a>.</p>
<p><u><b>Instructions for use</b></u></p>
<p>Connect the realinput <i>Twatertank</i> to the water tank temperature.</p>
<p>Connect the realInput <i>TsetpointDHW</i> to the DHW setpoint temperature.</p>
<p>Set discomfort threshold for the study. The more it is high, the more discomfort will be low because the comfort range will be larger.</p>
<p>Precise if DHW drawing is taken into account. The inclusion of DHW drawing allows to not overestimate the discomfort by preventing its calculation when there no DHW use.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The output <i>OutColdDiscomfort</i> is positive and in [&deg;C.h] unit. It is the difference in absolute value between the range of acceptable thermal comfort and water tank temperature which is integrated over time.</p>
<p>The output <i>OutNbHourColdDiscomfort</i> is positive and in [h] unit. It indicates the number of discomfort hours.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 07/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
</html>"));
end DHWDiscomfort;
