within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model SimpleGlazing "Modèle de vitrage simple"

// Propriétés générales

parameter Boolean useVolet=false "Présence d'un volet" annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Boolean GLOext=false
    "Prise en compte du rayonnement GLO (infrarouge) entre la paroi et l'environnement et le ciel sous forme linéarisée"
    annotation(dialog(group="Options",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Modelica.SIunits.Area S=1 "Surface vitrée"
                                                     annotation(dialog(group="Propriétés générales"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=16
    "Coefficient d'échange surfacique convectif ou global sur la face extérieure en fonction du mode choisi (GLOext)"
                                                                                                        annotation(dialog(group="Propriétés générales"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=8.29
    "Coefficient d'échange surfacique GLOBAL sur la face intérieure" annotation(dialog(group="Propriétés générales"));
parameter Modelica.SIunits.ThermalInsulance R_volet=0.2
    "Résistance thermique additionnelle (volet fermé)"                                                          annotation(Dialog(group="Propriétés générales",enable=useVolet==true));
parameter Modelica.SIunits.CoefficientOfHeatTransfer k=1.43
    "Coefficient de transmission surfacique Ug du vitrage - sans échanges convectifs"
                                                                                      annotation(dialog(group="Propriétés générales"));
parameter Real skyViewFactor=0
    "Facteur de forme moyen entre les vitrages et le ciel (exemple: skyViewFactor(toiture terrase)=1, skyViewfactor(paroi verticale en environnement dégagé)=0.5)"
                                                                                                        annotation(dialog(enable=GLOext,group="Propriétés générales"));

// Propriétés optiques
parameter Real Tr=0.544 "Coefficient de transmission fenêtre" annotation(dialog(group="Propriétés optiques"));
parameter Real Abs=0.1 "Coefficient d'absorption de la fenêtre" annotation(dialog(group="Propriétés optiques"));
parameter Real eps=0.9 "Emissivité" annotation(dialog(enable=GLOext,group="Propriétés optiques"));

// Composants publiques
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxTr
    "Informations de flux solaire global pour la transmission. Doit intégrer l'impact de l'incidence."
    annotation (Placement(transformation(extent={{-120,50},{-80,90}}),
        iconTransformation(extent={{-40,10},{-20,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt
    "Flux CLO surfacique incident sur la face extérieure" annotation (
      Placement(transformation(extent={{-120,20},{-80,60}}), iconTransformation(
          extent={{-40,40},{-20,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr
    "Rayonnement CLO transmis à l'intérieur" annotation (Placement(
        transformation(extent={{60,50},{100,90}}), iconTransformation(extent={{
            80,40},{100,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température extérieure" annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}}), iconTransformation(extent={{-100,-40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Température de surface extérieure" annotation (Placement(transformation(
          extent={{-40,-40},{-20,-20}}), iconTransformation(extent={{-40,-40},{
            -20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Température de surface intérieure" annotation (Placement(transformation(
          extent={{20,-40},{40,-20}}), iconTransformation(extent={{20,-40},{40,
            -20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Température intérieure" annotation (Placement(transformation(extent={{80,
            -40},{100,-20}}), iconTransformation(extent={{80,-40},{100,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if GLOext
    "Température de ciel pour le rayonnement GLO" annotation (Placement(
        transformation(extent={{-100,-100},{-80,-80}}), iconTransformation(
          extent={{-100,-100},{-80,-80}})));
public
  Modelica.Blocks.Interfaces.RealInput fermeture_volet if      useVolet==true
    "taux de fermeture du volet" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={6,110}), iconTransformation(extent={{-100,66},{-72,94}},
          rotation=0)));

// Composants internes

protected
  BaseClasses.HeatTransfer.Components.ControlledThermalConductor echange_a1
    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCLOAbsExt
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={-75,5})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor echange_int(G=hs_int*
        S) annotation (Placement(transformation(extent={{52,-70},{72,-50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor echange_ext(G=hs_ext*
        S) annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

Modelica.Blocks.Math.Gain FluxAbsorbe(k=S*Abs)                     annotation (Placement(transformation(extent={{-7,-7},
            {7,7}},
        rotation=180,
        origin={-55,3})));
Modelica.Blocks.Math.Gain FluxTransmis(k=S*Tr) annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={43,69})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.LinearExtLWR gLOextLinear(
    S=S,
    eps=eps,
    skyViewFactor=skyViewFactor) if GLOext
    annotation (Placement(transformation(extent={{-70,-98},{-50,-78}})));
protected
  Modelica.Blocks.Interfaces.RealInput volet_internal
     annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-140,80}), iconTransformation(extent={{-88,66},{-60,94}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput G_internal annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-140,0}), iconTransformation(extent={{-88,66},{-60,94}},
          rotation=0)));
equation

  //Le flux est transmis uniquement par la fenêtre (volet occultant)
  FluxTransmis.u=(1-volet_internal)*FluxTr;

  //Calcul de la conductance thermique de la fenêtre complète (vitrage+volet) hors convections
  if useVolet then
    if volet_internal>=0.95 then
      G_internal=S/(1/k+R_volet);
    else
      G_internal=k*S;
    end if;
  else
    G_internal=k*S;
  end if;

  if not useVolet then
    volet_internal=0;
  end if;

  connect(echange_ext.port_b, Ts_ext) annotation (Line(
      points={{-51,-60},{-30,-60},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_ext, echange_ext.port_a) annotation (Line(
      points={{-90,-30},{-90,-60},{-69,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ts_ext, echange_a1.port_a) annotation (Line(
      points={{-30,-30},{-20,-30},{-20,-60},{-11,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(echange_a1.port_b, Ts_int) annotation (Line(
      points={{7,-60},{20,-60},{20,-30},{30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ts_int, echange_int.port_a) annotation (Line(
      points={{30,-30},{28,-30},{28,-60},{53,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(echange_int.port_b, T_int) annotation (Line(
      points={{71,-60},{90,-60},{90,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsExt.port, Ts_ext) annotation (Line(
      points={{-82.7,4.02},{-92,4.02},{-92,-12},{-30,-12},{-30,-30}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(FluxAbsorbe.y, prescribedCLOAbsExt.Q_flow) annotation (Line(
      points={{-62.7,3},{-62.35,3},{-62.35,4.02},{-68.7,4.02}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluxIncExt, FluxAbsorbe.u) annotation (Line(
      points={{-100,40},{-29,40},{-29,3},{-46.6,3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(CLOTr, FluxTransmis.y) annotation (Line(
      points={{80,70},{65.35,70},{65.35,69},{50.7,69}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(gLOextLinear.Ts_p, Ts_ext) annotation (Line(
      points={{-51,-88},{-30,-88},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(gLOextLinear.T_ciel, T_ciel) annotation (Line(
      points={{-69,-93},{-77.5,-93},{-77.5,-90},{-90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gLOextLinear.T_ext, T_ext) annotation (Line(
      points={{-69,-83},{-74,-83},{-74,-70},{-90,-70},{-90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volet_internal, fermeture_volet) annotation (Line(
      points={{-140,80},{6,80},{6,110}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(G_internal, echange_a1.G) annotation (Line(
      points={{-140,0},{-2,0},{-2,-52}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
   annotation (Placement(transformation(extent={{-64,-44},{-44,-24}})),
      Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-98,132},{104,96}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-92,-30},{92,-30}},
          smooth=Smooth.None,
          color={0,0,0}),
        Rectangle(
          extent={{-20,100},{20,-100}},
          lineColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={131,226,236})}),
    Documentation(info="<html>
<h4>Modèle de vitrage simple linéaire</h4>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle est un modèle de fenêtre simple. Les flux courte longueur d'onde (CLO) incidents sont des flux globaux surfaciques. L'influence de l'angle d'incidence sur la transmission du flux direct (non linéaire) est externalisée et par conséquent non décrit dans ce modèle. </p>
<p>Les échanges en grande longueur d'onde (GLO) sont linéarisés grâce au modèle <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.LinearExtLWR\">LinearExtLWR</a>. Le paramètre <code><span style=\"font-family: Courier New,courier;\">skyViewFactor</span></code> permet de déterminer la part de rayonnement grande longueur d'onde de la paroi avec le ciel, considéré à <code><span style=\"font-family: Courier New,courier;\">T_cie</span></code>l, et l'environnement extérieur, considéré à <code><span style=\"font-family: Courier New,courier;\">T_ext</span></code>.</p>
<p>Le coefficient <code><span style=\"font-family: Courier New,courier;\">k</span></code> représente la conductivité du vitrage sans prise en compte des échanges convectifs (différent du Ug ou Uw usuellement utilisé). Le coefficient d'échange convectif avec l'extérieur <code><span style=\"font-family: Courier New,courier;\">hs_ex</span></code>t par défaut est la valeur du coefficient intégrant uniquement la convection. Les échanges GLO étant pris en compte par ailleurs.</p>
<p>Ce modèle conduit à un modèle linéaire invariant dans le temps qu'il est possible de réduire.</p>
<p>Concernant les volets roulants, les hypothèses retenues sont les suivantes:</p>
<ul>
<li>Pas de flux solaire transmis par la partie occultée par le volet</li>
<li>Flux absorbé inchangé (absorptivité du PVC proche de celle du verre)</li>
<li>Si le volet n'est pas complètement fermé (Coeff_Fermeture &LT;95%), résistance thermique inchangée</li>
<li>Si le volet est complètement fermé, résitance thermique augmentée d'une résistance thermique additionnelle, évaluée à 0.2 m&sup2;K/W (épaisseur de PVC de 12 mm env.)</li>
</ul>
<p><br><u><b>Bibliographie</b></u></p>
<p><a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\">Modèle de vitrage de BuildSysPro</a> modifié dans le but d'obtenir un modèle linéaire et invariant dans le temps pour les besoins de l'étude sur les villes.</p>
<p>CSTB. 2005. Guide réglementaire RT 2005. Règle d'application Th-Bât Th-U 3/5 Parois vitrées.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Les ports thermiques <code><span style=\"font-family: Courier New,courier;\">T_ext</span></code> et <code><span style=\"font-family: Courier New,courier;\">T_int</span></code> doivent être reliés à des noeuds de température (habituellement Tseche et <code><span style=\"font-family: Courier New,courier;\">Tint</span></code>). Les flux incidents externes <code><span style=\"font-family: Courier New,courier;\">FluxAbs</span></code> et <code><span style=\"font-family: Courier New,courier;\">FluxTr</span></code> proviennent du modèle de conditions limites solaires <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\">SolarBC</a>. La correspondance entre leurs paramètres doit être faite. </p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Les limites sont essentiellement liées à la linéarisation du flux GLO et à l'externalisation de l'influence de l'incidence sur les flux CLO transmis.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Gilles Plessis 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 03/2014 : ajout de la possibilité de commander un volet (fermeture_volet qui varie entre 0 et 1 - 1 quand le volet est fermé, 0 quand le volet est ouvert), avec la résistance thermique supplémentaire que cela engendre.</p>
<p>Gilles Plessis 07/2015 : ajout de la possibilité optionnelle de prise en compte du rayonnement GLO linéarisé.</p>
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
end SimpleGlazing;
