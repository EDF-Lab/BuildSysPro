within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
model Masks "Modèle de masques solaires proches et lointain pour une météo"

// Paramètres propres au masque
parameter Boolean useEclairement=false
annotation(dialog(compact=true),choices(choice=true
        "Avec calcul de l'éclairement naturel",                                                             choice=false
        "Sans calcul de l'éclairement naturel",                                                                                                  radioButtons=true));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°";
parameter Integer TypeMasque annotation(Dialog(tab="Masques proches"),choices(choice=0
        "Masque intégral",                                                                                choice=1
        "Masque horizontal",choice=2 "Pas de masque proche", radioButtons=true));
parameter Modelica.SIunits.Distance Av=0.5 "Avancée" annotation(Dialog(enable=TypeMasque<>2,tab="Masques proches"));
parameter Modelica.SIunits.Distance Ha=0.3
    "Distance de l'auvent au rebord haut de la fenêtre" annotation(Dialog(enable=TypeMasque<>2,tab="Masques proches"));
parameter Modelica.SIunits.Distance Lf=1 "Largeur de la fenêtre" annotation(Dialog(enable=TypeMasque<>2,tab="Masques proches"));
parameter Modelica.SIunits.Distance Hf=1 "Hauteur de la fenêtre" annotation(Dialog(enable=TypeMasque<>2,tab="Masques proches"));
parameter Modelica.SIunits.Distance Dd=0.5 "Distance ou débord droit" annotation(Dialog(enable=TypeMasque<>2,tab="Masques proches"));
parameter Modelica.SIunits.Distance Dg=0.5 "Distance ou débord gauche" annotation(Dialog(enable=TypeMasque<>2,tab="Masques proches"));

parameter Boolean MasqueLointain=false
annotation(dialog(tab="Masques lointains",compact=true),choices(choice=true
        "Avec masque lointain vertical",                                                             choice=false
        "Sans masque lointain vertical",                                                                                                  radioButtons=true));
parameter Modelica.SIunits.Distance dE=5
    "Distance de la paroi au masque lointain" annotation(Dialog(enable=MasqueLointain,tab="Masques lointains"));
parameter Modelica.SIunits.Distance hpE=2 "Hauteur du masque lointain" annotation(Dialog(enable=MasqueLointain,tab="Masques lointains"));

Modelica.SIunits.Conversions.NonSIunits.Angle_deg AzimutSoleil
    "Azimut du soleil en degrés";
Modelica.SIunits.Conversions.NonSIunits.Angle_deg HauteurSoleil
    "Hauteur du soleil";
Modelica.SIunits.HeatFlux DiffusSol
    "Partie du rayonnement incident diffus provenant de la réflexion sur le sol";
output Real FacMasqueDir
    "Facteur de masque proche pour les flux directs (ce sont les mêmes pour le flux thermique et celui lumineux)";
output Real FacMasqueDif
    "Facteur de masque proche pour les flux diffus (ce sont les mêmes pour le flux thermique et celui lumineux)";
output Real FE_dir
    "Facteur d'affaiblissement du rayonnement solaire direct dû à un masque lointain vertical";

Modelica.SIunits.Area A0 "Surface ensoleillée de la fenêtre";

Real pi=Modelica.Constants.pi;

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxMasques[3]
    "Flux solaires surfaciques incidents après prise en compte de masques solaires au vitrage 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{30,-20},{70,20}}, rotation=0),
        iconTransformation(extent={{100,-12},{124,12}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUX[3]
    "Flux solaires surfaciques incidents 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{-77,-18},{-43,16}}, rotation=
            0), iconTransformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealInput AzHSol[3]
    "Données d'ensoleillement : 1-Azimut et 2-Hauteur du soleil, 3-Flux incident provenant du sol "
                                                                                                     annotation (Placement(transformation(
          extent={{-99,19},{-59,59}}), iconTransformation(extent={{-100,23},{-86,
            37}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Eclairement naturel incident: direct, diffus et réfléchi (lumen)"                              annotation (Placement(transformation(
          extent={{-80,-51},{-40,-11}}),
                                       iconTransformation(extent={{-100,-37},{-86,
            -23}})));
  Modelica.Blocks.Interfaces.RealOutput EclMasques[3] if useEclairement
    "Eclairement naturel incident après la prise en compte des masques -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{50,-57},{84,-23}}),
        iconTransformation(extent={{70,-37},{84,-23}})));
  Modelica.Blocks.Sources.RealExpression CalculEclMasques[3](y={Ecl[1]*
        FacMasqueDir*FE_dir,Ecl[2]*FacMasqueDif,Ecl[3]}) if              useEclairement
    "Vecteur éclairements lumineux avec masque proche: direct, diffus, réfléchi"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
algorithm

AzimutSoleil:=AzHSol[1];
HauteurSoleil:=AzHSol[2];
DiffusSol:=AzHSol[3];

if TypeMasque==0 then

  //Masque intégral
  if noEvent(abs(azimut-AzimutSoleil)>=90) or (noEvent(HauteurSoleil<=0)) then
      A0:=0;
  else
      A0 :=BuildSysPro.BoundaryConditions.Solar.SolarMasks.FullMask(
        Av=Av,
        Ha=Ha,
        Lf=Lf,
        Hf=Hf,
        Dd=Dd,
        Dg=Dg,
        AzimutSoleil=AzimutSoleil,
        HauteurSoleil=HauteurSoleil,
        azimut=azimut);
      FacMasqueDir:= A0/(Lf*Hf);
  end if;
  FacMasqueDif:=(Dd+Lf+Dg)*(Ha+Hf)/((Dd+Lf+Dg)*(Ha+Hf)+(Dd+Lf+Dg)*Av+2*(Hf+Ha)*Av);
