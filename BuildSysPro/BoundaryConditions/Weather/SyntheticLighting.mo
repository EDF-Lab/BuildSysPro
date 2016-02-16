within BuildSysPro.BoundaryConditions.Weather;
model SyntheticLighting "Profil d'une belle journée"

  Modelica.Blocks.Interfaces.RealOutput G
    "Flux solaire global d'une belle journée"                                       annotation (Placement(transformation(
          extent={{76,40},{96,60}}), iconTransformation(extent={{80,40},{100,60}})));

parameter Real midi=12 "Heure du midi solaire, en heures";
parameter Real DureeJour=10 "Durée du jour, en heures";
parameter Real H=5000 "Energie solaire sur la journée en Wh/m²";
parameter Real Gmax=1000
    "Eclairement maximal (par construction il doit être au midi solaire)";
protected
Real t "Temps courant, en heures, et nul au midi solaire";
parameter Real t0 = 0.5*DureeJour
    "Heure du coucher de soleil, avec la convention sur t";
parameter Real s=(Modelica.Constants.pi*H/(4*t0*Gmax)-1)/(1-Modelica.Constants.pi/4);

algorithm
t:=time/3600 - midi;
G:= if t>-t0 and t<t0 then max(0,Gmax*cos(Modelica.Constants.pi*t/(2*t0)) * (1 + s*(1-cos(Modelica.Constants.pi*t/(2*t0)))))
     else                                                                                                     0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Ellipse(
          extent={{-80,86},{80,-84}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.CrossDiag), Text(
          extent={{-66,36},{70,-20}},
          lineColor={127,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.CrossDiag,
          textString="Soleil de synthèse (au Sud uniquement !!)")}),
    Documentation(info="<html>
<p>Expression analytique modélisant l'éclairement d'une (et une seule !) belle journée sur une surface quelconque. Cette expression est obtenue en développant la fonction qui représente l'éclairement en série de Fourier, en la considérant périodique et de période 2*durée du jour. Cette méthode est équivalente à la norme EN 61725. </p>
<p>Fonction validée. EAB juillet 2010. </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end SyntheticLighting;
