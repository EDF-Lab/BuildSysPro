within BuildSysPro.BoundaryConditions.Scenarios;
model NightVentilation
  "Model of overventilation by windows opening for summer comfort"

  parameter Modelica.Units.SI.Temperature Touverture=299.15
    "Indoor temperature beyong which windows are opened"
    annotation (Dialog(group="Summer comfort"));
  parameter Modelica.Units.SI.Temperature Tfermeture=293.15
    "Indoor temperature below which windows are closed"
    annotation (Dialog(group="Summer comfort"));

  parameter Modelica.Units.NonSI.Temperature_degC deltaT=1
    "Halfband of hysteresis on the condition that indoor temperature must be higher than outdoor temperature"
    annotation (Dialog(group="Summer comfort"));
  Integer Hyst1 "Hysteresis on temperature";
  Integer Hyst2 "Hysteresis on temperature";

  Modelica.Blocks.Interfaces.RealInput Tint "Indoor temperature in K"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,-8},{-72,20}})));
  Modelica.Blocks.Interfaces.RealInput Text "Outdoor temperature in K"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}),
        iconTransformation(extent={{-100,-72},{-72,-44}})));
  Modelica.Blocks.Interfaces.RealInput Presence annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-4,-100}), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=90,
        origin={-21,-93})));
  Modelica.Blocks.Math.MultiProduct multiProduct(nu=4)
    annotation (Placement(transformation(extent={{26,-28},{38,-16}})));
  Modelica.Blocks.Sources.Pulse pulse(period(displayUnit="h") = 86400,
    startTime(displayUnit="h") = 72000,
    width=100)                            annotation (Placement(
        transformation(extent={{-32,-56},{-12,-36}})));
  Modelica.Blocks.Interfaces.RealInput AutorisationSurventil
                                                annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={24,-100}), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=90,
        origin={19,-93})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=Hyst1*Hyst2)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Interfaces.BooleanOutput ouverture_fenetre
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
algorithm
  Hyst1:=if Tint<Tfermeture then 0 elseif Tint>Touverture then 1 else pre(Hyst1);
  Hyst2:=if Tint>Text+deltaT then 1 elseif Tint<Text-deltaT then 0 else pre(Hyst2);
equation

 ouverture_fenetre=if multiProduct.y<1 then false else true;

  connect(multiProduct.u[1], Presence) annotation (Line(
      points={{26,-18.85},{26,-58},{-4,-58},{-4,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, multiProduct.u[2]) annotation (Line(
      points={{-11,-46},{-4,-46},{-4,-28},{26,-28},{26,-20.95}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AutorisationSurventil, multiProduct.u[3]) annotation (Line(
      points={{24,-100},{26,-100},{26,-23.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, multiProduct.u[4]) annotation (Line(
      points={{-39,-20},{-6,-20},{-6,-25.15},{26,-25.15}},
      color={0,0,127},
      smooth=Smooth.None));
                                                                                annotation (
              Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
                                 Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}),
                                      graphics={Rectangle(
          extent={{-88,90},{86,-94}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),      Rectangle(
          extent={{-74,78},{4,-76}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),      Rectangle(
          extent={{16,78},{72,-76}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p><i><b>Control model of windows opening and closing </b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Windows opening control with two hysteresis:</p>
<p>- One on indoor temperature: opening if the indoor temperature exceeds the opening temperature, closure if the indoor temperature is below the closing temperature</p>
<p>- One on the indoor-outdoor temperature difference: opening if indoor temperature is higher than outdoor temperature + deltaT, closing if the indoor temperature is lower than outside air temperature-deltaT.</p>
<p><u><b>Bibliography</b></u></p>
<p>None</p>
<p><u><b>Instructions for use</b></u></p>
<p>None</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Non-validated model - Vincent Magnaudeix 06/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Vincent MAGNAUDEIX, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 03/2014 : - suppression des Real to Boolean et Boolean to Real qui consomment beaucoup de temps de calcul</p>
<p>- ajout d'un hystérésis sur la température extérieure, pour éviter une condition d'oscillation autour de la température de consigne et donc un état oscillant continument entre ouverture et fermeture de la fenêtre</p>
<p>- comme il existe un modèle qui permet de calculer le débit de ventilation naturelle engendré par l'ouverture de la fenêtre dans le modèle de vitrage, il est inutile de calculer le renouvellement d'air ici, il faut simplement calculer la commande d'ouverture ou de fermeture de la fenêtre.</p>
</html>"));
end NightVentilation;
