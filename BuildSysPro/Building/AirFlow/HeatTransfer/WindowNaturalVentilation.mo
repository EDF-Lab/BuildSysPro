within BuildSysPro.Building.AirFlow.HeatTransfer;
model WindowNaturalVentilation

parameter Modelica.SIunits.Area Sfenetre = 1.5 "Average surface of a window"    annotation(Dialog(group="Windows description"));
parameter Modelica.SIunits.Height Hfenetre=1.25 "Average height of a window"
                                 annotation(Dialog(group="Windows description"));
parameter Real NbFenetres = 1 "Number of open windows"   annotation(Dialog(group="Windows description"));

public
  Modelica.Blocks.Interfaces.RealInput                               T_ext
    "outdoor temperature [K]"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealInput                               T_int
    "indoor temperature [K]"
    annotation (Placement(transformation(extent={{120,-20},{80,20}}),
        iconTransformation(extent={{100,-20},{60,20}})));
  Modelica.Blocks.Interfaces.RealInput V
    "wind speed prependicular to the window (m/s)"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Interfaces.BooleanInput ouverture_fenetre
    "true if opened window, false if not" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealOutput Qfenetres
    "Natural flow entering through the windows [m3/h]" annotation (Placement(
        transformation(extent={{80,-80},{120,-40}}), iconTransformation(extent={
            {60,-80},{100,-40}})));
equation
  if ouverture_fenetre==true then
    Qfenetres=NbFenetres*3600*0.5*Sfenetre*(0.001*V^2+0.0035*Hfenetre*abs(T_int-T_ext)+0.01)^(1/2);
  else
    Qfenetres=0;
  end if;

  annotation (                                  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-40,60},{40,100},{40,-40},{-40,-80},{-40,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={219,238,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,60},{20,20},{20,-120},{-40,-80},{-40,-58},{-40,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          lineThickness=1),
        Ellipse(
          extent={{-64,18},{-56,26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,42},{-58,24}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,42},{-62,62},{-62,64},{-60,66},{-60,66},{-58,64},{-58,62},
              {-58,62},{-58,42},{-62,42}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-62,43},{-62,25}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-58,42},{-58,25}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-68,54},{-62,54}}, color={0,0,0}),
        Line(points={{-68,40},{-62,40}}, color={0,0,0}),
        Line(points={{-68,30},{-62,30}},   color={0,0,0}),
        Ellipse(
          extent={{56,18},{64,26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,42},{62,24}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{58,42},{58,62},{58,64},{60,66},{60,66},{62,64},{62,62},{62,
              62},{62,42},{58,42}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{58,43},{58,25}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{62,42},{62,25}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{52,54},{58,54}},   color={0,0,0}),
        Line(points={{52,40},{58,40}},   color={0,0,0}),
        Line(points={{52,30},{58,30}},     color={0,0,0}),
        Line(
          points={{-6,-4},{58,-52}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          smooth=Smooth.None),
        Line(
          points={{-12,-12},{52,-60}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          smooth=Smooth.None),
        Line(
          points={{-18,-20},{46,-68}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><i><b>Natural ventilation model considering windows opening</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Calculation of renewal air flow by windows opening based on the following equation:</p>
<p>air_flow = 3600 x 0.5 x Swindow x (0.001 x Vwind^2 + 0.0035 x Hwindow x abs(Tint - Text) + 0.01)^(1/2)</p>
<p><u><b>Bibliography</b></u></p>
<p>Calculation method TH-BCE RT 2012 (french building regulation) section 7.15 Calcul des débits d'air entrant liés à l'ouverture des baies</p>
<p>Model TF N°151 of Clim 2000. FICHE DESCRIPTIVE DU TYPE FORMEL N° 151 - Pertes liées à l'ouverture d'une fenêtre (Clim 2000)</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This model considers only the flow rate drives by the difference of temperature and the wind, it does not take into account pressure considerations.</p>
<p>No consideration of wind direction.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model compared to Clim2000 - Vincent Magnaudeix 06/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Vincent MAGNAUDEIX, EDF (2013))<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 04/2014 : transformation de la vitesse du vent en vitesse normale à la fenêtre, pour ne pas prendre en compte la même vitesse de vent sur toutes les façades</p>
</html>"));
end WindowNaturalVentilation;