else if TypeMasque==1 then
  //Masque horizontal
  if noEvent(abs(azimut-AzimutSoleil)>=90) or (noEvent(HauteurSoleil<=0)) then
      A0:=0;
  else
      A0 :=BuildSysPro.BoundaryConditions.Solar.SolarMasks.HorizontalMask(
          Av=Av,
          Ha=Ha,
          Lf=Lf,
          Hf=Hf,
          Dd=Dd,
          Dg=Dg,
          AzimutSoleil=AzimutSoleil,
          HauteurSoleil=HauteurSoleil,
          azimut=azimut);
      FacMasqueDir:= A0/(Lf*Hf);
     //FacMasqueDir:= min(max(0,1-(max(0,Av*tan(HauteurSoleil*Convert)/cos((AzimutSoleil-azimut)*Convert))-Ha)/Hf),1); //Formule RT2012
  end if;
  FacMasqueDif:=((Dd+Lf+Dg)*(Ha+Hf)+2*Av*(Ha+Hf))/((Dd+Lf+Dg)*(Ha+Hf)+(Dd+Lf+Dg)*Av+2*(Hf+Ha)*Av);
  //FacMasqueDif:=(2/Modelica.Constants.pi)*atan((Ha+Hf/2)/Av); //Formule RT2012
else
  FacMasqueDir:=1;
  FacMasqueDif:=1;
end if;
end if;

//Masque lointain défini par un plan vertical
if MasqueLointain==true and cos((AzimutSoleil-azimut)*pi/180)>10^(-5) then //si masque lointain et entrée du soleil dans le plan concerné
       if hpE>0 then
         if (dE*tan(HauteurSoleil*pi/180)/cos((AzimutSoleil-azimut)*pi/180))>hpE then FE_dir:=1;else FE_dir:=0;end if;
    else FE_dir:=1;
    end if;
else FE_dir:=1;
       end if;

equation
// Vecteur FLUX sur un vitrage avec masque proche / en sortie : diffus, direct, cosi
 FluxMasques[1] = ((FLUX[1]-DiffusSol)*FacMasqueDif + DiffusSol);
 FluxMasques[2] = FacMasqueDir*FLUX[2]*FE_dir;
 FluxMasques[3] = FLUX[3];

  if useEclairement then
    connect(CalculEclMasques.y, EclMasques) annotation (Line(
      points={{21,-30},{44,-30},{44,-40},{67,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
  annotation (Documentation(info="<html>
<h4>Modèle calculant les facteurs de masques architecturaux pour le rayonnement direct et diffus</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Les masques considérés sont :</p>
<ol>
<li>Les masques proches</li>
<li><ol>
<li>Les auvents (arête horizontale)</li>
<li>Les masques complets (arête + joue gauche et droite)</li>
</ol></li>
</ol>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/MasqueHorizontal.bmp\"/> <img src=\"modelica://BuildSysPro/Resources/Images/MasqueIntegral.bmp\"/> </p>
<ol>
<li>Les masques lointains verticaux </li>
</ol>
<p><u><b>Bibliographie</b></u></p>
<p>Norme ISO 13791</p>
<p><i>Intégration de la protection solaire dans le logiciel PAPTER</i>, M. ABDESSELAM, AIRab Consultant, Fevrier 2000 - Corrections effectuées car modèle incorrect</p>
<p>Norme RT2012 pour la prise en compte des masques lointains verticaux</p>
<p><u><b>Mode d'emploi</b></u></p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b> </u></p>
<ul>
<li>Ces modèles ne sont valables que pour des parois verticales</li>
<li>Le cumul de plusieurs types de masques proches pour une même paroi est interdit</li>
</ul>
<p><br><u><b>Validations effectuées</b></u></p>
<p>Modèle validé pour les masques proches (selon la norme ISO13791-2004 et BESTEST) - Aurélie Kaemmerlen 05/2011</p>
<p>Modèle non validé pour les masques lointains - Laura Sudries 05/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 04/2013 : Ajout d'une condition sur la hauteur du soleil pour le calcul de la surface ensoleillée. Fait suite à la correction des flux solaires (calcul de l'azimut corrigé - avant il n'était pas déterminé si sinh&LT;=0)</p>
<p>Laura Sudries, Vincent Magnaudeix 05/2015 : Ajout de la prise en compte des masques lointains verticaux</p>
<p>Benoît Charrier 05/2015 : Ajout du choix possible de prise en compte ou non des masques lointains verticaux</p>
<p>Benoît Charrier 05/2015 : Correction sur le facteur d'affaiblissement du rayonnement solaire direct dû à un masque lointain vertical, qui était appliqué par erreur au rayonnement diffus.</p>
</html>"), Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,60}},
        grid={1,1}),
                graphics={
        Polygon(
          points={{56,34},{-44,34},{-44,-26},{56,-26},{56,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-44,-26},{-44,-26},{-54,-36},{-8,-26},{-44,-26}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-8,8},{56,-26}},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{56,34},{46,24},{46,-36},{56,-26},{56,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,34},{-54,24},{-54,-36},{-44,-26},{-44,34}},
          smooth=Smooth.None,
          fillColor={189,173,130},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Polygon(
          points={{-44,34},{-54,24},{46,24},{56,34},{-44,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-44,-26},{46,24}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-22,14},{24,-14}},
          fillColor={139,175,208},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-8,8},{24,-14}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,60}},
        grid={1,1}),
            graphics));
end Masks;
