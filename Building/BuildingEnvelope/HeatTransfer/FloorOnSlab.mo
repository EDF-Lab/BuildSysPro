within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model FloorOnSlab
  "Modèle de plancher sur terre plein - Modèle de paroi générique - PRE et paroi active eau possibles - nouvelle saisie des matériaux"

// Paramètres de choix du modèle
 parameter Integer ParoiActive=1
      annotation(dialog(group="Type de paroi",compact=true),
      choices(choice=1 "Paroi classique",
      choice=2 "Circulation d'eau",
      choice=3 "Résistance électrique",radioButtons=true));
  parameter Boolean SurEquivalentTerre=true
    "Prise en compte d'une couche de terre entre la paroi et Tsol"
     annotation(dialog(group="Type de modèle",compact=true),choices(choice=true
        "Oui : Paroi en contact avec un matériau équivalent à de la terre",                                                                          choice=false
        "Non : Paroi classique",                                                                                                    radioButtons=true));

  parameter Boolean RadInterne=true
    "Prise en compte des flux radiatifs à l'intérieur" annotation(dialog(group="Type de modèle",compact=true),choices(radioButtons=true));

 parameter Boolean CLfixe=true "Condition en température de sol fixe"
                                            annotation(dialog(group="Type de modèle",compact=true),choices(radioButtons=true));

// Paramètres thermo-physiques
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoi
    "Caractéristiques du plancher (inclue celles du sol sous le plancher si SurEquiValentTerre = False)"
    annotation (__Dymola_choicesAllMatching=true, dialog(group=
          "Paramètres de la paroi"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericSolid caracTerre=BuildSysPro.Utilities.Data.Solids.SoilClaySilt()
    "Caractéristiques physiques de la terre"
    annotation (choices(
                choice=BuildSysPro.Utilities.Data.Solids.SoilClaySilt()
        "Terre type argile/glaise lambda=1.5",
                choice=BuildSysPro.Utilities.Data.Solids.SoilSandGravel()
        "Terre type sable/gravier lambda=2.0"),                                                                     dialog(group=
          "Paramètres du sol"));

  parameter Modelica.SIunits.Area S=1 "Surface de la paroi" annotation (dialog(group="Paramètres de la paroi"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs=5.88
    "Coefficient d'échange surfacique global sur la face intérieure" annotation (dialog(group="Paramètres de la paroi"));
  parameter Modelica.SIunits.Temperature Ts=293.15 "Température du sol" annotation (dialog(enable=CLfixe,group="Paramètres du sol"));

// Paramètre commun à la paroi active eau et au rayonnant électrique
 parameter Integer nP=1
    "Numéro de la couche dont la frontière supérieure est le lieu d'injection de la puissance - doit être strictement inférieur à n"
    annotation (Dialog(enable=not
                                 (ParoiActive==1), group="Type de paroi"));

// Paramètres propres à une paroi chauffante avec eau
  parameter Integer nD=8
    "Nombre de tranche de discrétisation du plancher à eau"
    annotation(dialog(enable=ParoiActive==2, tab="Paramètres paroi chauffante"));
  parameter Modelica.SIunits.Distance Ltube=128
    "Longueur du serpentin de chauffe du plancher"
    annotation(dialog(enable=ParoiActive==2, tab="Paramètres paroi chauffante"));
  parameter Modelica.SIunits.Distance DiametreInt=0.013
    "Diamètre intérieure du tube"
    annotation(dialog(enable=ParoiActive==2, tab="Paramètres paroi chauffante"));
  parameter Modelica.SIunits.Distance eT=0.0015 "Epaisseur du tube"
    annotation (Dialog(enable=ParoiActive==2, tab="Paramètres paroi chauffante"));
  parameter Modelica.SIunits.ThermalConductivity lambdaT=0.35
    "Conductivité thermique du tube"
    annotation (Dialog(enable=ParoiActive==2, tab="Paramètres paroi chauffante"));

// Paramètres d'initialisation
  parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale de la paroi" annotation (dialog(group="Paramètres d'initialisation"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (dialog(group="Paramètres d'initialisation"));

// Paramètres du sol
  parameter Modelica.SIunits.Length eSol=0.2 "Epaisseur du sol"
                       annotation (dialog(enable=SurEquivalentTerre,group="Paramètres du sol"));
  parameter Integer mSol=5 "Nombre de mailles pour modéliser le sol"
                                            annotation (dialog(group="Paramètres du sol",enable=SurEquivalentTerre));

// Composants
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int annotation (
     Placement(transformation(extent={{20,-10},{40,10}}), iconTransformation(
          extent={{20,-10},{40,10}})));
  Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne
    "Flux absorbés (GLO/CLO) par cette paroi sur sa face intérieure"
    annotation (Placement(transformation(extent={{118,70},{80,108}}),
        iconTransformation(extent={{40,40},{20,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature TemperatureSol(T=Ts) if
    CLfixe annotation (Placement(transformation(extent={{-99,-9},{-81,9}})));

protected
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor thermalConductor(G=hs*S)
    annotation (Placement(transformation(extent={{51,22},{72,42}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 if
    RadInterne annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={59,89})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall Sol(
    InitType=InitType,
    n=1,
    S=S,
    m={mSol},
    Tinit=Tp,
    e={eSol},
    mat={caracTerre}) if
    SurEquivalentTerre
    annotation (Placement(transformation(extent={{-56,6},{-36,26}})));

public
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tsol if not (CLfixe)
    "Température du sol" annotation (Placement(transformation(extent={{-100,-40},
            {-80,-20}}), iconTransformation(extent={{-120,-10},{-100,10}})));

protected
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a NoeudTsol
    "Température du sol"
    annotation (Placement(transformation(extent={{-65,-7},{-68,-10}})));

public
  BuildSysPro.Systems.HVAC.Emission.RadiantFloor.RadiantHeatingFloor
    PlancherActifEau[nD](
    Ltube=Ltube/nD*(0.1:1.8/(nD - 1):1.9),
    each Tp=Tp,
    each DiametreInt=DiametreInt,
    S=S/nD*(0.1:1.8/(nD - 1):1.9),
    each eT=eT,
    each lambdaT=lambdaT,
    each caracParoi(
      n=caracParoi.n,
      m=caracParoi.m,
      e=caracParoi.e,
      mat=caracParoi.mat,
      positionIsolant=caracParoi.positionIsolant),
    each nP=nP,
    each InitType=InitType) if ParoiActive == 2
    "Surface de la paroi subdivisée en nD parois actives avec circulation d'eau à l'intérieur"
    annotation (Placement(transformation(extent={{-12,-12},{12,12}})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall plancherClassique(
    S=S,
    Tinit=Tp,
    InitType=InitType,
    n=caracParoi.n,
    m=caracParoi.m,
    e=caracParoi.e,
    mat=caracParoi.mat) if ParoiActive == 1
    annotation (Placement(transformation(extent={{-14,32},{12,54}})));
  Modelica.Blocks.Interfaces.RealInput EntreeEau[2] if ParoiActive==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{-120,12},{-80,52}}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={6,-90})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2] if ParoiActive==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{84,-66},{116,-34}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-70})));
  Modelica.Blocks.Interfaces.RealInput PelecPRE if ParoiActive==3
    "Puissance électrique injectée dans le plancher"
                                                annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-8,-90})));
protected
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a NoeudTsolPlanch
    "Température entre sol et plancher"
    annotation (Placement(transformation(extent={{-25,-7},{-28,-10}})));
public
  BuildSysPro.Systems.HVAC.Emission.RadiantFloor.RadiantHeatingFloor
    PlancherChauffanteElec(
    S=S,
    caracParoi(
      n=caracParoi.n,
      m=caracParoi.m,
      e=caracParoi.e,
      mat=caracParoi.mat,
      positionIsolant=caracParoi.positionIsolant),
    nP=nP,
    TypeChauffage=2,
    Tp=Tp,
    InitType=InitType) if ParoiActive == 3 annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={2,-40})));
