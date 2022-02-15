within BuildSysPro.BoundaryConditions.Scenarios;
model ShutterControl
  "Shutters control for closure and occultancy during night in the cooling period - comfort objective"

parameter Integer HeureOuvertureMatin = 8
    "Shutters opening time in the morning"                                          annotation(Dialog(group="Night closure"));

parameter Integer HeureFermetureSoir = 21
    "Shutters closing time in the evening"                                       annotation(Dialog(group="Night closure"));
  parameter Modelica.Units.SI.Temperature Tfermeture=299.15
    "Indoor temperature beyond which shutters are closed during the day"
    annotation (Dialog(group="Summer comfort"));
  parameter Modelica.Units.SI.Temperature Touverture=297.15
    "Indoor temperature below which shutters are opened during the day"
    annotation (Dialog(group="Summer comfort"));

Real TauxOccultation "Shutters occultancy level during the day";
Integer Hyst1 "Temperature hysteresis";

  Modelica.Blocks.Interfaces.RealInput Tint "Indoor temperature in K"
    annotation (Placement(transformation(extent={{-114,64},{-86,92}}),
        iconTransformation(extent={{-96,-8},{-68,20}})));
  Modelica.Blocks.Interfaces.RealInput Occupation "1 - occupancy ; 0 - absence"
                                                annotation (Placement(
        transformation(
        extent={{-16,-16},{16,16}},
        rotation=0,
        origin={-100,0}), iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={-34,-78})));
  Modelica.Blocks.Interfaces.RealOutput TauxFermeture
    "shutters occultancy level"                                                  annotation (Placement(
        transformation(extent={{78,-32},{106,-4}}), iconTransformation(extent={{
            78,-14},{106,14}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period(displayUnit="h") = 86400,
    nperiod=-1,
    width=(HeureFermetureSoir - HeureOuvertureMatin)/24*100,
    startTime(displayUnit="h") = HeureOuvertureMatin*3600,
    amplitude=-1,
    offset=1)
    annotation (Placement(transformation(extent={{-92,-60},{-72,-40}})));
  Modelica.Blocks.Math.MultiProduct product(nu=3)  annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={-57,-7})));
  Modelica.Blocks.Sources.RealExpression Taux_occultation(y=TauxOccultation)
    annotation (Placement(transformation(extent={{-90,32},{-64,54}})));
  Modelica.Blocks.Math.Max max
    annotation (Placement(transformation(extent={{-30,-50},{-18,-38}})));
  Modelica.Blocks.Interfaces.RealInput OnOff_CommandeVolet
    "1- shutters control is possible 0- no shutters control"
                                                annotation (Placement(
        transformation(
        extent={{-13,-13},{13,13}},
        rotation=0,
        origin={-5,-19}),  iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={30,-78})));

  Modelica.Blocks.Sources.RealExpression hysteresis_temperature(y=Hyst1)
    annotation (Placement(transformation(extent={{-66,70},{-46,90}})));
  Modelica.Blocks.Math.MultiProduct product1(
                                            nu=2)  annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={45,-33})));
algorithm
  Hyst1:=if Tint<Touverture then 0 elseif Tint>Tfermeture then 1 else pre(Hyst1);
equation

 //Variation in occultation level during according to the occupancy scenario
    if Occupation>=0.5 then
      TauxOccultation = 0.5;
    else
      TauxOccultation = 0.8;
    end if;

  connect(Taux_occultation.y, product.u[1])
                                  annotation (Line(
      points={{-62.7,43},{-53.7333,43},{-53.7333,3.10862e-015}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(hysteresis_temperature.y, product.u[2]) annotation (Line(
      points={{-45,80},{-38,80},{-38,82},{-28,82},{-28,8},{-57,8},{-57,3.10862e-015}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(Occupation, product.u[3]) annotation (Line(
      points={{-100,0},{-78,0},{-78,16},{-60.2667,16},{-60.2667,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, max.u1) annotation (Line(
      points={{-57,-15.19},{-57,-40.4},{-31.2,-40.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, max.u2) annotation (Line(
      points={{-71,-50},{-56,-50},{-56,-47.6},{-31.2,-47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max.y, product1.u[1]) annotation (Line(
      points={{-17.4,-44},{2,-44},{2,-40},{38,-40},{38,-30.55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(OnOff_CommandeVolet, product1.u[2]) annotation (Line(
      points={{-5,-19},{14,-19},{14,-35.45},{38,-35.45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, TauxFermeture) annotation (Line(
      points={{53.19,-33},{60,-33},{60,-18},{92,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true),
         graphics={                             Rectangle(
          extent={{-84,90},{90,-94}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),      Rectangle(
          extent={{-64,70},{68,-78}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-64,70},{68,60}},
          pattern=LinePattern.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-64,58},{68,48}},
          pattern=LinePattern.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-64,46},{68,36}},
          pattern=LinePattern.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-64,34},{68,24}},
          pattern=LinePattern.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-64,22},{68,12}},
          pattern=LinePattern.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    Documentation(info="<html>

<p><i><b>Control model of shutters opening and closing</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Control model of shutters opening:</p>
<p>- closure during night (between closing time and opening time)</p>
<p>- occultation during summer with a hysteresis depending on the indoor temperature when the housing is occupied </p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Non-validated model - Vincent Magnaudeix 06/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Vincent MAGNAUDEIX, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 03/2014 : suppression des Real to Boolean et Boolean to Real qui consomment énormément de temps de calcul</p>
<p>Amy Lindsay 04/2014 : sortie Taux de fermeture des volets (et non taux d'ouverture !) pour cohérence avec modèles de vitrage</p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
            graphics));
end ShutterControl;
