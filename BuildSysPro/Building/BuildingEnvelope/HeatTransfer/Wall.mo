within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model Wall
  "Modèle de paroi générique - PRE et paroi active eau possibles - nouvelle saisie des matériaux"

// Prise en compte des options de la paroi
 parameter Integer ParoiActive=1
      annotation(dialog(group="Type de paroi",compact=true),
      choices(choice=1 "Paroi classique",
      choice=2 "Circulation d'eau",
      choice=3 "Résistance électrique",radioButtons=true));

  parameter Boolean RadInterne=false
    "Prise en compte de flux absorbés sur la face intérieure"
    annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
  parameter Boolean ParoiInterne=false "Flux solaire incident ?"
    annotation(dialog(group="Type de paroi",compact=true),choices(choice=true
        "Paroi interne",                                                                       choice=false
        "Paroi donnant sur l'extérieur",                                                                                                  radioButtons=true));

  parameter Boolean RadExterne=false
    "Prise en compte de flux absorbés sur la face extérieure"
    annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
  parameter Boolean GLOext=false
    "Prise en compte du rayonnement GLO (infrarouge) entre la paroi et l'environnement et le ciel"
    annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));

// Paramètres généraux
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°"
    annotation(dialog(enable=GLOext, group="Propriétés générales de la paroi"));

  parameter Modelica.SIunits.Area S=1 "Surface du mur sans les fenetres"
    annotation(dialog(group="Propriétés générales de la paroi"));

  parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale de la paroi"
    annotation(dialog(group="Propriétés générales de la paroi"));

  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (dialog(group="Propriétés générales de la paroi"));

  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=25
    "Coefficient d'échange surfacique sur la face extérieure"
     annotation(dialog(group="Propriétés générales de la paroi"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=7.69
    "Coefficient d'échange surfacique global sur la face intérieure"
    annotation(dialog(group="Propriétés générales de la paroi"));
  parameter Real alpha_ext=0.6
    "Coefficient d'absorption de la parois ext. dans le visible (autour de 0.3 pour les parois claires et 0.9 pour les teintes foncées"
    annotation(dialog(enable=(not ParoiInterne), group="Propriétés générales de la paroi"));
  parameter Real eps=0.9 "Emissivité (béton 0.9)"
    annotation(dialog(enable=GLOext, group="Propriétés générales de la paroi"));

// Composition de la paroi
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoi
    "Caractéristiques de paroi" annotation (__Dymola_choicesAllMatching=true,
      dialog(group="Type de paroi"));

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

  BuildSysPro.Systems.HVAC.Emission.RadiantFloor.RadiantHeatingFloor
    paroiActiveEau[nD](
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
    annotation (Placement(transformation(extent={{-8,-44},{16,-20}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température extérieure" annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}}), iconTransformation(extent={{-100,-40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Température intérieure" annotation (Placement(transformation(extent={{80,
            -40},{100,-20}}), iconTransformation(extent={{80,-40},{100,-20}})));
Modelica.Blocks.Math.Gain AbsMurExt(k=alpha_ext*S) if  (not ParoiInterne)
    annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-35,71})));
Modelica.Blocks.Math.Add add if (not ParoiInterne)
    annotation (Placement(transformation(extent={{-72,64},{-58,78}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUX[3] if
                                                                          (not
    ParoiInterne)
    "Informations de flux solaire surfacique incident 1-Flux Diffus, 2-Flux Direct 3-Cosi"
    annotation (Placement(transformation(extent={{-118,54},{-80,92}}),
        iconTransformation(extent={{-40,80},{-20,100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCLOAbsExt if (not
    ParoiInterne) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=-90,
        origin={-16,56})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCLOAbsInt if
    RadInterne annotation (Placement(transformation(
        extent={{8,8},{-8,-8}},
        rotation=90,
        origin={50,44})));
Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne
    "Flux absorbés (GLO/CLO) par cette paroi sur sa face intérieure"
    annotation (Placement(transformation(extent={{138,50},{100,88}}),
        iconTransformation(extent={{40,40},{20,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Température extérieure à la surface de la paroi" annotation (Placement(
        transformation(extent={{-46,-40},{-26,-20}}), iconTransformation(extent=
           {{-40,-40},{-20,-20}})));
Modelica.Blocks.Interfaces.RealInput                            FluxAbsExt if
    RadExterne
    "Flux absorbés (GLO/CLO) par cette paroi sur sa face extérieure"
    annotation (Placement(transformation(extent={{-120,12},{-82,50}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCLOAbsExt2 if
    RadExterne annotation (Placement(transformation(
        extent={{8,8},{-8,-8}},
        rotation=180,
        origin={-62,32})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtLWR EchangesGLOext(
    S=S,
    eps=eps,
    incl=incl,
    GLO_env=GLOext,
    GLO_ciel=GLOext) if GLOext
    annotation (Placement(transformation(extent={{-68,-70},{-48,-50}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if GLOext
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}}),
        iconTransformation(extent={{-100,-100},{-80,-80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Température intérieure à la surface de la paroi" annotation (Placement(
        transformation(extent={{30,-40},{50,-20}}), iconTransformation(extent={
            {20,-40},{40,-20}})));
  Modelica.Blocks.Interfaces.RealInput EntreeEau[2] if ParoiActive==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,16},{-80,36}})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2] if ParoiActive==2
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}}),
        iconTransformation(extent={{80,-80},{100,-60}})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor Echange_a(G=hs_ext*
        S) annotation (Placement(transformation(extent={{-72,-40},{-52,-20}},
          rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor Echange_b(G=hs_int*
        S) annotation (Placement(transformation(extent={{56,-40},{76,-20}},
          rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HomogeneousNLayersWall ParoiNCouchesHomogenes(
    S=S,
    Tinit=Tp,
    InitType=InitType,
    n=caracParoi.n,
    m=caracParoi.m,
    e=caracParoi.e,
    mat=caracParoi.mat) if ParoiActive == 1
    annotation (Placement(transformation(extent={{-10,0},{16,22}})));
  BuildSysPro.Systems.HVAC.Emission.RadiantFloor.RadiantHeatingFloor
    ParoiChauffanteElec(
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
        origin={4,-72})));
  Modelica.Blocks.Interfaces.RealInput PelecPRE if ParoiActive==3
    "Puissance électrique injectée dans le plancher"
                                                annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={10,100}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
equation
if ParoiActive==1 then
  //connection des tranches pour le cas d'une paroi classique
  connect(ParoiNCouchesHomogenes.port_a, Ts_ext);
  connect(ParoiNCouchesHomogenes.port_b, Ts_int);
elseif ParoiActive==2 then
//connection des nD tranches pour le cas d'une paroi chauffante à eau
  for i in 1:nD loop
    connect(paroiActiveEau[i].Ts_b, Ts_int);
    connect(paroiActiveEau[i].Ts_a, Ts_ext);
  end for;
  connect(paroiActiveEau[1].Entree,EntreeEau);
  for i in  2:nD loop
    connect(paroiActiveEau[i-1].Sortie,paroiActiveEau[i].Entree);
  end for;
  connect(paroiActiveEau[nD].Sortie,SortieEau);

else // ParoiActive==3
  //connection des tranches pour le cas d'une paroi chauffante électrique
  connect(Ts_ext, ParoiChauffanteElec.Ts_a);
  connect(ParoiChauffanteElec.Ts_b, Ts_int);
  connect(PelecPRE, ParoiChauffanteElec.PelecIn);
end if;

  connect(add.y, AbsMurExt.u) annotation (Line(
      points={{-57.3,71},{-48.2,71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AbsMurExt.y, prescribedCLOAbsExt.Q_flow) annotation (Line(
      points={{-22.9,71},{-17.12,71},{-17.12,63.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.Q_flow, FluxAbsInt)
                                              annotation (Line(
      points={{48.88,51.2},{48.88,69},{119,69}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u1, FLUX[2]) annotation (Line(
      points={{-73.4,75.2},{-88.7,75.2},{-88.7,73},{-99,73}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u2, FLUX[1]) annotation (Line(
      points={{-73.4,66.8},{-99,66.8},{-99,60.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedCLOAbsExt2.Q_flow, FluxAbsExt)
                                                  annotation (Line(
      points={{-69.2,30.88},{-69.2,31},{-101,31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_ciel, EchangesGLOext.T_ciel)
                                       annotation (Line(
      points={{-90,-90},{-74,-90},{-74,-65},{-67,-65}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, EchangesGLOext.T_ext)
                                   annotation (Line(
      points={{-90,-30},{-75,-30},{-75,-57},{-67,-57}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EchangesGLOext.Ts_p, Ts_ext) annotation (Line(
      points={{-49,-60},{-36,-60},{-36,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.port, Ts_int) annotation (Line(
      points={{48.88,35.2},{48.88,35.6},{40,35.6},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsExt2.port, Ts_ext) annotation (Line(
      points={{-53.2,30.88},{-53.2,31.6},{-36,31.6},{-36,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsExt.port, Ts_ext) annotation (Line(
      points={{-17.12,47.2},{-17.12,32.6},{-36,32.6},{-36,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Echange_a.port_b, Ts_ext) annotation (Line(
      points={{-53,-30},{-36,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_ext, Echange_a.port_a) annotation (Line(
      points={{-90,-30},{-71,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Echange_b.port_b, T_int) annotation (Line(
      points={{75,-30},{90,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Echange_b.port_a, Ts_int) annotation (Line(
      points={{57,-30},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
    annotation(dialog(enable=BoolActiveEau, tab="Paramètres paroi chauffante", group="Couches comprises entre l'extérieure et le serpentin de chauffe intégré à la paroi"),
                                                                                Placement(transformation(
        extent={{12,-12},{-12,12}},
        rotation=0,
        origin={50,52})),
                Placement(transformation(extent={{-64,-44},{-44,-24}})),
      Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
            100,100}}),        graphics={Text(
          extent={{-6,-10},{10,-20}},
          lineColor={0,128,0},
          textString="OU
"),                                      Text(
          extent={{-6,-50},{10,-60}},
          lineColor={0,128,0},
          textString="OU
")}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-98,132},{94,98}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-90,-30},{86,-30}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,100},{20,-100}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175})}),
    Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<ul>
<li>Cette paroi peut être externe ou interne et avec prise en compte de divers flux radiatifs CLO et GLO sur ses faces</li>
<li>Un transfert de chaleur par conduction se fait dans le matériau définit par <b>n</b> couches homogènes (chaque couche est discrétisée en <b>m</b> mailles équidistantes)</li>
<li>Des transferts de chaleur par convection se font sur les 2 faces externes et internes</li>
<p><br><u>Options de chauffage disponibles :</u></p>
<li>Cette paroi peut être chauffée (ou rafraichie) par un circuit hydraulique intégrée par discrétisation en nD tranches de la surface du plancher. Une étude de sensibilité a permis de définir la valeur par défaut de nD =8 qui peut être à pas variable.</li>
<li>Cette paroi peut également intégrer un élément chauffant (exemple d'un plancher rayonnant électrique PRE). Le port réel <i>PelecPRE</i> permet alors d'injecter une puissance thermique pour modéliser les cables d'un plancher chauffant. </li>
</ul>
<p><br>Au niveau des flux solaires CLO, nous distinguons :</p>
<ul>
<li>Les flux solaires direct et diffus incidents sur la face extérieure</li>
<li>Le flux solaire diffus transmis dans le local et réfléchi par les surfaces internes du local et qui est reçu par la face intérieure</li>
</ul>
<p><u><b>Bibliographie</b></u></p>
<p>TF1 CLIM2000</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Les ports thermiques <b>T_ext</b> et <b>T_int</b> doivent être reliés à des noeuds de température (habituellement Tseche et Tint).</p>
<p>Les flux incidents externes <b>FLUX</b> peuvent provenir des modèles de conditions limites du package <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar\">BoundaryConditions.Solar</a> qui font la liaison entre les parois et les lecteurs Météo.</p>
<p>Le flux incident interne <b>FluxAbsInt</b> peut provenir des occupants, systèmes de chauffage mais aussi de la redistribution du flux solaire à l'intérieur d'une pièce (modèles du package <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\">BoundaryConditions.Radiation</a>).</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Attention, les valeurs par défaut pour les coefficients convectifs sont des indications uniquement et en rien des valeurs réalistes pour tous les cas de figure.</p>
<p>Les coefficients d'échanges donnés sont soient les coefficients globaux (somme du convectif et du radiatif), soient les échanges purement convectifs si les échanges radiatifs sont traités par ailleurs</p>
<ul>
<li>Si GLOext=true, alors le coefficient hs_est est un coefficient purement convectif </li>
<li>On pourra retirer forfaitairement 5,15 W/m&sup2;.K à l'extérieur et 5.71 W:m&sup2;.K à l'intérieur de la valeur du coefficient d'échange global préconisé.</li>
</ul>
<p><br>Voici quelques indications :</p>
<ul>
<li>Surfaces verticales : hs_int=7.69, hs_ext=25</li>
<li>Surfaces horizontales : hs_int=10, hs_ext=25</li>
</ul>
<p><u><b>Validations effectuées</b></u></p>
<p>Procédure BESTEST de validation</p>
<p>Modèle validé - Aurélie Kaemmerlen 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 : </p>
<ul>
<li>Ajout du choix de considérer ou non des flux absorbés (CLO ou GLO) sur les 2 faces via 2 booléens RadInterne et RadExterne</li>
<li>Ajout d'une liste déroulante pour le choix des matériaux via l'annotation(__Dymola_choicesAllMatching=true)</li>
</ul>
<p><br>Aurélie Kaemmerlen 05/2011 : </p>
<ul>
<li>paramétrage en paroi interne possible, paroi qui peut avoir un flux (GLO ou CLO) absorbé incident</li>
<li>Modification du nom du connecteur CLOabs changé en FluxAbsInt</li>
</ul>
<p><br>Aurélie Kaemmerlen 10/2011 : augmentation du nombre de maille par couches par défaut (4 au lieu de 2) + Ajout des échanges avec l'environnement (Ciel et Sol)</p>
<ul>
<li>Un nouveau booléen a été ajouté pour permettre de considérer ou non ces deux échanges</li>
<li>L'inclinaison et l'émissivité en GLO de la paroi ont ainsi été ajoutées pour caractériser ces échanges</li>
</ul>
<p><br>Aurélie Kaemmerlen 07/2012 :</p>
<ul>
<li>Iintégration des coefficients convectifs directement dans ce modèle pour faciliter l'intégration d'éléments actifs dans la paroi</li>
<li>Hubert Blervaque 06/2012 : Intégration de l'option permettant d'en faire un plancher chauffant à eau, Modification des paramètres par défaut pour hs et hint (5.88 au lieu de 1)</li>
<li>Vincent Magnaudeix 03/2012 (non validé) : intégration du modèle partiel de plancher chauffant électrique.</li>
<li>Gilles Plessis 06/2012 : Insertion du record ParoiGenerique pour le paramètrage des caractéristiques de la paroi sous une forme &QUOT;replaceable&QUOT;, Protection des composants internes pour éviter le trop grand nombre de variables lors de l'exploitation des résultats de simulation.</li>
<li>Remarque GP : Le &QUOT;modifier&QUOT; replaceable est obligatoire pour autoriser la taille variable de ParoiGenerique (Erreur dans le check d'un modèle utilisant la paroi). Il permet aussi d'envisager l'utilisation de matériaux à changement de phase dans les couches de parois.</li>
</ul>
<p><br>Aurélie Kaemmerlen 10/2012 : Correction de l'inversion depuis la dernière version des hs_int et hs_ext</p>
<p>Aurélie Kaemmerlen 09/2013 : Changement des hs par défaut (correspondent désormais à ceux de surfaces verticales)</p>
<p>Aurélie Kaemmerlen 12/2013 : Modification de la valeur par défaut de l'émissivité : 0.9 (béton) au lieu de 0.6</p>
<p>Amy Lindsay 03/2014 : changement des FluxSolInput en RealInput pour les flux absorbés extérieur et intérieur pour éviter les confusions (ces flux absorbés en GLO ou en CLO peuvent non seulement provenir du soleil, mais aussi d'autres sources radiatives ; de plus, le flux solaire est déjà absorbé via le FLUX[3])</p>
<p>Hassan Bouia 04/2014 : au vu des changements de ParoiNCouchesHomogenes, pour décrire une ParoiNEW, il n'est plus possible d'écrire l'égalité des records caracParoi=caracParoi; il faut étendre cette définition (caracParoi(n=caracParoi.n, m=caracParoi.m, mat=caracParoi.mat, e=caracParoi.e, positionIsolant=caracParoi.positionIsolant)).</p>
</html>"),      Placement(transformation(extent={{46,-50},{66,-30}})),
Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-20,-20},{20,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,0},{-40,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,0},{80,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-80,90},{-40,50}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,124},{90,102}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),
                Placement(transformation(extent={{-74,16},{-54,36}})));
end Wall;
