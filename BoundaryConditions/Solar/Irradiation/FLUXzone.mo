within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model FLUXzone
  "Calcul de l'éclairement incident diffus et direct incident au temps t sur un local avec ses 4 parois selon les points cardinaux"

parameter Real albedo=0.2 "Albedo de l'environnement";
parameter Boolean ChoixAzimuth=false
    "Choix de rentrer soit une correction fixe d'azimuth ou directement les valeurs dans un vecteur"
    annotation(choices(choice=true "Renseigner le vecteur azim", choice=false
        "renseigner beta",                                                                       radioButtons=true));
parameter Real beta=0
    "Correction de l'azimut des murs verticaux telle que azimut=beta+azimut, {beta=0 : N=180,S=0,E=-90,O=90})"
    annotation(dialog(enable=not ChoixAzimuth));
parameter Real azim[5]={0,beta+180,beta,beta-90,beta+90}
    "Azimuth des parois en sortie, par défaut 1-Plafond, 2-Nord, 3-Sud, 4-Est, 5-Ouest "
      annotation(dialog(enable=ChoixAzimuth));
parameter Real incl[5]={0,90,90,90,90}
    "Inclinaison des parois - par défaut 1-Plafond, 2-Nord, 3-Sud, 4-Est, 5-Ouest";
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FLUXNord[3]
    "Flux solaires surfaciques incidents au Nord 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{80,31},{118,69}}, rotation=0),
        iconTransformation(extent={{100,32},{120,52}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FLUXSud[3]
    "Flux solaires surfaciques incidents au Sud 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{80,-9},{118,29}}, rotation=0),
        iconTransformation(extent={{100,-6},{120,14}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FLUXPlafond[3]
    "Flux solaires surfaciques incidents au Plafond 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{81,62},{118,99}}, rotation=0),
        iconTransformation(extent={{100,74},{120,94}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FLUXEst[3]
    "Flux solaires surfaciques incidents à l'Est 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{81,-49},{118,-12}}, rotation=
            0), iconTransformation(extent={{100,-46},{120,-26}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FLUXouest[3]
    "Flux solaires surfaciques incidents à l'Ouest 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{80,-89},{118,-51}}, rotation=
            0), iconTransformation(extent={{100,-86},{120,-66}})));

Modelica.Blocks.Interfaces.RealInput G[10]
    "Résultats : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut,Hauteur}"
    annotation (Placement(transformation(extent={{-139,-31},{-99,9}},
        rotation=0), iconTransformation(extent={{-119,-11},{-99,9}})));

  Modelica.SIunits.HeatFlux DIRH;
  Modelica.SIunits.HeatFlux DIRN;
  Modelica.SIunits.HeatFlux GLOH;
  Modelica.SIunits.HeatFlux DIFH;
  Real FLUX[15];
  Real DiffusSol[5];
  output Real sinh;
  output Real cosi[5];
protected
  parameter Real azim_in[5]=if ChoixAzimuth then azim[1:5] else {0,beta+180,beta,beta-90,beta+90};
  constant Real d2r=Modelica.Constants.pi/180;
  final parameter Real s[5]={incl[i]*d2r for i in 1:5} "Inclinaison";
  final parameter Real g[5]={azim_in[i]*d2r  for i in 1:5} "Orientation";
  final parameter Real coef1[5]={0.5*(1 - cos(s[i]))*albedo for i in 1:5};
  final parameter Real coef2[5]={0.5*(1 + cos(s[i])) for i in 1:5};
  // Cosinus directeurs du plan
  final parameter Real l[5]={cos(s[i]) for i in 1:5};
  final parameter Real m[5]={sin(s[i])*sin(g[i]) for i in 1:5};
  final parameter Real n[5]={sin(s[i])*cos(g[i]) for i in 1:5};

  Real Idn "Rayonnement solaire direct normal";
  Real Idi "Rayonnement solaire diffus horizontal isotrope";
  Real Edn "Eclairement naturel direct normal";
  Real Edi "Eclairement naturel diffus horizontal";
  Real gamma "Hauteur angulaire du soleil au-dessus de l'horizon (radians)";
  Real pi=Modelica.Constants.pi;
  Real phi "Azimut du soleil (angle du soleil par rapport au Sud) (radians)";
  Real teta[5] "Angle entre le soleil et la normale à la surface étudiée";
  Real Erp[5]
    "Eclairement direct incident dépendant de la surface considérée(Lux)";
  Real Efp[5] "Eclairement diffus incident (Lux)";
  Real ERrp[5] "Eclairement réfléchi par le sol (Lux)";

public
  Modelica.Blocks.Interfaces.RealOutput EclSud[3]
    "Eclairement naturel incident au Sud -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{-20,-15},{26,31}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,110})));
  Modelica.Blocks.Interfaces.RealOutput EclNord[3]
    "Eclairement naturel incident au Nord -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{-20,45},{26,91}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,110})));
  Modelica.Blocks.Interfaces.RealOutput EclOuest[3]
    "Eclairement naturel incident à l'Ouest -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{-20,-45},{26,1}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,110})));
  Modelica.Blocks.Interfaces.RealOutput EclEst[3]
    "Eclairement naturel incident à l'Est -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{-20,-75},{26,-29}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealOutput EclPlafond[3]
    "Eclairement naturel incident au Plafond -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{-20,15},{26,61}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,110})));

algorithm
  // Calcul des sinh et cosi
  sinh :=G[6];  //Premier cosinus directeur du vecteur solaire
  cosi:={max(0, l[i]*G[6] + m[i]*G[7] + n[i]*G[8]) for i in 1:5};

//equation
//// CALCUL DES FLUX
// Calcul du flux direct : on vérifie que le soleil est couché sur la surface d'orientation choisie : si sin h est négatif, on annule les flux directs"
//  {DIFH,DIRN,DIRH,GLOH}=G[1:4];
  DIFH:=G[1];
  DIRN:=G[2];
  DIRH:=G[3];
  GLOH:=G[4];

 for i in 1:5 loop
   // Vecteur FLUX sur une surface inclinée en sortie : diffus, direct, cosi
   DiffusSol[i] :=max(0, coef1[i]*GLOH);
   FLUX[3*i-2] :=max(0, coef2[i]*DIFH) + DiffusSol[i];
   FLUX[3*i-1] :=if noEvent(sinh > 0.01) then max(0, cosi[i])*DIRN else 0; //Pour éviter les cas où le flux direct est non nul alors que le soleil est couché !
   FLUX[3*i] :=cosi[i];
 end for;
 FLUXPlafond:=FLUX[1:3];
 FLUXNord:=FLUX[4:6];
 FLUXSud:=FLUX[7:9];
 FLUXEst:=FLUX[10:12];
 FLUXouest:=FLUX[13:15];

equation

 //Calcul des éclairement naturels (équations RT2012)
  Idn=DIRN;
  Idi=DIFH;
  gamma=G[10]*pi/180;
  Edn=Idn*(-1.0375321*10^(-8)*gamma^6+2.90312257*10^(-6)*gamma^5-3.31804423*10^(-4)*gamma^4+1.99283162*10^(-2)*gamma^3-6.72171072*10^(-1)*gamma^2+1.24650445*10*gamma+2.38954889);
  if Idn<1 then
    Edi=124*Idi;
  else if Idn>120 then
        Edi=128*Idi;
  else Edi=116*Idi;
  end if;
  end if;

algorithm

// Calcul de l'éclairement naturel direct, diffus et réfléchi par le sol sans masque
  phi:=G[9]*pi/180;
  for i in 1:5 loop
  teta[i]:=min(pi/2, acos(cos(gamma)*sin(incl[i]*pi/180)*cos(phi - azim[i]*pi/180)+ sin(gamma)*cos(incl[i]*pi/180)));
  Erp[i]:=cos(teta[i])*Edn;
  Efp[i]:=Edi*0.5*(1 + cos(incl[i]*pi/180));
  ERrp[i]:=(Edn*sin(gamma) + Edi)*albedo*0.5*(1 - abs(cos(incl[i]*pi/180)));
  end for;

 EclPlafond:={Erp[1],Efp[1],ERrp[1]};
 EclNord:={Erp[2],Efp[2],ERrp[2]};
 EclSud:={Erp[3],Efp[3],ERrp[3]};
 EclEst:={Erp[4],Efp[4],ERrp[4]};
 EclOuest:={Erp[5],Efp[5],ERrp[5]};

annotation (Documentation(info="<html>
<p>Modèle qui prend en entrée le vecteur<b> G</b> issu d'un lecteur météo, avec comme base de temps le <b>Temps Universel</b>, pour calculer les éclairements surfaciques sur cinq parois inclinées d'un local (Plafond, Sud, Est, Ouest, Nord). <b>G</b> contient :</p>
<p>(1) Flux diffus horizontale</p>
<p>(2) Flux direct normal</p>
<p>(3) Flux direct horizontal</p>
<p>(4) Flux global horizontal</p>
<p>(5) Heure en TU au temps t = 0 (début de simulation)</p>
<p>(6-7-8) Cosinus directeurs du soleil (6-sinh, 7-cosW, 8-cosS)</p>
<p>(9) Azimut du soleil</p>
<p>(10) Hauteur du soleil</p>
<p>Modèle validé (identique à celui utilisé dans le BESTEST excepté la base de temps : TU au lieu de TSV) - Aurélie Kaemmerlen 09/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Aurélie Kaemmerlen 03/2011 : Ajout de la paramétrisation de la moyenne des flux mesurés (Booléen MoyFlux), du choix des flux en entrée et de l'orientation supplémentaire par rapport au Sud</p>
<p>Aurélie Kaemmerlen 05/2011 : Vecteur Gh de dimension 9 (anciennement 6) pour ajouter les entrées CoupleFlux, MoyFlux et dt</p>
<p>Hassan Bouia 03/2013 : simplication du calcul solaire - attention nouvelle dimension du vecteur <b>Gh</b> renommé en <b>G</b></p>
<p>Aurélie Kaemmerlen 10/2013 : Ajout de sécurités quant au paramétrage entre le vecteur azim et le paramètre beta + équation conditionnelle ajoutée pour s'assurer de azim par défaut si on renseigne beta.</p>
<p>Laura Sudries, Vincent Magnaudeix 05/2015 : Ajout du calcul des éclairements naturels direct, diffus et réfléchi par le sol sur chaque orientation du local.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}},
        grid={1,1},
        initialScale=0.1), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}},
        grid={1,1},
        initialScale=0.1), graphics={Ellipse(
          extent={{-89,90},{20,-20}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
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
          fillPattern=FillPattern.Solid)}),
              Icon(graphics),    Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end FLUXzone;
