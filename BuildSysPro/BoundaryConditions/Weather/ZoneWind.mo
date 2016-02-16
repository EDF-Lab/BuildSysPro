within BuildSysPro.BoundaryConditions.Weather;
model ZoneWind
  "Calcul du vent incident au temps t sur un local avec ses 4 parois selon les points cardinaux"

parameter Boolean ChoixAzimuth=false
    "Choix de rentrer soit une correction fixe d'azimuth ou directement les valeurs dans un vecteur"
    annotation(choices(choice=true "Renseigner le vecteur azim", choice=false
        "renseigner beta",                                                                       radioButtons=true));
parameter Real beta=0
    "Correction de l'azimut des murs verticaux telle que azimut=beta+azimut, {beta=0 : N=180,S=0,E=-90,O=90})"
    annotation(dialog(enable=not ChoixAzimuth));
parameter Real azim[4]={beta+180,beta,beta-90,beta+90}
    "Azimuth des parois en sortie, par défaut 1-Nord, 2-Sud, 3-Est, 4-Ouest "
      annotation(dialog(enable=ChoixAzimuth));
  parameter Real incl[4]={90,90,90,90}
    "Inclinaison des parois - par défaut 1-Nord, 2-Sud, 3-Est, 4-Ouest";

Modelica.Blocks.Interfaces.RealOutput VENTNord
    "Vent incident sur la façade Nord (m/s)" annotation (Placement(
        transformation(extent={{80,31},{118,69}}, rotation=0),
        iconTransformation(extent={{100,32},{120,52}})));

Modelica.Blocks.Interfaces.RealOutput VENTSud
    "Vent incident sur la façade Sud (m/s)" annotation (Placement(
        transformation(extent={{80,-9},{118,29}}, rotation=0),
        iconTransformation(extent={{100,-6},{120,14}})));
Modelica.Blocks.Interfaces.RealOutput VENTEst
    "Vent incident sur la façade Est (m/s)" annotation (Placement(
        transformation(extent={{81,-49},{118,-12}}, rotation=0),
        iconTransformation(extent={{100,-46},{120,-26}})));
Modelica.Blocks.Interfaces.RealOutput VENTOuest
    "Vent incident sur la façade Ouest (m/s)" annotation (Placement(
        transformation(extent={{80,-89},{118,-51}}, rotation=0),
        iconTransformation(extent={{100,-86},{120,-66}})));

Modelica.Blocks.Interfaces.RealInput V[2]
    "1- vitesse du vent (m/s) 2- direction du vent (0- Nord, 90 - Est, 180 - Sud, 270 - Ouest)"
    annotation (Placement(transformation(extent={{-139,-31},{-99,9}}, rotation=0),
        iconTransformation(extent={{-119,-11},{-99,9}})));

protected
  parameter Real azim_in[4]=if ChoixAzimuth then azim[1:4] else {beta+180,beta,beta-90,beta+90};
  constant Real d2r=Modelica.Constants.pi/180;

algorithm
  //Calcul des vitesses de vent normales aux parois
VENTNord:=max(0,cos((V[2]+180-azim_in[1])*d2r))*V[1];
VENTSud:=max(0,cos((V[2]+180-azim_in[2])*d2r))*V[1];
VENTEst:=max(0,cos((V[2]+180-azim_in[3])*d2r))*V[1];
VENTOuest:=max(0,cos((V[2]+180-azim_in[4])*d2r))*V[1];
annotation (Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle permet de calculer le vent incident sur quatre parois inclinées (par défaut verticales) d'un local (Nord, Sud, Est, Ouest).</p>
<p><u><b>Bibliographie</b></u></p>
<p>Néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Modèle qui prend en entrée le vecteur<b> V</b> issu d'un lecteur météo, avec comme base de temps le <b>Temps Universel</b>, pour calculer le vent incident sur quatre parois inclinées (par défaut verticales) d'un local (Nord, Sud, Est, Ouest). V contient :</p>
<p>(1) Vitesse du vent (m/s)</p>
<p>(2) Direction du vent</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Attention il faut que les conventions choisies de direction du vent (0&deg;-Nord, 90&deg;-Est, 180&deg; - Sud, 270&deg;-Ouest ) soient respectées dans le fichier météo ! D'ailleurs <b>ce ne sont pas les mêmes conventions que pour les parois</b> (0&deg;- Sud , -90&deg; - Est, 90&deg; - Ouest, 180&deg; - Nord). </p>
<p>Attention aussi sur la définition de la direction du vent : il s'agit du point cardinal de <u>provenance</u> du vent.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 04/2014</p>
<p><i><b>ATTENTION : validation du modèle uniquement et pas du contenu des fichiers météos notamment les conventions de direction du vent</b></i></p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
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
          pattern=LinePattern.Dot)}),
              Icon(graphics),    Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end ZoneWind;
