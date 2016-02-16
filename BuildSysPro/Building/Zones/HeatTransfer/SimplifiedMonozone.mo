within BuildSysPro.Building.Zones.HeatTransfer;
model SimplifiedMonozone
  "Modèle monozone simplifié à Ubat et inertie réglable."

// Propriétés générales
parameter Modelica.SIunits.CoefficientOfHeatTransfer Ubat
    "Ubat : Déperditions  surfacique par transmission" annotation(dialog(group="Paramètres globaux"));
parameter Integer NbNiveau=1 "Nombre de niveaux, minimum = 1" annotation(dialog(group="Paramètres globaux"));
parameter Modelica.SIunits.Volume Vair=240 "Volume d'air" annotation(dialog(group="Paramètres globaux"));
parameter Modelica.SIunits.Area SH=100 "Surface habitable" annotation(dialog(group="Paramètres globaux"));
parameter Real renouv(unit="1/h") "Débit de ventilation et/ou d'infiltrations"
                                                                            annotation(dialog(group="Paramètres globaux"));

// Propriétés vitrages
parameter Modelica.SIunits.Area SurfaceVitree "Surface vitrée totale"
                                 annotation(dialog(group="Vitrage"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer k
    "Conductivité thermique du vitrage" annotation(dialog(group="Vitrage"));
parameter Real skyViewFactorWindows
    "Facteur de forme moyen entre les vitrages et le ciel (exemple: skyViewFactor(toiture terrase)=1, skyViewfactor(paroi verticale en environnement dégagé)=0.5)"
                                                                                                        annotation(dialog(group="Vitrage"));
parameter Real Tr=0.544 "Coefficient de transmission des vitrages" annotation(dialog(group="Vitrage"));
parameter Real AbsVitrage=0.1 "Coefficient d'absorption des vitrages" annotation(dialog(group="Vitrage"));
parameter Real epsWindows=0.9 "Emissivité" annotation(dialog(group="Vitrage"));

// Paramètres des parois
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraParoiExt
    "Paramètres des parois verticales"
    annotation (__Dymola_choicesAllMatching=true, dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_paroiExt=18
    "Coefficient d'échange surfacique CONVECTIF sur la face extérieure des parois extérieures"
                                                                                    annotation(dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_paroiExt=7.7
    "Coefficient d'échange surfacique GLOBAL sur la face intérieure des parois extérieures"
                                                                                   annotation(dialog(group="Parois"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraPlancher
    "Paramètres du plancher"
    annotation (__Dymola_choicesAllMatching=true, dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_Plancher=5.88
    "Coefficient d'échange surfacique GLOBAL sur la face inférieure des planchers"
                                                                                     annotation(dialog(group="Parois"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_Plancher=5.88
    "Coefficient d'échange surfacique GLOBAL sur la face supérieure des planchers"
                                                                                   annotation(dialog(group="Parois"));
parameter Real b=0.1
    "Coefficient de pondération des conditions limites règlementaires" annotation(dialog(group="Parois"));
parameter Real skyViewFactorParois
    "Facteur de forme moyen entre les parois et le ciel (exemple: skyViewFactor(toiture terrase)=1, skyViewfactor(paroi verticale en environnement dégagé)=0.5)"
                                                                                                        annotation(dialog(group="Parois"));
parameter Real AbsParois=0.6
    "Coefficient d'absorption des parois ext. dans le visible" annotation(dialog(group="Parois"));
parameter Real epsParois=0.7 "Emissivité des parois extérieures en GLO" annotation(dialog(group="Parois"));

// Initialisation
parameter Modelica.SIunits.Temperature Tinit=292.15
    "Température d'initialisation"
                                  annotation(dialog(tab="Initialisation"));

// Paramètres internes
protected
parameter Modelica.SIunits.Length hTotal=Vair*(NbNiveau/SH)
    "Hauteur totale du bâtiment";
parameter Modelica.SIunits.Area Sdeper=4*hTotal*sqrt(SH/NbNiveau)+2*Splancher
    "Surface déperditive totale";
parameter Modelica.SIunits.Area Swin=SurfaceVitree
    "Surface déperditive des parois vitrées";
parameter Modelica.SIunits.Area Sop=Sdeper-Swin
    "Surface déperditive des parois opaques";
parameter Modelica.SIunits.Area Splancher=SH/NbNiveau
    "Surface déperditive du plancher";
parameter Modelica.SIunits.CoefficientOfHeatTransfer Uplancher=1/(sum(paraPlancher.e./paraPlancher.mat.lambda)+1/hs_ext_Plancher+1/hs_int_Plancher)
    "Uvalue du plancher";
parameter Modelica.SIunits.CoefficientOfHeatTransfer Ug= 1/(1/k+1/hs_ext_paroiExt+1/hs_int_paroiExt)
    "Uvalue des vitrages";

  // Résolution du système polynomiale d'ordre 1 pour trouver la valeur de alpha, coefficient multiplicateur des couches isolantes dans les parois verticales et le plafond.
parameter Real Anew=Ubat*Sdeper-Swin*Ug-b*Uplancher*Splancher
    "Décomposition du Ubat";
parameter Real coefN1=(Sop-Splancher);
parameter Real coefD1=sum(paraParoiExt.e./paraParoiExt.mat.lambda.*paraParoiExt.positionIsolant);
parameter Real coefD2=sum(paraParoiExt.e./paraParoiExt.mat.lambda.*(ones(paraParoiExt.n)-paraParoiExt.positionIsolant))+1/hs_ext_paroiExt+1/hs_int_paroiExt;

parameter Real alpha=(coefN1-Anew*coefD2)/(Anew*coefD1)
    "Coefficient multiplicateur des couches isolantes(parois extérieures)";

  // Calcul des valeurs extremes du Ubat
parameter Real Umin=(Swin*Ug+Uplancher*b*Splancher)/Sdeper
    "Valeur minimale de Ubat pour le type de plancher et de vitrage considéré";
parameter Real Umax=(Swin*Ug+Uplancher*b*Splancher+(Sop-Splancher)/(sum(paraParoiExt.e./paraParoiExt.mat.lambda.*(ones(paraParoiExt.n)-paraParoiExt.positionIsolant))+1/hs_ext_paroiExt+1/hs_int_paroiExt))/Sdeper
    "Valeur maximale de Ubat pour le type de paroi et vitrage considéré";

// Composants internes
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tinit)
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall paroiExt(
    caracParoi(
      n=paraParoiExt.n,
      mat=paraParoiExt.mat,
      m=paraParoiExt.m,
      e=paraParoiExt.e .* (ones(paraParoiExt.n) - paraParoiExt.positionIsolant)
           + alpha*paraParoiExt.e .* paraParoiExt.positionIsolant),
    Tp=Tinit,
    hs_ext=hs_ext_paroiExt,
    hs_int=hs_int_paroiExt,
    skyViewFactor=skyViewFactorParois,
    RadExterne=true,
    GLOext=true,
    S=Sop - Splancher,
    AbsParoi=AbsParois,
    eps=epsParois) "Parois extérieures"
    annotation (Placement(transformation(extent={{-8,36},{12,56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleGlazing vitrage(
    hs_ext=hs_ext_paroiExt,
    hs_int=hs_int_paroiExt,
    S=SurfaceVitree,
    skyViewFactor=skyViewFactorWindows,
    k=k,
    Tr=Tr,
    Abs=AbsVitrage,
    eps=epsWindows)
    annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancher(
    caracParoi(
      n=paraPlancher.n,
      m=paraPlancher.m,
      e=paraPlancher.e,
      mat=paraPlancher.mat,
      positionIsolant=paraPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher,
    hs_ext=hs_ext_Plancher,
    hs_int=hs_int_Plancher,
    RadExterne=false,
    RadInterne=true,
    GLOext=false)
    annotation (Placement(transformation(extent={{-8,-92},{12,-72}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancherInt(
    caracParoi(
      n=paraPlancher.n,
      m=paraPlancher.m,
      e=paraPlancher.e,
      mat=paraPlancher.mat,
      positionIsolant=paraPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher*(NbNiveau - 1),
    hs_ext=hs_ext_Plancher,
    hs_int=hs_int_Plancher,
    RadInterne=true) if NbNiveau > 1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-70})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal ventilationSimple(Qv=renouv
        *Vair)
    annotation (Placement(transformation(extent={{-12,-116},{8,-96}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-22,8},{-18,12}}), iconTransformation(
          extent={{-192,4},{-172,24}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tint annotation (
      Placement(transformation(extent={{18,8},{22,12}}), iconTransformation(
          extent={{60,-76},{80,-56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient coefficientBsol(b=b)
    annotation (Placement(transformation(extent={{-46,-94},{-26,-74}})));
  Modelica.Blocks.Math.Gain gainTransmisPlancher(k=1/NbNiveau) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={28,-42})));
  Modelica.Blocks.Math.Gain gainTransmisPlancherIntermediaire(k=(NbNiveau - 1)/
        NbNiveau) if
               NbNiveau>1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={38,-60})));
// Composants publics
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairext
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}}),
        iconTransformation(extent={{-100,-120},{-80,-100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairint
    annotation (Placement(transformation(extent={{80,0},{100,20}}),
        iconTransformation(extent={{80,-60},{100,-40}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncVitrage
    "Flux solaire surfacique incident sur les vitrages" annotation (Placement(
        transformation(extent={{-120,30},{-80,70}}),  iconTransformation(extent={{-100,50},
            {-80,70}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncParoi
    "Flux solaire surfacique incident sur les parois" annotation (Placement(
        transformation(extent={{-120,-10},{-80,30}}),iconTransformation(extent=
            {{-100,30},{-80,50}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxTrVitrage
    "Flux solaire incident transmis surfacique (doit tenir compte de l'influence de l'incidence)"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel
    "Température de ciel pour la prise en compte du rayonnement GLO"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}}),
        iconTransformation(extent={{-100,80},{-80,100}})));

// Pour validation en régime stationnaire : fixer les paramètres pour avoir CLO, GLO (abs et eps) et renouv à zéro et 1°C de différence entre extérieur et intérieur)
Real UbatEffectif=Tairint.Q_flow/Sdeper;

equation
assert(max(paraParoiExt.positionIsolant)==1, "Pas de couche isolante spécifiée pour les parois extérieures. Modifier paraParoiExt.positionIsolant");
assert(max(paraPlancher.positionIsolant)==1, "Pas de couche isolante spécifiée pour les planchers. Modifier paraPlancher.positionIsolant");
assert(Ubat<Umax and Ubat>Umin,"La valeur du Ubat est dépendante des types de vitrages et parois choisis. Etant donné la configuration actuelle,"+String(Umin)+"<Ubat<"+String(Umax));

// Noeud d'air et ports internes
  connect(noeudAir.port_a, Tairint) annotation (Line(
      points={{60,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tint) annotation (Line(
      points={{60,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tairext, Text) annotation (Line(
      points={{-90,-70},{-56,-70},{-56,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Conditions limites réglementaires
  connect(coefficientBsol.port_int, Tint) annotation (Line(
      points={{-45,-87},{-45,-91.5},{20,-91.5},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.port_ext, Text) annotation (Line(
      points={{-45,-81},{-45,-77.5},{-20,-77.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Connexions du plancher
  connect(plancher.T_int, Tint)
                           annotation (Line(
      points={{11,-85},{11,-82.5},{20,-82.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.Tponder, plancher.T_ext) annotation (Line(
      points={{-31,-84.2},{-29.5,-84.2},{-29.5,-85},{-7,-85}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancher.FluxAbsInt, gainTransmisPlancher.y) annotation (Line(
      points={{5,-77},{28,-77},{28,-48.6}},
      color={0,0,127},
      smooth=Smooth.None));
// Ventilation
  connect(ventilationSimple.port_b, Tint) annotation (Line(
      points={{7,-106},{20,-106},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ventilationSimple.port_a, Text) annotation (Line(
      points={{-11,-106},{-20,-106},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Vitrage
  connect(vitrage.T_ext, Text)     annotation (Line(
      points={{-9,-35},{-9,-30.5},{-20,-30.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrage.T_int, Tint)     annotation (Line(
      points={{9,-35},{20,-35},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrage.T_ciel, Tciel) annotation (Line(
      points={{-9,-41},{-32,-41},{-32,110},{-90,110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrage.CLOTr, gainTransmisPlancherIntermediaire.u) annotation (Line(
      points={{9,-27},{37.5,-27},{37.5,-52.8},{38,-52.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(gainTransmisPlancher.u, vitrage.CLOTr) annotation (Line(
      points={{28,-34.8},{28,-27},{9,-27}},
      color={255,170,85},
      smooth=Smooth.None));
// Parois extérieures
  connect(paroiExt.T_int, Tint)     annotation (Line(
      points={{11,43},{20,43},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExt.T_ext, Text)     annotation (Line(
      points={{-7,43},{-20,43},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExt.T_ciel, Tciel)     annotation (Line(
      points={{-7,37},{-32,37},{-32,110},{-90,110}},
      color={191,0,0},
      smooth=Smooth.None));

// PLanchers intermédiaires
  connect(plancherInt.FluxAbsInt, gainTransmisPlancherIntermediaire.y)
    annotation (Line(
      points={{65,-75},{38,-75},{38,-66.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(plancherInt.T_ext, noeudAir.port_a) annotation (Line(
      points={{77,-67},{82,-67},{82,-14},{60,-14},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancherInt.T_int, noeudAir.port_a) annotation (Line(
      points={{59,-67},{50,-67},{50,-14},{60,-14},{60,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FluxIncParoi, paroiExt.FluxIncExt)
    annotation (Line(points={{-100,10},{-1,10},{-1,51}}, color={255,192,1}));
  connect(vitrage.FluxIncExt, FluxIncVitrage) annotation (Line(points={{-3,-27},
          {-60,-27},{-60,50},{-100,50}}, color={255,192,1}));
  connect(FluxTrVitrage, vitrage.FluxTr)
    annotation (Line(points={{-100,80},{-50,80},{-50,-30},{-3,-30}},
                                                   color={255,192,1}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -120},{100,120}})),  Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-120},{100,120}}), graphics={
        Polygon(
          points={{-100,80},{-60,40},{-60,-120},{-100,-78},{-100,80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-100,80},{38,80},{100,40},{-60,40},{-100,80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,40},{100,40},{100,-120},{-60,-120},{-60,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Polygon(
          points={{-46,34},{-46,14},{-8,14},{-8,34},{-46,34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,0},{-46,-20},{-8,-20},{-8,0},{-46,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-40},{-48,-60},{-10,-60},{-10,-40},{-48,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-74},{-48,-94},{-10,-94},{-10,-74},{-48,-74}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-74},{36,-94},{74,-94},{74,-74},{36,-74}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-40},{36,-60},{74,-60},{74,-40},{36,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,0},{36,-20},{74,-20},{74,0},{36,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,34},{36,14},{74,14},{74,34},{36,34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,60},{-90,40},{-70,20},{-70,40},{-90,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,20},{-90,0},{-70,-20},{-70,0},{-90,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,-20},{-90,-40},{-70,-60},{-70,-40},{-90,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,-60},{-90,-80},{-70,-100},{-70,-80},{-90,-60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i><b>Modèle de monozone linéarisé et invariant dans le temps à Ubat et inertie variable</b></i></p>
<p>Ce modèle permet la représentation de Maison Individuelle/Logement Collectif/ Bâtiment Tertiaire en monozone. La modélisation est simplifiée pour ne prendre en compte qu'une paroi extérieure et un vitrage équivalents indépendant de l'orientation.</p>
<p>Le niveau de déperdition représenté par le Ubat est un paramètre du modèle. Ce modèle conduit à un modèle linéaire invariant dans le temps qu'il est possible de réduire.</p>
<p><u><b>Hypothèses et équations</b></u></p>
<h4>Géométrie</h4>
<p>Modèle monozone 0D-1D parallépipédique à section carrré. La hauteur du bâtiment est dépendante du nombre de niveaux (<code><span style=\"font-family: Courier New,courier;\">NbNiveau),</span></code> du volume d'air total (<code><span style=\"font-family: Courier New,courier;\">Vair</span></code>) et de la surface habitable (<code><span style=\"font-family: Courier New,courier;\">SH</span></code>). Les vitrages sont définis par une surface totale. La totalité du flux solaire transmis par les vitrages est absorbé en surface du/des planchers.</p>
<h4>Typologie constructive</h4>
<p>Les typologies constructives (matériaux et épaisseurs des couches) sont prises en compte de façon détaillée.</p>
<p>L'inertie est ajustable en choisissant le mode constructif via le type de paroi. L'inertie due aux parois internes, hors planchers, est négligée.</p>
<p>Le choix des paramètres des parois (<code><span style=\"font-family: Courier New,courier;\">paraParoiV</span></code>...) décrivant les typologies constructives ainsi que des paramètres des vitrages permet le calcul d'un Ubat référence. Le Ubat du bâtiment est ensuite ajusté au paramètre <code><span style=\"font-family: Courier New,courier;\">Ubat</span></code> grâce aux épaisseurs des isolants des parois exterieures. L'isolant de plancher ne participe pas à cette ajustement.</p>
<h4>Physique</h4>
<p>Les échanges grande longueur d'onde sur les faces extérieures des vitrages et des parois sont linéarisés. L'influence de l'angle d'incidence, non linéaire, est externalisée. Le coefficient B impose les conditions limites sur la face extérieure du plancher bas. La totalité du flux solaire transmis par les vitrages est absorbé en surface du/des planchers. Les parois extérieures décrivent le plafond/toit et les parois verticales extérieures. Elles sont soumises au rayonnement CLO et GLO.</p>
<p>Le calcul de flux solaires absorbés et transmis est externalisé de ce modèle et est effectué par un modèle <a href=\"modelica://BS2013.Composants.CLSolaire\">CLSolaire</a>. Ce calcul est détaillé et prend bien en compte l'influence de l'orientation des parois et vitrages.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Voir les hypothèses de modélisation des <a href=\"modelica://BS2013.Composants.SimpleWall\">parois</a> et des <a href=\"modelica://BS2013.Composants.SimpleGlazing\">vitrages</a> simplifiés.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Connexion des différents ports de flux solaires grâce à un modèle <a href=\"modelica://BS2013.Composants.CLSolaire\">CLSolaire</a>. Le port de température extérieure doit être connecté à un bloc météo.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Suivant la typologie constructive choisie et le type de vitrage, le Ubat ne peut être choisi n'importe comment. Il doit nécessairement être encadré. Un message d'erreur survient lorsque le Ubat choisi est hors de cet interval.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis, Hassan Bouia 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 09/2015 : Ajout d'<code>assert</code> prévenant la non définition de couche isolante.</p>
</html>"));
end SimplifiedMonozone;
