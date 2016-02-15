within BuildSysPro.BoundaryConditions.Solar.Irradiation;
model FLUXsurf
  "Calcul de l'éclairement incident diffus et direct incident au temps t sur une surface inclinée avec choix des flux donnés en entrée"

parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°";
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°";
parameter Boolean use_Albedo_in=false "Albedo variable"
  annotation(choices(choice=true "oui", choice=false "non (constant)",radioButtons=true));
parameter Real albedo=0.2 "Albedo de l'environnement" annotation(Dialog(enable=not use_Albedo_in));
parameter Integer diffus_isotrope=1
    "1 - modèle de diffus isotrope ; 2 - modèle de diffus circumsolaire (Hay Davies Kluch Reindl)"
    annotation (dialog(
      compact=true), choices(
      choice=1 "Diffus isotrope",
      choice=0 "Diffus HDKR (prise en compte du circumsolaire)",
      radioButtons=true));

// Paramétrisation du modèle : choix du type de temps, de l'intervalle temporel de mesure des flux et des flux donnés en entrée

Modelica.SIunits.HeatFlux DIRH;
Modelica.SIunits.HeatFlux DIRN;
Modelica.SIunits.HeatFlux GLOH;
Modelica.SIunits.HeatFlux DIFH;

Modelica.SIunits.HeatFlux DiffusSol
    "Partie du rayonnement incident diffus provenant de la réflexion sur le sol";

output Real sinh;
output Real cosi;

