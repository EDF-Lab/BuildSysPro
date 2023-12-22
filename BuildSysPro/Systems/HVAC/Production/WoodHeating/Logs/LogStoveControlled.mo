within BuildSysPro.Systems.HVAC.Production.WoodHeating.Logs;
model LogStoveControlled

// ---------------------------------------------------------------------------------
//
// COMPLETE MODEL FOR WOOD LOG STOVE
// EIFER
//
// ---------------------------------------------------------------------------------

Integer NbCh;

  Modelica.Blocks.Interfaces.RealInput T_consigne
    "Temperature wanted in the room (K)"
    annotation (Placement(transformation(extent={{-104,0},{-60,44}}),
        iconTransformation(extent={{-98,10},{-78,30}})));
  Modelica.Blocks.Interfaces.BooleanInput forced_start
    "Indicates if the \"forced going\" mode is on"     annotation (Placement(
        transformation(
        extent={{-24,-24},{24,24}},
        rotation=270,
        origin={24,82}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={34,90})));
  Modelica.Blocks.Interfaces.BooleanInput presence
    "Indicates if the user is present in the house"
                                                   annotation (Placement(
        transformation(
        extent={{-24,-24},{24,24}},
        rotation=270,
        origin={-32,84}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-26,90})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heat_Stove
    "Heat port that has to be connected to the room to heat"
    annotation (Placement(transformation(extent={{80,10},{100,30}}),
        iconTransformation(extent={{78,10},{98,30}})));
  LogStove pB50_stove(
    mL0=mL0,
    H=H,
    PCS=PCS,
    mP=mP) annotation (Placement(transformation(extent={{0,-40},{60,40}})));
  LogStoveController pB50_controller
    annotation (Placement(transformation(extent={{-40,0},{0,40}})));
  parameter Modelica.Units.SI.Mass mL0=3.6 "Initial mass of wet wood log";
  parameter Real H=15.0 "Wood humidity in %";
  parameter Modelica.Units.SI.SpecificEnergy PCS=20000000
    "Higher Heating Value - HHV";
  parameter Modelica.Units.SI.Mass mP=113 "Stove's mass";
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{44,-64},{34,-54}})));
equation

  when Heat_Stove.Q_flow<-5000 then
    NbCh=pre(NbCh)+1;
  end when;

  connect(pB50_stove.Convection, Heat_Stove) annotation (Line(
      points={{53.4,20},{90,20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pB50_stove.Radiation, Heat_Stove) annotation (Line(
      points={{53.4,-4},{80.9,-4},{80.9,20},{90,20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_consigne, pB50_controller.Tconsigne) annotation (Line(
      points={{-82,22},{-62,22},{-62,24.2},{-36.6,24.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pB50_controller.allure, pB50_stove.Allure) annotation (Line(
      points={{-3.6,25.2},{3.2,25.2},{3.2,19.2},{3,19.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pB50_controller.tim_start, pB50_stove.t_start) annotation (Line(
      points={{-3.6,12},{-3.6,4},{3,4},{3,-2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(presence, pB50_controller.presence) annotation (Line(
      points={{-32,84},{-36,84},{-36,33.8},{-36.6,33.8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(forced_start, pB50_controller.marche_forcee) annotation (Line(
      points={{24,82},{2,82},{2,36.6},{-21.8,36.6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(Heat_Stove, temperatureSensor.port) annotation (Line(
      points={{90,20},{90,-59},{44,-59}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pB50_controller.m_b, pB50_stove.m_b) annotation (Line(
      points={{-36.6,14.2},{-54,14.2},{-54,-44},{58,-44},{58,-26},{
          53.7,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, pB50_stove.Tpiece) annotation (Line(
      points={{33.5,-59},{-42,-59},{-42,-27.2},{10.2,-27.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, pB50_controller.Tsens) annotation (Line(
      points={{33.5,-59},{-42,-59},{-42,6.6},{-36.6,6.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-46,-84},{-34,-100}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,82},{70,-84}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-52,64},{62,-44}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{24,-2},{52,-28}},
          fillColor={108,80,80},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-28,-16},{36,-2},{42,-28},{-24,-42},{-22,-42},{-24,-42},
              {-28,-16}},
          smooth=Smooth.None,
          fillColor={104,77,77},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-40,-16},{-12,-42}},
          fillColor={207,138,69},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-16,-14},{-44,32},{-18,22},{-16,24},{-6,60},{14,34},{
              34,48},{30,-8},{-16,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-8,-14},{-24,16},{-10,16},{-2,46},{14,24},{28,36},{24,
              -10},{-8,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,179,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-14},{-10,4},{4,2},{2,22},{10,0},{10,2},{20,16},{14,
              -12},{0,-14}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-54},{-40,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,72},{64,72}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,70},{64,70}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,68},{64,68}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,-48},{62,-48}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,-46},{62,-46}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,-50},{62,-50}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-48,-54},{-46,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-36,-54},{-34,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-30,-54},{-28,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-24,-54},{-22,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-18,-54},{-16,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-12,-54},{-10,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,-54},{-4,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,-54},{2,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{6,-54},{8,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{12,-54},{14,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{18,-54},{20,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,-54},{26,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{30,-54},{32,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{36,-54},{38,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{42,-54},{44,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{48,-54},{50,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{54,-54},{56,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{60,-54},{62,-78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-90,-26},{-32,-94}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-84,-34},{-40,-58}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-90,-70},{-30,-88}},
          lineColor={0,0,255},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid,
          textString="Reg."),
        Rectangle(
          extent={{52,-84},{64,-100}},
          fillColor={68,68,68},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,78},{64,78}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,76},{64,76}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,74},{64,74}},
          fillColor={138,138,138},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>LOG STOVE</p>
<p><u><b>Description</b></u></p>
<p>Log stove equipped with a regulation system integrating conditions as to the load of the stove.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none. </p>
<p><u><b>Bibliography</b></u></p>
<p>detailled model is the note :H-E14-2011-01955-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 09/2011</p>

<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end LogStoveControlled;
