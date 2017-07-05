within BuildSysPro.Utilities.Analysis;
model ThDiscomfort
  "Measure of warm and cold discomfort of indoor temperature relative to the setpoint"
  import BuildSysPro;

parameter Real SeuilInconfort= 1 "Comfort range";
parameter Boolean UsePresence=false
    "Consider occupancy (by default the building is considered always occupied)"                        annotation(Evaluate=true,HideResult=true,choices(choice=true "yes", choice=false "no", radioButtons=true));
  // Public components
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tint
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput TconsigneChauf
    "Heating setpoint temperature in Kelvin"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-80}),iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-86,-66})));
  Modelica.Blocks.Interfaces.RealInput TconsigneRef
    "Cooling setpoint temperature in Kelvin"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,80}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-86,66})));

  Modelica.Blocks.Interfaces.RealInput Presence if UsePresence
    "Presence 1 / Absence 0"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,100}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={1.77636e-015,86})));
  Modelica.Blocks.Interfaces.RealOutput OutInconfortFroid
    "Cold discomfort measurement in [C°.h]"
                                          annotation (Placement(transformation(
          extent={{90,-50},{110,-30}}),
                                      iconTransformation(extent={{100,-60},
            {120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput OutInconfordChaud
    "Warm  discomfort measurement in [°C.h]" annotation (Placement(transformation(
          extent={{90,30},{110,50}}),   iconTransformation(extent={{100,40},{120,
            60}})));
  Modelica.Blocks.Interfaces.RealOutput OutNbHeureInconfortFroid
    "Number of cold discomfort hours [h]" annotation (Placement(transformation(
          extent={{90,-90},{110,-70}}),
                                      iconTransformation(extent={{100,-90},{120,
            -70}})));
  Modelica.Blocks.Interfaces.RealOutput OutNbHeureInconfortChaud
    "Number of warm discomfort hours [h]" annotation (Placement(transformation(
          extent={{90,70},{110,90}}), iconTransformation(extent={{100,70},{120,90}})));

// Internal components

protected
  Modelica.Blocks.Interfaces.RealInput Presence_internal
    "Internal connector required in the case of conditional connection"
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-50,70})));

  BuildSysPro.Utilities.Analysis.TimeIntegral IntegraleTempChaud(Dt=3600)
    "Hour degrees above a threshold of discomfort" annotation (Placement(
        transformation(
        extent={{-9,-8},{9,8}},
        rotation=0,
        origin={73,58})));
  BuildSysPro.Utilities.Analysis.TimeIntegral IntegraleTempFroid(Dt=3600)
    "Hour degrees below the threshold of discomfort" annotation (Placement(
        transformation(
        extent={{-9,-8},{9,8}},
        rotation=0,
        origin={75,-66})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=IntegraleTempFroid.It)
    annotation (Placement(transformation(extent={{42,-32},{80,-8}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=IntegraleTempChaud.It)
    annotation (Placement(transformation(extent={{42,8},{80,32}})));

  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{28,34},{40,46}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{28,-46},{40,-34}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(y=max(0, Tint.T -
        TconsigneRef - SeuilInconfort))
    annotation (Placement(transformation(extent={{-40,12},{-2,36}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=max(0,
        TconsigneChauf - Tint.T - SeuilInconfort))
    annotation (Placement(transformation(extent={{-40,-36},{-2,-12}})));

  BuildSysPro.Utilities.Analysis.TimeIntegral IntegraleTempChaud1(Dt=3600)
    "Hour degrees above a threshold of discomfort" annotation (Placement(
        transformation(
        extent={{-9,-8},{9,8}},
        rotation=0,
        origin={27,86})));
  BuildSysPro.Utilities.Analysis.TimeIntegral IntegraleTempFroid1(Dt=3600)
    "Hour degrees below the threshold of discomfort" annotation (Placement(
        transformation(
        extent={{-9,-8},{9,8}},
        rotation=0,
        origin={23,-86})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=IntegraleTempFroid1.It)
    annotation (Placement(transformation(extent={{42,-106},{80,-82}})));
  Modelica.Blocks.Sources.RealExpression realExpression7(y=IntegraleTempChaud1.It)
    annotation (Placement(transformation(extent={{40,80},{78,104}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(
      Q_flow=0)
    annotation (Placement(transformation(extent={{-98,-44},{-78,-24}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-44,-98},{-24,-78}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-14,-98},{6,-78}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1
    annotation (Placement(transformation(extent={{-10,76},{10,96}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean1
    annotation (Placement(transformation(extent={{-40,76},{-20,96}})));
equation
  connect(Presence, Presence_internal);

  if not UsePresence then
    Presence_internal= 1;
  end if;
  connect(realExpression.y, OutInconfortFroid) annotation (Line(
      points={{81.9,-20},{86,-20},{86,-40},{100,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, OutInconfordChaud) annotation (Line(
      points={{81.9,20},{86,20},{86,40},{100,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product2.u1, Presence_internal) annotation (Line(
      points={{26.8,43.6},{-49.6,43.6},{-49.6,70},{-50,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.u2, Presence_internal) annotation (Line(
      points={{26.8,-43.6},{26.8,-61.8},{-50,-61.8},{-50,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression2.y, product2.u2) annotation (Line(
      points={{-0.1,24},{12,24},{12,36.4},{26.8,36.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression3.y, product1.u1) annotation (Line(
      points={{-0.1,-24},{12,-24},{12,-36.4},{26.8,-36.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product2.y, IntegraleTempChaud.u) annotation (Line(
      points={{40.6,40},{52,40},{52,58},{62.2,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, IntegraleTempFroid.u) annotation (Line(
      points={{40.6,-40},{52,-40},{52,-66},{64.2,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression6.y, OutNbHeureInconfortFroid) annotation (Line(
      points={{81.9,-94},{88,-94},{88,-80},{100,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression7.y, OutNbHeureInconfortChaud) annotation (Line(
      points={{79.9,92},{86,92},{86,80},{100,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, Tint) annotation (Line(
      points={{-77,-33},{-56,-33},{-56,0},{-90,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(booleanToReal.y, IntegraleTempFroid1.u) annotation (Line(
      points={{7,-88},{10,-88},{10,-86},{12.2,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean.y, booleanToReal.u) annotation (Line(
      points={{-23,-88},{-16,-88}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(realToBoolean.u, realExpression3.y) annotation (Line(
      points={{-46,-88},{-56,-88},{-56,-70},{12,-70},{12,-24},{-0.1,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean1.y, booleanToReal1.u) annotation (Line(
      points={{-19,86},{-12,86}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanToReal1.y, IntegraleTempChaud1.u) annotation (Line(
      points={{11,86},{16.2,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean1.u, realExpression2.y) annotation (Line(
      points={{-42,86},{-44,86},{-44,64},{12,64},{12,24},{-0.1,24}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
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
        Ellipse(
          extent={{32,64},{38,58}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Polygon(
          points={{56,-60},{36,-60},{36,-66},{56,-66},{56,-60}},
          lineColor={0,128,255},
          smooth=Smooth.None),
        Polygon(
          points={{34,-78},{46,-80},{56,-78},{68,-80},{74,-82},{76,-78},{84,
              -80},{82,-86},{76,-90},{64,-86},{56,-88},{48,-86},{38,-88},{
              30,-84},{30,-80},{34,-78}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{42,-60},{42,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{44,-60},{44,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{46,-60},{46,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{48,-60},{48,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{50,-60},{50,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{40,40},{54,40}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{44,34},{50,28}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Rectangle(
          extent={{50,32},{44,40}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{24,60},{22,58}}, lineColor={255,0,0}),
        Ellipse(extent={{24,56},{22,54}}, lineColor={255,0,0}),
        Ellipse(extent={{24,52},{22,50}}, lineColor={255,0,0}),
        Ellipse(extent={{24,48},{22,46}}, lineColor={255,0,0}),
        Ellipse(
          extent={{-40,-96},{0,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,42},{-8,-66}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,42},{-32,82},{-30,88},{-26,90},{-20,92},{-14,90},{
              -10,88},{-8,82},{-8,42},{-32,42}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(points={{-60,-18},{-32,-18}}, color={0,0,0}),
        Line(points={{-60,22},{-32,22}}, color={0,0,0}),
        Line(points={{-60,62},{-32,62}}, color={0,0,0}),
        Line(
          points={{-8,42},{-8,-62}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-32,42},{-32,-62}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{54,64},{60,58}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Ellipse(
          extent={{16,-20},{76,-80}},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{32,-36},{38,-42}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,128,255}),
        Ellipse(
          extent={{54,-36},{60,-42}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,128,255}),
        Line(
          points={{38,-60},{38,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{40,-60},{40,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{54,-60},{54,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{52,-60},{52,-66}},
          color={0,128,255},
          smooth=Smooth.None),
        Text(
          extent={{-94,140},{96,114}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{26,76},{68,24}}, lineColor={0,0,0}),
        Ellipse(extent={{26,-24},{68,-76}}, lineColor={0,0,0})}),
    Documentation(info="<html>
<p><i><b>This model calculates the hourly integral characterising both warm and cold discomfort</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model calculates the hourly integral of the difference between indoor temperature and thermally-acceptable condition range.</p>
<p>This range is defined by the parameter <i>SeuilInconfort</i> around the setpoint temperature. This range is not shown on the graph below.</p>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/Inconfort.png\"/></p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Connect the thermal Port <i>Tint</i> to the thermal zone to be monitored.</p>
<p>Connect the realInput <i>Tconsignechauf</i> and <i>TconsigneRef </i>to the cooling and heating setpoint temperature defined in a scenario. This setpoint may include low temperature setpoints.</p>
<p>Set discomfort threshold for the study. The more it is high, the more discomfort will be low because the comfort range will be larger.</p>
<p>Precise if presence is taken into account. The inclusion of presence allows to not overestimate the discomfort by preventing its calculation during occupants absence.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The outputs <i>OutInconfortFroid</i> and <i>OutInconfortChaud</i> are positive and in [&deg;C.h] unit. It is the difference in absolute value between the range of acceptable thermal comfort and indoor temperature which is integrated over time.</p>
<p>The outputs <i>OutNbHeureInconfortFroid</i> and <i>OutNbHeureInconfortChaud</i> are positive and in [h] unit. They indicate the number of dicomfort hours.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 03/2013 : </p>
<p><ul>
<li>Modification du modèle d'inconfort thermique pour prendre en compte une température de consigne différente pour le rafraichissement et le chauffage. Le changement est donc rétro-comptatible en connectant la même température de consigne sur les ports<i> TconsigneRef</i> et<i> TconsigneChauf,</i></li>
<li>Changement de nom du port <i>Tconsigne en TconsigneChauf,</i></li>
<li>Ajout d'une sortie indiquant le nombre d'heure d'inconfort chaud,</li>
<li>Ajout de la condition limite Q_flow=0.</li>
</ul></p>
</html>"));
end ThDiscomfort;
