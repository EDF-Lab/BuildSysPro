within BuildSysPro.Building.AirFlow.HeatTransfer;
model WindowNaturalVentilation

parameter Modelica.SIunits.Area Sfenetre = 1.5 "Surface moyenne d'une fenêtre"
                                                                                annotation(dialog(group="Description des fenêtres"));
parameter Modelica.SIunits.Height Hfenetre=1.25
    "Hauteur moyenne d'une fenêtre" annotation(dialog(group="Description des fenêtres"));
parameter Real NbFenetres = 1 "Nombre de fenêtres ouvertes"   annotation(dialog(group="Description des fenêtres"));

public
  Modelica.Blocks.Interfaces.RealInput                               T_ext
    "température extérieure [K]"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealInput                               T_int
    "température intérieure [K]"
    annotation (Placement(transformation(extent={{120,-20},{80,20}}),
        iconTransformation(extent={{100,-20},{60,20}})));
  Modelica.Blocks.Interfaces.RealInput V
    "vitesse du vent normale à la fenêtre (m/s)"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Interfaces.BooleanInput ouverture_fenetre
    "true si fenêtre ouverte, false sinon" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealOutput Qfenetres
    "Flux naturel entrant par les fenêtres [m3/h]" annotation (Placement(
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
<p><i><b>Modèle de ventilation naturelle (débit d'air) par ouverture des fenêtres</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Formule de calcul du débit de renouvellement d'air par ouverture des fenêtres reprise du TF N&deg;151 de Clim 2000.</p>
<p>debit_air = 3600 x 0.5 x Sfenetre x (0.001 x Vvent^2 + 0.0035 x Hfenetre x abs(Tint - Text) + 0.01)^(1/2)</p>
<p><br><u><b>Bibliographie</b></u></p>
<p>Méthode de calcul TH-BCE RT 2012 section 7.15 Calcul des débits d'air entrant liés à l'ouverture des baies</p>
<p>FICHE DESCRIPTIVE DU TYPE FORMEL N&deg; 151 - Pertes liées à l'ouverture d'une fenêtre (Clim 2000)</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Ce modèle ne prend en compte que le débit engendré par la différence de température et le vent, et ne prend pas en compte des considérations en pression.</p>
<p>Pas de prise en compte de l'orientation du vent</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé par rapport à Clim2000 - Vincent Magnaudeix 06/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Vincent MAGNAUDEIX, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 04/2014 : transformation de la vitesse du vent en vitesse normale à la fenêtre, pour ne pas prendre en compte la même vitesse de vent sur toutes les façades</p>
</html>"));
end WindowNaturalVentilation;