equation

if ParoiActive==1 then
  //connection des tranches pour le cas d'une paroi classique
  connect(plancherClassique.port_a, NoeudTsolPlanch);
  connect(plancherClassique.port_b, Ts_int);
elseif ParoiActive==2 then
//connection des nD tranches pour le cas d'une paroi chauffante à eau
  for i in 1:nD loop
    connect(PlancherActifEau[i].Ts_b, Ts_int);
    connect(PlancherActifEau[i].Ts_a, NoeudTsolPlanch);
  end for;
  connect(PlancherActifEau[1].Entree,EntreeEau);
  for i in  2:nD loop
    connect(PlancherActifEau[i-1].Sortie,PlancherActifEau[i].Entree);
  end for;
  connect(PlancherActifEau[nD].Sortie,SortieEau);

else // ParoiActive==3
  //connection des tranches pour le cas d'une paroi chauffante électrique
end if;

  if not SurEquivalentTerre then
    connect(NoeudTsolPlanch, NoeudTsol)
                                      annotation (Line(
      points={{-26.5,-8.5},{-66.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;

  connect(thermalConductor.port_b, T_int)  annotation (Line(
      points={{70.95,32},{74,32},{74,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ts_int, thermalConductor.port_a)
                                         annotation (Line(
      points={{30,0},{46,0},{46,32},{52.05,32}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(prescribedHeatFlow2.port, Ts_int) annotation (Line(
      points={{51.3,88.02},{51.3,87.01},{30,87.01},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FluxAbsInt, prescribedHeatFlow2.Q_flow) annotation (Line(
      points={{99,89},{81.5,89},{81.5,88.02},{65.3,88.02}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(TemperatureSol.port, NoeudTsol) annotation (Line(
      points={{-81,0},{-72,0},{-72,-8.5},{-66.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tsol, NoeudTsol) annotation (Line(
      points={{-90,-30},{-72,-30},{-72,-8.5},{-66.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));
 connect(NoeudTsol, Sol.port_a)                 annotation (Line(
      points={{-66.5,-8.5},{-60,-8.5},{-60,16},{-55,16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Sol.port_b, NoeudTsolPlanch)
    annotation (Line(
      points={{-37,16},{-32,16},{-32,-8.5},{-26.5,-8.5}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (
Documentation(info="<html>
<p><i><b>Modèle de plancher sur terre plein avec le sol modélisé comme purement conductif et l'absorption du flux CLO interne</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle de paroi interne sur terre plein avec une condition aux limites en température (la température de sol) sur la face inférieure. La modélisation tient compte uniquement de la conduction 1D au sein du plancher et du sol. Sur la face supérieure, la convection ainsi que les échanges grandes longueurs d'ondes sont modélisés par un coefficient d'échange surfacique global <i>hs.</i> Le paramètre optionnel <i>radInterne </i>permet de tenir compte des flux courtes longueurs d'ondes.</p>
<p>Le paramètre <i>SurEquiValentTerre </i>permet de prendre en compte une couche de terre d'une épaisseur,  d'un maillage et d'un type (argile/glaise ou sable/gravier) définis dans l'onglet <i>Paramètres du sol</i>. Dans le cas où ce paramètre est à la valeur <i>false </i>la matière constituante du sol doit être considérée dans le paramètre <i>CaracParoi.</i></p>
<p><u><b>Bibliographie</b></u></p>
<p>Mutualisation des 2 modèles de paroi sur terre plein de la précédente version de BuildSysPro.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Renseigner les paramètres concernant le type de modèles, prise en compte du flux solaire courtes longueurs d'ondes et la prise en compte d'une couche d'un équivalent terre sous le plancher.</p>
<p>Renseigner les paramètres de la dalle/plancher notamment la surface, le coefficient d'échange surfacique ainsi que les caractéristiques des matériaux utilisés. Si SurEquivalentTerre=true a été sélectionné, renseigner dans l'onglet <i>Paramètres du sol </i>les informations sur le type de sol, l'épaisseur de cette couche et sa discrétisation.</p>
<p>Renseigner les paramètres relatif à l'intialisation du modèle.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 : </p>
<ul>
<li>Ajout du choix de considérer ou non les flux CLO sur la face interne via le booléen RadInterne </li>
<li>Ajout d'une liste déroulante pour le choix des matériaux via l'annotation(__Dymola_choicesAllMatching=true)</li>
</ul>
<p>Vincent Magnaudeix 03/2012 : Ajout d'un noeud de température pour une connection à une température de sol variable</p>
<p>Aurélie Kaemmerlen 05/2011 : Modification du nom du connecteur CLOabs changé en FluxAbsInt</p>
<p>Gilles Plessis 06/2012 :</p>
<ul>
<li>Fusion des anciens modèles pour considérer le sol ou non</li>
<li>Insertion du record ParoiGenerique pour le paramètrage des caractéristiques de la paroi sous une forme &QUOT;replaceable&QUOT;</li>
</ul>
<p>Aurélie Kaemmerlen 07/2012 : Modification similaires à celles effectuées sur la paroi classique</p>
<ul>
<li>Intégration de l'option permettant d'en faire un plancher chauffant à eau, Modification du paramètre par défaut pour hint (5.88 au lieu de 1)</li>
<li>Intégration du modèle partiel de plancher chauffant électrique.</li>
</ul>
<p><br>Amy Lindsay 03/2014 : changement des FluxSolInput en RealInput pour les flux absorbés intérieur pour éviter les confusions (ces flux absorbés en GLO ou en CLO peuvent non seulement provenir du soleil, mais aussi d'autres sources radiatives)</p>
<p>Benoît Charrier 12/2015 : ajout du paramètre caracTerre permettant de changer les caractéristiques physiques du sol</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={       Text(
          extent={{-10,22},{6,12}},
          lineColor={0,128,0},
          textString="OU
"),                                      Text(
          extent={{-10,-18},{6,-28}},
          lineColor={0,128,0},
          textString="OU
")}),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),graphics={
        Line(
          points={{20,0},{94,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,100},{20,-100}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,132},{112,98}},
          lineColor={0,0,0},
          textString="%name"),
        Rectangle(
          extent={{-100,100},{-20,-100}},
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}),
    DymolaStoredErrors);
end FloorOnSlab;