Modelica.Blocks.Interfaces.RealInput G[10]
    "Résultats : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut,Hauteur}"
    annotation (Placement(transformation(extent={{-140,-30},{-100,
        10}},
        rotation=0), iconTransformation(extent={{-120,-10},{-100,10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FLUX[3]
    "Flux solaires surfaciques incidents 1-Flux Diffus, 2-Flux Direct et 3-Cosi"
    annotation (Placement(transformation(extent={{83,-26},{117,8}}, rotation=0),
        iconTransformation(extent={{100,-11},{120,9}})));
  Modelica.Blocks.Interfaces.RealOutput AzHSol[3] "Azim, Haut, DiffuSol"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
/*Modelica.Blocks.Interfaces.RealInput AzHaut[2] "{Azimut,Hauteur} du Soleil"
    annotation (Placement(transformation(extent={{-140,11},{-100,51}},
        rotation=0), iconTransformation(extent={{-120,-80},{-100,-60}})));*/
Modelica.Blocks.Interfaces.RealInput Albedo_in if use_Albedo_in "Albédo"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
        rotation=0), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));

// Connecteur interne
protected
  Modelica.Blocks.Interfaces.RealInput Albedo_in_internal
    "Connecteur interne requis dans le cas de connection conditionnelle";
  constant Real d2r=Modelica.Constants.pi/180;
  constant Modelica.SIunits.HeatFlux Isc=1367 "constante solaire";
  final parameter Real coef1=0.5*(1 - cos(incl*d2r));
  final parameter Real coef2=0.5*(1 + cos(incl*d2r));
  final parameter Real coef3=sin(incl*d2r/2)^3;
  final parameter Real s=incl*d2r "Inclinaison";
  final parameter Real g=azimut*d2r "Orientation";
  // Cosinus directeurs du plan
  final parameter Real l=cos(s);
  final parameter Real m=sin(s)*sin(g);
  final parameter Real n=sin(s)*cos(g);
  //cosi:=max(0,{l,m,n}*CosDir);
  // Pour le modèle HDKR
  Real AI "indexe d'anisotropie";
  Real f "facteur de correction pour l'éclairement de l'horizon";
  Modelica.SIunits.HeatFlux I0
    "éclairement extraterrestre sur une surface horizontale (hors atmosphère)";

algorithm
  // Calcul des sinh et cosi
  sinh := G[6]; //Premier cosinus directeur du vecteur solaire
  cosi :=max(0,l*G[6]+m*G[7]+n*G[8]);
  // Calcul des paramètres pour la modélisation du diffus selon le modèle HDKR
  I0 :=max(0, Isc*(1 + 0.033*cos(360*(floor((time + G[5])/86400) + 1)/365))*
    sinh);
  AI :=if noEvent(sinh > 0) then DIRH/I0 else 0;
  f :=if noEvent(DIRH > 0 and GLOH > 0) then sqrt(DIRH/GLOH) else 0;

equation

connect(Albedo_in, Albedo_in_internal);
  if not use_Albedo_in then
    Albedo_in_internal=albedo;
  end if;
//// CALCUL DES FLUX
 // Calcul du flux direct : on vérifie que le soleil est couché sur la surface d'orientation choisie : si sin h est négatif, on annule les flux directs"
  {DIFH,DIRN,DIRH,GLOH}=G[1:4];

 // Vecteur FLUX sur une surface inclinée en sortie : diffus, direct, cosi
   DiffusSol = max(0, coef1*GLOH*Albedo_in_internal);
   FLUX[1] = if diffus_isotrope == 1 then max(0, coef2*DIFH) + DiffusSol else
    max(0, coef2*(1 - AI)*(1 + f*coef3)*DIFH) + DiffusSol;
   FLUX[2] = if noEvent(sinh > 0.01) then (if diffus_isotrope == 1 then max(0,
    cosi)*max(0,DIRN) else max(0, cosi)*max(0,DIRN) + max(0, AI*cosi*DIFH/sinh)) else 0;
   //Pour éviter les cas où le flux direct est non nul alors que le soleil est couché !
   FLUX[3] = cosi;
 //FLUX[4] = FLUX[1]+FLUX[2];

  //AzHSol[1] = AzHaut[1];
  //AzHSol[2] = AzHaut[2];
  AzHSol[1] = G[9];
  AzHSol[2] = G[10];
  AzHSol[3] = DiffusSol;

annotation (Documentation(info="<html>
<p>Modèle qui prend en entrée le vecteur<b> G</b> issu d'un lecteur météo pour calculer l'éclairement surfacique sur une paroi inclinée (Azimuth et inclinaison données). <b>G</b> contient :</p>
<p>(1) Flux diffus horizontal</p>
<p>(2) Flux direct normal</p>
<p>(3) Flux direct horizontal</p>
<p>(4) Flux global horizontal</p>
<p>(5) Heure en TU au temps t = 0 (début de simulation)</p>
<p>(6-7-8) Cosinus directeurs du soleil (6-sinh, 7-cosW, 8-cosS)</p>
<p>(9) Azimut du soleil</p>
<p>(10) Hauteur du soleil</p>
<p><b>Nouveauté !</b> Il est possible de choisir quel modèle de diffus utiliser. Le modèle diffus isotrope est considéré plus conservateur (tendance à sous-estimer le rayonnement incident sur un plan incliné) mais est plus simple d'utilisation. Le modèle diffus Hay Davies Klucher Reindl (HDKR) est à privilégier dans les applications solaires (photovolta&iuml;que, solaire thermique...).</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Dans le modèle de diffus isotrope, le rayonnement total sur une surface inclinée est donné par :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/diffus_isotrope.png\" alt=\"FLUX_tot=cos(incidence)*FLUX_DIRN+(1+cos(inclinaison))/2*FLUX_DIFH+(1-cos(inclinaison))/2*albedo*FLUX_GLOH\"/></p>
<p><br>Dans le modèle HDKR (Hay, Davies, Klucher, Reindl), le rayonnement total sur une surface inclinée est donné par :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/diffus_HDKR.png\"/></p>
<p>où</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/AI_HDKR.png\"/>,</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/f_HDKR.png\"/>,</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/GLOH_extraterrestre.png\"/> où n est le quantième du jour et Isc la constante solaire (nous prendrons dans ce modèle Isc=1367 W/m&sup2;)</p>
<p><u><b>Remarques : </b></u>Ce modèle remplace le modèle EclairementTouteSurfaceFDIRN avec séparation des calculs propres aux vitrages/parois (transmission et absorption notamment) avec ajout de paramétres supplémentaires permetant son utilisation dans différents cas :</p>
<ul>
<li>En entrée, sont donnés 2 flux solaires parmi les choix suivants : &QUOT;GLOH DIFH&QUOT;, &QUOT;DIRN DIFH&QUOT;, &QUOT;DIFH DIRH&QUOT;, &QUOT;GLOH DIRH&QUOT; et &QUOT;GLOH DIRN&QUOT;.</li>
<li>On peut ainsi indiquer si les données de flux solaires sont des moyennes sur l'heure écoulée (on prend donc le milieu de l'heure pour effectuer les calculs de hauteur du soleil, de déclinaison, etc...) et on peut modifier l'intervalle de temps correspondant (par défaut il s'agit de données horaires).</li>
</ul>
<p><u><b>Bibliographie</b></u></p>
<p>Solar Engineering of Thermal processes, Duffie & Beckmann, Wiley, 2006, pp. 90-93</p>
<p>Modèle validé - Aurélie Kaemmerlen 02/2011</p>
<ol>
<li>Validation du modèle similaire développé pour BESTEST (temps en TSV) et les flux DIRH et GLOH en entrée : vérification avec TRNSYSv16 : lecture du TMY avec le Type89i et calcul des flux incidents avec le Type16g</li>
<li>Validation analytique (Via calculs sous Excel) menée sur le paramétrage du modèle : type de temps, de moyenne et de flux considérés</li>
</ol>
<p>Amy Lindsay 03/2013 validation du modèle de diffus HDKR sur données d'ensoleillement à PV ZEN</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 :</p>
<p><ul>
<li>Ajout de la paramétrisation de la moyenne des flux mesurés (Booléen MoyFlux) et du choix des flux en entrée</li>
<li>Correction dans le calcul du cosi : il manquait le paramètre h0 !</li>
</ul></p>
<p><br>Aurélie Kaemmerlen 05/2011 : </p>
<p><ul>
<li>Ajout de sorties : hauteur et azimut du soleil, Rayonnement incident diffus provenant du sol</li>
<li>Vecteur Gh de dimension 9 (anciennement 6) pour ajouter les entrées CoupleFlux, MoyFlux et dt</li>
<li>Ajout d'une sécurité pour éviter un flux direct infini : sinh&GT;0.01 au lieu de &GT;0 pour le calcul de FDIRN/FDIRH</li>
</ul></p>
<p><br>Hassan Bouia 03/2013 : Simplication du calcul solaire - attention nouvelle dimension du vecteur <b>Gh</b> renommé en <b>G</b></p>
<p>Amy Lindsay 03/2013 : Ajout du paramètre diffus_isotrope pour choisir entre un modèle de diffus isotrope ou le modèle de diffus HDKR</p>
<p>Aurélie Kaemmerlen 09/2013 : Ajout du choix de mettre un albédo variable (mesures BESTLAB par exemple) et ajout d'un max entre 0 et DIRN pour éviter les valeurs négatives au lever-coucher de soleil</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}},
        grid={1,1},
        initialScale=0.1), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}},
        grid={1,1},
        initialScale=0.1), graphics={
        Ellipse(
          extent={{-92,81},{41,-53}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-83},{100,-23},{100,-42},{-100,-100},{-100,-83}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,104},{98,51}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Az = %azimut °"),
        Text(
          extent={{-125,65},{126,14}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="Incl = %incl °")}),
              Icon(graphics),    Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end FLUXsurf;
