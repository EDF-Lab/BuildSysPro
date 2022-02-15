within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.WoodBoiler;
model WoodBoiler "Wood Boiler"

  parameter Modelica.Units.SI.Power Pcombmax=6580
    "Maximum thermal power";
  parameter Real table[:,2]=[-20,60; -7,60;  10,40;  20,40]
    "Water law table : Column 1 outdoor temperature (°C) and column 2 the water outlet setpoint temperature (°C)";
  parameter Modelica.Units.SI.MassFlowRate Debit=0.02
    "Mass flow of water circulating in the boiler";
  parameter Modelica.Units.SI.Volume Veau=0.01
    "Volume of water contained in the boiler";
  parameter Modelica.Units.SI.Power Pcombmin=0.25*Pcombmax
    "Minimum thermal power";
  parameter Modelica.Units.SI.Power Pel_1=8.88
    "Electrical power consumption, slope ";
  parameter Modelica.Units.SI.Power Pel_sta=330
    "Electric power at start phase part 1 ";
  parameter Modelica.Units.SI.Power Pe0=33
    "Electrical power consumption at gamma=0 ";

protected
  Boolean x;

public
  Modelica.Blocks.Interfaces.BooleanInput SaisonChauff
    "Seasonal heating cut-off (=false)"   annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-30,120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,120})));
  PGS.PGS_stove pGVH_poe(
    Pe0=Pe0,
    Pel_1=Pel_1,
    Pel_sta=Pel_sta,
    Pcmb_sta=Pcombmax*3333/6578,
    Pmax=Pcombmax)
    annotation (Placement(transformation(extent={{20,-22},{60,18}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo1
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-29,-65})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CpEau(C=4180*1000*Veau)
    "Heat capacity of water volume"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-90},{120,-50}}),
        iconTransformation(extent={{100,-110},{120,-90}})));
  Controls.WaterDesignTemperature loiDEau(table=table)
    annotation (Placement(transformation(extent={{-82,32},{-62,56}})));
  Modelica.Blocks.Interfaces.RealInput T_ext
    "Outdoor temeprature for water law"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  Modelica.Blocks.Sources.RealExpression BilanEau(y=Debit*4180*(WaterIn[1] -
        WaterOut[1]))
    annotation (Placement(transformation(extent={{-80,-76},{-46,-56}})));
  Modelica.Blocks.Continuous.LimPID    RegPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=600,
    yMin=0) annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
