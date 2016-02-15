within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model SimpleWall "Modèle de paroi simple"

// Paramètres optionnels
parameter Boolean RadExterne=false
    "Prise en compte de flux absorbés sur la face extérieure"
    annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Boolean RadInterne=false
    "Prise en compte de flux absorbés sur la face intérieure"
    annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Boolean GLOext=false
    "Prise en compte du rayonnement GLO (infrarouge) entre la paroi et l'environnement et le ciel"
    annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));

// Propriétés générales
  parameter Modelica.SIunits.Area S=1 "Surface du mur sans les fenetres"
    annotation(dialog(group="Propriétés générales de la paroi"));

  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=5.88
    "Coefficient d'échange CONVECTIF surfacique sur la face extérieure"
     annotation(dialog(group="Propriétés générales de la paroi"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=5.88
    "Coefficient d'échange GLOBAL surfacique global sur la face intérieure"
    annotation(dialog(group="Propriétés générales de la paroi"));
  parameter Real skyViewFactor=0
    "Facteur de forme moyen entre les parois et le ciel (exemple: skyViewFactor(toiture terrase)=1, skyViewfactor(paroi verticale en environnement dégagé)=0.5)"
    annotation(dialog(enable=GLOext,group="Propriétés générales de la paroi"));
// Propriétés optiques
  parameter Real AbsParoi=0.6
    "Coefficient d'absorption de la parois ext. dans le visible"
    annotation(dialog(enable=RadExterne, group="Propriétés optiques de la paroi"));
  parameter Real eps=0.6
    "Emissivité de la surface extérieure de la parois en GLO"
    annotation(dialog(enable=GLOext,  group="Propriétés optiques de la paroi"));

// Composition de la paroi
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoi
    "Caractéristiques de paroi" annotation (__Dymola_choicesAllMatching=true,
      dialog(group="Type de paroi"));

// Initialisation
  parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale de la paroi"
    annotation(dialog(group="Initialisation"));

  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (dialog(group="Initialisation"));
// Composants publiques
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température extérieure" annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}}), iconTransformation(extent={{-100,-40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Température intérieure" annotation (Placement(transformation(extent={{80,
            -40},{100,-20}}), iconTransformation(extent={{80,-40},{100,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Température extérieure à la surface de la paroi" annotation (Placement(
        transformation(extent={{-46,-40},{-26,-20}}), iconTransformation(extent=
           {{-40,-40},{-20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Température intérieure à la surface de la paroi" annotation (Placement(
        transformation(extent={{30,-40},{50,-20}}), iconTransformation(extent={
            {20,-40},{40,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if GLOext
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}}),
        iconTransformation(extent={{-100,-100},{-80,-80}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt if
    RadExterne "Flux CLO surfacique incident sur la face extérieure"
    annotation (Placement(transformation(extent={{-118,12},{-80,50}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne
    "Flux GLO et/ou CLO absorbé par cette paroi sur sa face intérieure"
    annotation (Placement(transformation(extent={{108,22},{70,60}}),
        iconTransformation(extent={{40,40},{20,60}})));
// Composants internes
protected
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCLOAbsExt if
    RadExterne annotation (Placement(transformation(
        extent={{8,8},{-8,-8}},
        rotation=90,
        origin={-36,4})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.LinearExtLWR EchangesGLOext(
    S=S,
    eps=eps,
    skyViewFactor=skyViewFactor) if GLOext
    annotation (Placement(transformation(extent={{-68,-70},{-48,-50}})));

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
    mat=caracParoi.mat)
    annotation (Placement(transformation(extent={{-10,0},{16,22}})));
Modelica.Blocks.Math.Gain AbsMurExt(k=AbsParoi*S) if   RadExterne
    annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-57,31})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCLOAbsInt if
    RadInterne annotation (Placement(transformation(
        extent={{8,8},{-8,-8}},
        rotation=90,
        origin={60,30})));

equation
  //connection des tranches pour le cas d'une paroi classique
  connect(ParoiNCouchesHomogenes.port_a, Ts_ext);
  connect(ParoiNCouchesHomogenes.port_b, Ts_int);

  connect(T_ciel, EchangesGLOext.T_ciel)
                                       annotation (Line(
      points={{-90,-90},{-74,-90},{-74,-65},{-67,-65}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, EchangesGLOext.T_ext)
                                   annotation (Line(
      points={{-90,-30},{-75,-30},{-75,-55},{-67,-55}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(EchangesGLOext.Ts_p, Ts_ext) annotation (Line(
      points={{-49,-60},{-36,-60},{-36,-30}},
      color={255,0,0},
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
  connect(prescribedCLOAbsExt.port, Ts_ext)  annotation (Line(
      points={{-37.12,-4.8},{-37.12,-17.4},{-36,-17.4},{-36,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(AbsMurExt.y, prescribedCLOAbsExt.Q_flow)  annotation (Line(
      points={{-44.9,31},{-44.9,30.5},{-37.12,30.5},{-37.12,11.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluxIncExt, AbsMurExt.u) annotation (Line(
      points={{-99,31},{-70.2,31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.port, Ts_int) annotation (Line(
      points={{58.88,21.2},{40,21.2},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.Q_flow, FluxAbsInt) annotation (Line(
      points={{58.88,37.2},{73.44,37.2},{73.44,41},{89,41}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation(Placement(transformation(
        extent={{12,-12},{-12,12}},
        rotation=0,
        origin={50,52})),
                Placement(transformation(extent={{-64,-44},{-44,-24}})),
      Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
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
<h4>Modèle de paroi simple linéaire</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle est un modèle de paroi simple. Un transfert de chaleur par conduction se fait dans le matériau définit par <code><span style=\"font-family: Courier New,courier;\">n </span></code>couches homogènes (chaque couche est discrétisée en mailles de même taille). Des transferts de chaleur par convection se font sur les 2 faces, externes et internes.</p>
<p>Les flux solaires courte longueur d'onde (CLO) en entrée sont absorbés en surface moyennant le paramètre <code><span style=\"font-family: Courier New,courier;\">AbsParoi</span></code>. Il s'agit du flux global surfacique.</p>
<p>Les échanges en grande longueur d'onde (GLO) sont linéarisés grâce au modèle <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.LinearExtLWR\">LinearExtLWR</a>. Le paramètre <code><span style=\"font-family: Courier New,courier;\">skyViewFactor</span></code> permet de déterminer la part de rayonnement GLO de la paroi avec le ciel, considéré à <code><span style=\"font-family: Courier New,courier;\">T_cie</span></code>l, et l'environnement extérieur, considéré à <code><span style=\"font-family: Courier New,courier;\">T_ext</span></code>.</p>
<p>Le coefficient d'échange convectif avec l'extérieur <code><span style=\"font-family: Courier New,courier;\">hs_ex</span></code>t par défaut est la valeur du coefficient intégrant uniquement la convection. Les échanges GLO étant pris en compte par ailleurs.</p>
<p>Ce modèle conduit à un modèle linéaire invariant dans le temps qu'il est possible de réduire.</p>
<p><u><b>Bibliographie</b></u></p>
<p>TF1 CLIM2000 modifié dans le but d'obtenir un modèle linéaire et invariant dans le temps pour les besoins de l'étude sur les villes.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Cette paroi peut être externe ou interne.</p>
<p>Les ports thermiques <code><span style=\"font-family: Courier New,courier;\">T_ext</span></code> et<code><span style=\"font-family: Courier New,courier;\"> T_int</span></code> doivent être reliés à des noeuds de température (habituellement <code><span style=\"font-family: Courier New,courier;\">Tseche</span></code> et<code><span style=\"font-family: Courier New,courier;\"> Tint</span></code>). Les flux solaires incidents externes<code><span style=\"font-family: Courier New,courier;\"> FluxAbs </span></code>proviennent du modèle de conditions limites solaires <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\">SolarBC</a>.</p>
<p>Le flux incident interne <code><span style=\"font-family: Courier New,courier;\">FluxAbsInt</span></code> peut provenir des occupants, systèmes de chauffage mais aussi de la redistribution du flux solaire à l'intérieur d'une pièce (modèles du package <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\">BoundaryConditions.Radiation</a>).</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Les limites sont essentiellement liées à la linéarisation du flux GLO. Penser à distinguer la part convective et radiatif GLO dans les coefficients de convection.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis 03/2012.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Amy Lindsay 03/2014 : changement des FluxSolInput en RealInput pour les flux absorbés intérieur pour éviter les confusions (ces flux absorbés en GLO ou en CLO peuvent non seulement provenir du soleil, mais aussi d'autres sources radiatives)</p>
</html>"),      Placement(transformation(extent={{46,-50},{66,-30}})),
Documentation(info="<HTML>
<p>
Modèle de paroi éclairée assemblé à partir du modèle ParoiComplete et d'EclairementTouteSurface. 
Il reprend le TF1 de CLIM2000 à la différence près que le coefficient d'échange intégré au modèle permet de modéliser : 
<p>
- soit un échange global entre la température de surface et une ambiance, 
<p>
- soit uniquement un échange convectif vers l'air extérieur ; le noeud de surface reste disponible pour connecter un modèle d'échange radiatif (par exemple avec le ciel et le sol environnant);
 
<p>
Rm. L'entrée relative au flux solaire a vocation à être connectée au bloc météo générique ; elle contient les informations suivantes (dans l'ordre et pour mémoire) : 
<p>
- flux solaire diffus horizontal, 
<p>
- flux solaire direct normal, 
<p>
- latitude, 
<p>
- longitude, 
<p>
- TU à t0 (date du début de la simulation),
<p>
- quantième jour à t0
 </p>
EAB  avril 2010
 </HTML>
"),
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
end SimpleWall;
