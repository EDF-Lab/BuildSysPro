within BuildSysPro.BoundaryConditions.Weather;
model ZoneWind "Wind computation for a zone model"

parameter Boolean ChoixAzimuth=false
    "Choice to enter either a common azimuth correction or each azimuth values"
    annotation(choices(choice=true "Specify each azimuth", choice=false
        "Specify common correction",                                                                       radioButtons=true));
parameter Real beta=0
    "Vertical walls azimuth correction in such a way that azimuth=beta+azimuth, (beta=0 : {N=180,S=0,E=-90,O=90})"
    annotation(Dialog(enable=not ChoixAzimuth));
parameter Real azim[4]={beta+180,beta,beta-90,beta+90}
    "Output walls azimuth, by default 1-North, 2-South, 3-East, 4-West"
      annotation(Dialog(enable=ChoixAzimuth));
  parameter Real incl[4]={90,90,90,90}
    "Walls tilt, by default 1-North, 2-South, 3-East, 4-West";

Modelica.Blocks.Interfaces.RealOutput VENTNord
    "Wind speed on the northern-facing wall [m/s]" annotation (Placement(
        transformation(extent={{80,31},{118,69}}, rotation=0),
        iconTransformation(extent={{100,32},{120,52}})));

Modelica.Blocks.Interfaces.RealOutput VENTSud
    "Wind speed on the south-facing wall [m/s]" annotation (Placement(
        transformation(extent={{80,-9},{118,29}}, rotation=0),
        iconTransformation(extent={{100,-6},{120,14}})));
Modelica.Blocks.Interfaces.RealOutput VENTEst
    "Wind speed on the east-facing wall [m/s]"  annotation (Placement(
        transformation(extent={{81,-49},{118,-12}}, rotation=0),
        iconTransformation(extent={{100,-46},{120,-26}})));
Modelica.Blocks.Interfaces.RealOutput VENTOuest
    "Wind speed on the west-facing wall [m/s]"  annotation (Placement(
        transformation(extent={{80,-89},{118,-51}}, rotation=0),
        iconTransformation(extent={{100,-86},{120,-66}})));

Modelica.Blocks.Interfaces.RealInput V[2]
    "1- wind speed [m/s] 2- wind direction (0- North, 90 - East, 180 - South, 270 - West)"
    annotation (Placement(transformation(extent={{-139,-31},{-99,9}}, rotation=0),
        iconTransformation(extent={{-119,-11},{-99,9}})));

protected
  parameter Real azim_in[4]=if ChoixAzimuth then azim[1:4] else {beta+180,beta,beta-90,beta+90};
  constant Real d2r=Modelica.Constants.pi/180;

algorithm
//  Calculation of walls normal wind speeds
VENTNord:=max(0,cos((V[2]+180-azim_in[1])*d2r))*V[1];
VENTSud:=max(0,cos((V[2]+180-azim_in[2])*d2r))*V[1];
VENTEst:=max(0,cos((V[2]+180-azim_in[3])*d2r))*V[1];
VENTOuest:=max(0,cos((V[2]+180-azim_in[4])*d2r))*V[1];
annotation (Documentation(info="<html>
<p><i><b>Wind speed computation on a zone</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model calculates the wind speed on four oriented walls of a zone (North, South, East, West by default).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Model which takes as input the vector <code>V</code> from a weather data reader, with the Universal Time (UTC) as time base to calculate the wind speed on four oriented walls (vertical by default) of a room (North, South, East, West by default).</p>
<p><code>V</code> contains:</p>
<ol>
<li>Wind speed (m/s)</li>
<li>Wind direction</li>
</ol>

<p><u><b>Known limits / Use precautions</b></u></p>
<p>Warning, the selected convention of wind direction (0° -North, 90° -East, 180° - South, 270 ° -West) must be respected in the weather file!</p>
<p>Moreover it is not the same convention as for the walls (0 ° - South -90 - East 90 - West 180 - North).</p>
<p>Pay aslo attention to the wind direction definition: it is the cardinal point of the wind origin.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Aurélie Kaemmerlen 03/2011 : Ajout de la paramétrisation de la moyenne des flux mesurés (Booléen MoyFlux), du choix des flux en entrée et de l'orientation supplémentaire par rapport au Sud</p>
<p>Aurélie Kaemmerlen 05/2011 : Vecteur Gh de dimension 9 (anciennement 6) pour ajouter les entrées CoupleFlux, MoyFlux et dt</p>
<p>Hassan Bouia 03/2013 : simplication du calcul solaire - attention nouvelle dimension du vecteur <b>Gh</b> renommé en <b>G</b></p>
<p>Aurélie Kaemmerlen 10/2013 : Ajout de sécurités quant au paramétrage entre le vecteur azim et le paramètre beta + équation conditionnelle ajoutée pour s'assurer de azim par défaut si on renseigne beta.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}},
        grid={1,1},
        initialScale=0.1), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}},
        grid={1,1},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-96,-54},{-20,-80}},
          lineColor={0,0,255},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-96,-54},{-54,-40},{21,-40},{-20,-54},{-96,-54}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{21,-40},{21,-66},{-20,-80},{-20,-54},{21,-40}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-73,61},{38,1}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-63,71},{48,11}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-53,81},{58,21}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-43,91},{68,31}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-113,22},{-2,-38}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-103,32},{8,-28}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-93,42},{18,-18}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-83,52},{28,-8}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dot)}));
end ZoneWind;
