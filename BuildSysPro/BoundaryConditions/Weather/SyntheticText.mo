within BuildSysPro.BoundaryConditions.Weather;
model SyntheticText "Profil d'une belle journée"

  Modelica.Blocks.Interfaces.RealOutput Text
    "Température extérieure d'une belle journée"                                          annotation (Placement(
        transformation(extent={{0,40},{20,60}}), iconTransformation(extent={{0,
            40},{20,60}})));

parameter Real Htmax=14 "Heure du maximum de température, en heures";
parameter Real midi=12 "Heure du midi solaire, en heures";
parameter Real Tmin=15 "Température minimale, en degrés";
parameter Real Tmax=30 "Température maximale, en degrés";
parameter Real DureeJour = 10 "Durée du jour, en heures";

protected
Real t "Temps courant, en heures, et nul au midi solaire";
parameter Real t0 = 0.5*DureeJour;

algorithm
t:= time/3600 - midi;
Text:= Tmax + (Tmin-Tmax)*( cos(Modelica.Constants.pi*(t-Htmax+midi)/(2*t0)) - 1)  / ( cos(Modelica.Constants.pi*(t0+Htmax+midi)/(2*t0)) - 1);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-42,8},{94,-48}},
          lineColor={127,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.CrossDiag,
          textString="Température extérieure de synthèse"),
        Rectangle(
          extent={{-52,42},{-28,-66}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,-96},{-20,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,42},{-52,82},{-50,88},{-46,90},{-40,92},{-34,90},
              {-30,88},{-28,82},{-28,42},{-52,42}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-52,42},{-28,-66}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-28,42},{-28,-62}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-52,40},{-52,-64}},
          color={0,0,0},
          thickness=0.5)}),
Documentation(info="<html>
<p>Expression analytique modélisant le profil de température extérieure d'une belle journée. Elle est obtenue par identification des paramètres. </p>
<p>voir aussi S. KRAUTER, Betriebsmodell der optischen, thermischen und elektrischen Parameter von photovoltaischen Modulen, édition Koester Verlag, 1993. </p>
<p>Fonction validée. EAB juillet 2010. </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end SyntheticText;