protected
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-4,6},{12,-10}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=x)
    annotation (Placement(transformation(extent={{-24,-12},{-14,2}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=0)
    annotation (Placement(transformation(extent={{-24,-2},{-14,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=+10)
    annotation (Placement(transformation(extent={{-10,48},{0,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=-10)
    annotation (Placement(transformation(extent={{-10,28},{0,40}})));
  Modelica.Blocks.Sources.RealExpression DebitExp(y=Debit)
    annotation (Placement(transformation(extent={{20,-70},{40,-54}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{26,-84},{40,-70}})));

public
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{20,52},{30,62}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{20,32},{30,42}})));
equation
 if RegPI.y < (Pcombmin/Pcombmax) then
    x = false;
  elseif RegPI.y > (Pcombmin/Pcombmax + 0.20) then
    x = true;
  else
    x = pre(x);
 end if;

  connect(SaisonChauff, pGVH_poe.presence)
                                       annotation (Line(
      points={{-30,120},{-30,12},{22,12}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(add.y, pGVH_poe.Toff) annotation (Line(
      points={{30.5,57},{46,57},{46,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CpEau.port, temperatureSensor.port) annotation (Line(
      points={{0,-80},{0,-77},{26,-77}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(CpEau.port, preHeaFlo1.port) annotation (Line(
      points={{0,-80},{0,-65},{-22,-65}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(loiDEau.T_sp, add.u1) annotation (Line(
      points={{-61.4,44},{8,44},{8,60},{19,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, add.u2) annotation (Line(
      points={{0.5,54},{19,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_ext, loiDEau.T_ext) annotation (Line(
      points={{-120,50},{-100.5,50},{-100.5,44},{-81,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(BilanEau.y, preHeaFlo1.Q_flow) annotation (Line(
      points={{-44.3,-66},{-40.65,-66},{-40.65,-65},{-36,-65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loiDEau.T_sp, RegPI.u_s) annotation (Line(
      points={{-61.4,44},{-58,44},{-58,-10},{-52,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, RegPI.u_m)        annotation (Line(
      points={{40.7,-77},{42,-77},{42,-68},{8,-68},{8,-40},{-40,-40},{-40,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pGVH_poe.PowerOut, CpEau.port) annotation (Line(
      points={{58,0},{58,-30},{0,-30},{0,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pGVH_poe.Tsens, CpEau.port) annotation (Line(
      points={{22,-12},{22,-30},{0,-30},{0,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(switch1.y, pGVH_poe.g) annotation (Line(
      points={{12.8,-2},{18.25,-2},{18.25,4},{22,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RegPI.y, switch1.u1) annotation (Line(
      points={{-29,-10},{-12,-10},{-12,-8.4},{-5.6,-8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanExpression.y, switch1.u2) annotation (Line(
      points={{-13.5,-5},{-13.5,-4.5},{-5.6,-4.5},{-5.6,-2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(realExpression2.y, switch1.u3) annotation (Line(
      points={{-13.5,4},{-6,4},{-6,4.4},{-5.6,4.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, pGVH_poe.Ton) annotation (Line(
      points={{30.5,37},{30.5,36.5},{34,36.5},{34,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loiDEau.T_sp, add1.u1) annotation (Line(
      points={{-61.4,44},{8,44},{8,40},{19,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, add1.u2) annotation (Line(
      points={{0.5,34},{19,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(WaterIn, loiDEau.RetourDEau) annotation (Line(
      points={{-120,-70},{-90,-70},{-90,40.4},{-81,40.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, WaterOut[1]) annotation (Line(
      points={{40.7,-77},{62,-77},{62,-80},{100,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DebitExp.y, WaterOut[2]) annotation (Line(
      points={{41,-62},{62,-62},{62,-60},{100,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-120},{120,120}}),
                                      graphics={
        Rectangle(
          extent={{-60,106},{80,-60}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-52,88},{72,-20}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-8,10},{-36,56},{-10,46},{-8,48},{2,84},{22,58},{42,72},{38,16},
              {-8,10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,10},{-16,40},{-2,40},{6,70},{22,48},{36,60},{32,14},{0,10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,179,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,10},{-2,28},{12,26},{10,46},{18,24},{18,26},{28,40},{22,12},
              {8,10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-30},{-38,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,-30},{-44,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,-30},{-32,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-28,-30},{-26,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-22,-30},{-20,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-16,-30},{-14,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-10,-30},{-8,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-4,-30},{-2,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{2,-30},{4,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{8,-30},{10,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{14,-30},{16,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{20,-30},{22,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{26,-30},{28,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{32,-30},{34,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{38,-30},{40,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{44,-30},{46,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{50,-30},{52,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{56,-30},{58,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{62,-30},{64,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{68,-30},{70,-54}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{50,6},{36,-2},{28,0},{42,6},{50,6}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{50,6},{50,4},{36,-4},{28,-2},{28,0},{36,-2},{50,6}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{60,16},{46,8},{38,10},{52,16},{60,16}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{60,16},{60,14},{46,6},{38,8},{38,10},{46,8},{60,16}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{50,20},{36,12},{28,14},{42,20},{50,20}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{50,20},{50,18},{36,10},{28,12},{28,14},{36,12},{50,20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{38,10},{24,2},{16,4},{30,10},{38,10}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{38,10},{38,8},{24,0},{16,2},{16,4},{24,2},{38,10}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={39,13},
          rotation=270),
        Polygon(
          points={{20,4},{6,-4},{-2,-2},{12,4},{20,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{20,4},{20,2},{6,-6},{-2,-4},{-2,-2},{6,-4},{20,4}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{22,12},{8,4},{0,6},{14,12},{22,12}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{22,12},{22,10},{8,2},{0,4},{0,6},{8,4},{22,12}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{-2,14},{-16,6},{-24,8},{-10,14},{-2,14}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-2,14},{-2,12},{-16,4},{-24,6},{-24,8},{-16,6},{-2,14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{0,4},{0,2},{-14,-6},{-22,-4},{-22,-2},{-14,-4},{0,4}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{26,12},{12,4},{4,6},{18,12},{26,12}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{26,12},{26,10},{12,2},{4,4},{4,6},{12,4},{26,12}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={-13,5},
          rotation=270),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={3,9},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={3,10},
          rotation=90),
        Polygon(
          points={{11,5},{11,3},{-3,-5},{-11,-3},{-11,-1},{-3,-3},{11,5}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={235,206,136},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0},
          origin={27,3},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={27,4},
          rotation=90),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-13,6},
          rotation=270),
        Polygon(
          points={{11,4},{-3,-4},{-11,-2},{3,4},{11,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={39,14},
          rotation=270),
        Polygon(
          points={{0,4},{-14,-4},{-22,-2},{-8,4},{0,4}},
          smooth=Smooth.None,
          fillColor={154,95,0},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-90,-90},{-48,-110}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Ellipse(
          extent={{82,-90},{94,-110}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-94,-90},{-86,-110}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,-90},{88,-110}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-60,-90},{56,-110}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash),
        Polygon(
          points={{-10,-20},{2,16},{-6,16},{8,22},{10,10},{6,14},{-6,-22},{-10,-20}},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={6,-68},
          rotation=180),
        Rectangle(
          extent={{-52,94},{72,92}},
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-52,98},{72,96}},
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-52,102},{72,100}},
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-52,-24},{72,-26}},
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-52,-26},{72,-28}},
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
                                                Rectangle(
          extent={{-90,-14},{-32,-80}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
                                     Rectangle(
          extent={{-84,-22},{-38,-42}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-82,-24},{-40,-40}},
          lineColor={0,0,255},
          textString="Loi d'eau"),
        Rectangle(extent={{-114,116},{116,-116}}, lineColor={0,0,0})}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pellet boiler model from BuildSysPro stove model which is based on TRNSYS Type model 210 model which is valid for stove or boiler modeling.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>"));
end WoodBoiler;
