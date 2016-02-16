within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model DoubleGlazingWindow
  "Double vitrage avec comme seuls paramètres U, tau et g"

//// Paramètres du modèle à renseigner
parameter Boolean useVolet=false annotation(dialog(group="Options",compact=true),choices(choice=true
        "Avec volet",                                                                                               choice=false
        "Sans volet",                                                                                                  radioButtons=true));
parameter Boolean useOuverture=false    annotation(dialog(group="Options",compact=true),choices(choice=true
        "Avec ouverture",                                                              choice=false
        "Sans ouverture",                                                                                             radioButtons=true));
    parameter Boolean useEclairement=false
     annotation(dialog(group="Options",compact=true),choices(choice=true
        "Avec calcul de l'éclairement naturel",                                                             choice=false
        "Sans calcul de l'éclairement naturel",                                                                                                  radioButtons=true));

parameter Modelica.SIunits.CoefficientOfHeatTransfer U
    "Conductivité thermique du vitrage" annotation(dialog(group="Données fabricant"));
parameter Real tau "Coefficient de transmission énergétique" annotation(dialog(group="Données fabricant"));
parameter Real g "Facteur solaire" annotation(dialog(group="Données fabricant"));

parameter Real eps=0.9 "Emissivité du vitrage en GLO" annotation(dialog(group="Données fabricant"));
parameter Modelica.SIunits.Area S=1 "Surface vitrée";
parameter Modelica.SIunits.Length H=1 "Hauteur vitre";
  parameter Modelica.SIunits.Length L=1 "Largeur vitre" annotation(dialog(enable=useEclairement));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°";

parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=21
    "Coefficient d'échange surfacique sur la face ext";
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=8.29
    "Coefficient d'échange surfacique sur la face int";
parameter Modelica.SIunits.ThermalInsulance R_volet=0.2
    "Résistance thermique additionnelle (volet fermé)" annotation(Dialog(enable=useVolet));

//// Paramètres du modèle FenetreRad calculés
protected
parameter Modelica.SIunits.CoefficientOfHeatTransfer k=1/(1/U-1/heEN673-1/hi)
    "Coefficient de transmission surfacique k du vitrage - sans échanges convectifs";
parameter Modelica.SIunits.CoefficientOfHeatTransfer heEN673=25
    "Coefficient d'échange surfacique global sur la face ext utilisé pour mesurer les propriétés du vitrage dans la norme EN 673 (détermination de U)";
    parameter Modelica.SIunits.CoefficientOfHeatTransfer heEN410=23
    "Coefficient d'échange surfacique global sur la face ext utilisé pour mesurer les propriétés du vitrage dans la norme EN 410 (Caractéristiques lumineuses et solaires des vitrages)";
parameter Modelica.SIunits.CoefficientOfHeatTransfer hi=7.7
    "Coefficient d'échange surfacique global sur la face int utilisé pour mesurer les propriétés du vitrage (En 410 et 673)";

parameter Real alpha=(g-tau)*(1/hi+1/heEN410+1/k)/(2/heEN410+1/k)
    "Coefficient d'absorption direct d'un verre";

parameter Real TrDir=tau "Coefficient de transmission direct du vitrage";
parameter Real AbsDir=alpha-tau+sqrt(tau^2+2*tau*alpha-tau*alpha^2)
    "Coefficient d'absorption direct du vitrage";

parameter Real TrDif=0.983*tau-0.068
    "Coefficient de transmission diffus du vitrage";
parameter Real AbsDif=1.17*AbsDir-0.24*AbsDir^2
    "Coefficient d'absorption diffus du vitrage";

// Facteurs de réduction des flux direct et diffus (masquage, menuiserie,...)
parameter Boolean useReduction=false
    "Prise en compte ou non des facteurs de reduction"
    annotation (Dialog(tab="Type de vitrage"));
parameter Integer TypeFenetrePF=1
    "Choix du type de fenetre ou porte-fenetre (PF)"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"),
    choices( choice= 1 "Je ne sais pas - pas de menuiserie",
             choice= 2 "Battant Fenêtre Bois",
             choice= 3 "Battant Fenêtre Métal",
             choice= 4 "Battant PF avec soubassement Bois",
             choice= 5 "Battant PF sans soubassement Bois",
             choice= 6 "Battant PF sans soubassement Métal",
             choice= 7 "Coulissant Fenêtre Bois",
             choice= 8 "Coulissant Fenêtre Métal",
             choice= 9 "Coulissant PF avec soubassement Bois",
             choice= 10 "Coulissant PF sans soubassement Bois",
             choice= 11 "Coulissant PF sans soubassement Métal"));
parameter Real voilage=0.95 "Voilage : = 0.95 si oui et = 1 sinon"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real position=0.90
    "Position du vitrage : = 0.9 si interieure et = 1 si exterieure"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real rideaux=0.85 "Presence de rideaux : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real ombrages=0.85
    "Ombrage d'obstacles (vegetation, voisinage) : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real r1=1 "Coef. réducteur pour le direct si useReduction = false"
    annotation (Dialog(tab="Type de vitrage",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));
parameter Real r2=1 "Coef. réducteur pour le diffus si useReduction = false"
    annotation (Dialog(tab="Type de vitrage",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));

// Prise en compte des flux radiatifs à l'intérieur du vitrage
public
parameter Boolean RadInterne=false
    "Prise en compte des flux radiatifs à l'intérieur" annotation(dialog(tab="Paramètres avancés",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Boolean DifDirOut=false
    "Sortie des flux direct et diffus au lieu du flux total" annotation(dialog(tab="Paramètres avancés",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Boolean GLOext=false
    "Prise en compte de rayonnement GLO vers l'environnement et le ciel" annotation(dialog(tab="Paramètres avancés",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window fenetreRad(
    S=S,
    k=k,
    hs_ext=hs_ext,
    hs_int=hs_int,
    TrDir=TrDir,
    TrDif=TrDif,
    AbsDir=AbsDir,
    AbsDif=AbsDif,
    RadInterne=RadInterne,
    DifDirOut=DifDirOut,
    incl=incl,
    choix=2,
    eps=eps,
    GLOext=GLOext,
    useVolet=useVolet,
    R_volet=R_volet,
    useOuverture=useOuverture,
    H=H,
    useReduction=useReduction,
    TypeFenetrePF=TypeFenetrePF,
    voilage=voilage,
    position=position,
    rideaux=rideaux,
    ombrages=ombrages,
    r1=r1,
    r2=r2,
    L=L,
    e=e,
    azimut=azimut,
    TLw=TLw,
    TLw_dif=TLw_dif,
    TLws=TLws,
    TLws_dif=TLws_dif,
    MasqueProche=MasqueProche,
    Protection=Protection,
    useEclairement=useEclairement)
    annotation (Placement(transformation(extent={{-36,0},{42,78}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUX[3]
    "Informations de flux solaire surfacique incident 1-Flux Diffus, 2-Flux Direct 3-Cosi"
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr if
                                                                         not
    DifDirOut "Rayonnement CLO transmis à l'intérieur" annotation (Placement(
        transformation(extent={{60,50},{100,90}}), iconTransformation(extent={{
            80,40},{100,60}})));
  Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne
    "Flux absorbés (GLO/CLO) par le vitrage sur sa face intérieure"
    annotation (Placement(transformation(extent={{120,-10},{82,28}}),
        iconTransformation(extent={{40,20},{20,40}})));
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

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr2[3] if
    DifDirOut
    "Rayonnement CLO transmis à l'intérieur 1-Diffus, 2-Direct, 3-cosi"
    annotation (Placement(transformation(extent={{60,24},{100,64}}),
        iconTransformation(extent={{80,40},{100,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if GLOext
    "Température du ciel" annotation (Placement(transformation(extent={{-100,-100},
            {-80,-80}}), iconTransformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Interfaces.RealInput fermeture_volet if      useVolet
    "taux de fermeture du volet" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,112}), iconTransformation(extent={{-88,66},{-60,94}},
          rotation=0)));
public
  Modelica.Blocks.Interfaces.BooleanInput
                                       ouverture_fenetre if useOuverture
    "true si ouvert false sinon" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,112}), iconTransformation(extent={{-48,-14},{-20,14}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput V if    useOuverture
    "Vitesse de vent normale au vitrage (m/s)" annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-100,-10},{-80,10}})));
public
  Modelica.Blocks.Interfaces.RealOutput Flum[3] if useEclairement
    "Flux lumineux transmis -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{80,-84},{126,-38}}),
        iconTransformation(extent={{80,-108},{106,-82}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Eclairement incident -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-101,81}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-92,-60})));
  parameter Real e=0.35
    "Epaisseur de la paroi verticale dans laquelle s'intègre le vitrage" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real azimut=0
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°"
                                                                                              annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Boolean MasqueProche=false
    "True si modèle de masque utilisé en amont, false sinon" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Boolean Protection=false
    "True si protection mobile extérieur en place, false sinon" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLw=0.5
    "Facteur de transmission lumineuse global de la baie sans protection" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLw_dif=0
    "Facteur de transmission lumineuse diffus de la baie sans protection" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLws=0
    "Facteur de transmission lumineuse global de la baie avec protection" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLws_dif=0
    "Facteur de transmission lumineuse diffus de la baie avec protection" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
public
  Modelica.Blocks.Interfaces.RealOutput Etp if useEclairement
    "Eclairement total incident sur la baie (lumen)"
    annotation (Placement(transformation(extent={{-23,-23},{23,23}},
        rotation=270,
        origin={3,-105}),
        iconTransformation(extent={{-13,-13},{13,13}},
        rotation=270,
        origin={1,-109})));

equation
  connect(FLUX, fenetreRad.FLUX) annotation (Line(
      points={{-100,40},{-58,40},{-58,58.5},{-8.7,58.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fenetreRad.CLOTr, CLOTr) annotation (Line(
      points={{38.1,58.5},{53.7,58.5},{53.7,70},{80,70}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fenetreRad.T_int, T_int) annotation (Line(
      points={{38.1,27.3},{53.7,27.3},{53.7,-30},{90,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fenetreRad.Ts_int, Ts_int) annotation (Line(
      points={{14.7,27.3},{14.7,-5.9},{30,-5.9},{30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fenetreRad.Ts_ext, Ts_ext) annotation (Line(
      points={{-8.7,27.3},{-8.7,-5.9},{-30,-5.9},{-30,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fenetreRad.T_ext, T_ext) annotation (Line(
      points={{-32.1,27.3},{-59.7,27.3},{-59.7,-30},{-90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fenetreRad.CLOTr2, CLOTr2) annotation (Line(
      points={{38.1,58.5},{56.7,58.5},{56.7,44},{80,44}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fenetreRad.FluxAbsInt, FluxAbsInt) annotation (Line(
      points={{14.7,46.8},{53.9,46.8},{53.9,9},{101,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_ciel, fenetreRad.T_ciel) annotation (Line(
      points={{-90,-90},{-52,-90},{-52,3.9},{-32.1,3.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fermeture_volet, fenetreRad.fermeture_volet) annotation (Line(
      points={{0,112},{0,90},{-44,90},{-44,66.3},{-32.1,66.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(V, fenetreRad.V) annotation (Line(
      points={{-100,0},{-84,0},{-84,4},{-66,4},{-66,39},{-32.1,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ouverture_fenetre, fenetreRad.ouverture_fenetre) annotation (Line(
      points={{-40,112},{-40,39},{-8.7,39}},
      color={255,0,255},
      smooth=Smooth.None));
  if useEclairement then
    connect(fenetreRad.Flum, Flum) annotation (Line(
      points={{38.1,78},{62,78},{62,-61},{103,-61}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(fenetreRad.Ecl, Ecl) annotation (Line(
      points={{-32.1,78},{-58,78},{-58,81},{-101,81}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(fenetreRad.Etp, Etp) annotation (Line(
      points={{3.39,-6.63},{3.39,-47.755},{3,-47.755},{3,-105}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
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
          fillColor={131,226,236}),
        Line(
          points={{-60,100},{-60,-100}},
          color={95,95,95},
          smooth=Smooth.None,
          thickness=1)}),             Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                              graphics),
    Documentation(info="<html>
<p>Modèle de double vitrage basé sur le modèle FenetreRad mais avec un paramétrage plus simple avec notamment la caractérisation des propriétés du vitrage en fonction des trois paramètres suivants :</p>
<ul>
<li><i>U </i>(conductivité thermique du vitrage)</li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/> (transmission énergétique de l'énergie solaire) </li>
<li><i>g</i> (facteur solaire). </li>
</ul>
<p><br><u><b>Hypothèses et équations</b></u> </p>
<p>Comme pour le modèle de vitrage générique :</p>
<ul>
<li>Les flux CLO incidents sur la face externe sont séparés en diffus et direct. Ils sont obtenus par calculs séparés après considération de l'inclinaison et de l'azimuth du vitrage. </li>
<li>Les échanges GLO avec l'environnement extérieur peuvent être pris en compte en reliant ce modèle à une température de ciel (booléen GLOext='oui' dans les paramètres avancés) et en spécifiant l'inclinaison du vitrage </li>
</ul>
<p><br>Concernant les volets roulants, les hypothèses retenues sont les suivantes:</p>
<ul>
<li>Pas de flux solaire transmis par la partie occultée par le volet</li>
<li>Flux absorbé inchangé (absorptivité du PVC proche de celle du verre)</li>
<li>Si le volet n'est pas complètement fermé (Coeff_Fermeture &LT;95%), résistance thermique inchangée</li>
<li>Si le volet est complètement fermé, résitance thermique augmentée d'une résistance thermique additionnelle, évaluée à 0.2 m&sup2;K/W (épaisseur de PVC de 12 mm env.)</li>
</ul>
<p><br>Lorsque la fenêtre est ouverture, il y a &QUOT;rupture&QUOT; de la conductance à travers la vitre, et à la place un débit de renouvellement d'air par ventilation naturelle est calculé (voir <a href=\"modelica://BuildSysPro.Building.AirFlow.HeatTransfer.WindowNaturalVentilation\">WindowNaturalVentilation</a>).</p>
<p><br>Des coefficients de réduction des flux direct et diffus peuvent également être pris en compte (si UseReduction=True), en fonction de :</p>
<ul>
<li>type de fenêtres/ portes fenêtres (le % de menuiserie en est déduit)</li>
<li>coefficient représentant la diminution des flux à travers les voilages</li>
<li>coefficient représentant la diminution des flux en raison de la position de la fenêtre (intérieure ou extérieure)</li>
<li>coefficient représentant la diminution des flux à travers les rideaux.</li>
<li>coefficient représentant la diminution des flux en raison d'ombrages (NB: il existe aussi un modèle qui permet de calculer de façon précise les flux surfaciques sur une paroi verticale en cas de débords :  <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.SolarMasks.FLUXsurfMask\">FLUXsurfMask</a>)</li>
</ul>
<p>On considère de plus que :</p>
<ul>
<li>Le coefficient U du vitrage est donné par le fabricant pour <code><span style=\"font-family: Courier New,courier;\">heEN673</span></code>=25 W/m&sup2;.K et hi=7,7 W/m&sup2;.K (norme EN673) </li>
<li>Les coefficients d'absorption et de transmission sont calculés pour <code><span style=\"font-family: Courier New,courier;\">heEN410</span></code>=23 W/m&sup2;.K et hi=7,7 W/m&sup2;.K (norme EN410) </li>
<li>Les propriétés du verre extérieur sont considérées identiques à celles du verre intérieur (<img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/>, <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau.png\" alt=\"tau\"/>  et <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-o2Vygno2.png\" alt=\"rho\"/>)</li>
<li>Les coefficients d'absorption et de réflexion du verre utilisé sont considérés indépendants de la direction</li>
<li>Les coefficients pour le rayonnement diffus sont issus des formules de Cadiergues</li>
<li>La transmittivité directe du vitrage est calculée en fonction de l'angle d'incidence selon les formules de la RT</li>
</ul>
<p><br>Le modèle FenetreRad a besoin de connaître le coefficient de transmission surfacique <i>k</i> du vitrage ainsi que les coefficients de transmissions et d'absorption direct et diffus (<i>TrDir</i>, <i>TrDif</i>, <i>AbsDir</i> et <i>AbsDif</i>). </p>
<p><i>k</i> est déterminé directement en fonction de <i>U</i> selon la norme EN673 : <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-FvfBsv4U.png\" alt=\"1/k = 1/U - 1/he - 1/hi\"/>  où he=25 et hi=7.7 W/m&sup2;.K </p>
<p>Ensuite, sachant que <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-D2vKnZ8U.png\" alt=\"g=tau_0+q_i\"/>, où qi est le facteur de réémission thermique vers l'intérieur du vitrage </p>
<p>et que <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-8MhqSdry.png\" alt=\"q_i=(2*alpha/he+alpha/k)/(1/he+1/hi+1/k)\"/>  où he=23 et hi=7.7 W/m&sup2;.K (norme EN410). On considère le coefficient d'absorption directe de l'énergie solaire du verre extérieur identique à celle du verre intérieur.</p>
<p>On détermine le coefficient d'absorption <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/> du verre : <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-nP3B5gfM.png\" alt=\"alpha=q_i*(1/he+1/hi+1/k)/(2/he+1/k)\"/> </p>
<p><br>Les coefficients d'absorption et de transmission, par le double vitrage (<img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha0.png\" alt=\"alpha_0\"/> et <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/>), du rayonnement direct pour une incidence normale sont ensuite déterminés en considérant les lois de réflexion et transmission dans un double vitrage avec un verre de propriétés <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/>, <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau.png\" alt=\"tau\"/>  et <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-o2Vygno2.png\" alt=\"rho\"/>. </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-m3qW2Cwk.png\" alt=\"tau_0=tau^2/(1-rho^2)\"/> </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-STEihD6L.png\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-QsKZWFtl.png\"/></p>
<p><br>Connaissant <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/> et <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/> on en déduit <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha0.png\" alt=\"alpha_0\"/> après résolution du système d'équations ci-dessus </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-qPfx1u3Y.png\"/></p>
<p><br>On en déduit les coefficient concernant le rayonnement direct : </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-KIFEKL9z.png\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-hWbo2Tq3.png\"/></p>
<p><i>Remarque : ces coefficient sont ceux ensuite utilisés dans le block PondTransDirect qui utilise une corrélation pour déterminer ces coefficients en fonction de l'angle d'incidence. La pondération utilisée est alors celle spécifiée dans la RT.</i> </p>
<p><br>On utilise ensuite les relations de Cadiergues pour le rayonnement diffus </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-RUGaOnGV.png\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-2SHxA04v.png\"/></p>
<p>Concernant le calcul de l'éclairement naturel, les facteurs de transmission lumineuse global et diffus qui doivent être renseignés correspondent aux TLw, TLw_dif, TLsw et TLsw_dif qui sont calculés précisément dans la norme EN 410. Cependant, il est possible de retrouver des valeurs tabulées dans le document <i>Valeurs tabulées des caractéristiques des parois vitrées et des correctifs associés aux baies</i> du CSTB. Ainsi, par défaut: </p>
<ul>
<li>Pour du double vitrage sans protection solaire: TLw=0.5, TLw_dif=0</li>
<li>Pour du double vitrage avec protection solaire opaque et sombre située à l'extérieur: TLsw=0, TLsw_dif=0</li>
<li>Pour du double vitrage avec protection solaire non opaque et claire située à l'extérieur: TLsw=0.09, TLsw_dif=0.03</li>
</ul>
<p><br><u><b>Bibliographie</b></u> </p>
<p>Normes EN410 et EN673 </p>
<p>R. Cadiergues, 1978, <i>L'absorption du rayonnement par les vitrages et son calcul</i>. 1-Les vitrages non réfléchissants, Promoclim E, Etudes Thermique et Aérauliques, Tome 9 E, n&deg;1 </p>
<p>R. Cadiergues, 1978, <i>Un mode simple de calcul des flux à travers les vitrages</i>. 1-Les vitrages non traités, Promoclim E, Etudes Thermique et Aérauliques, Tome 9 E, n&deg;1 </p>
<p>Eclairement naturel : Règles Th-L - Caractérisation du facteur de transmission lumineuse des parois du bâtiment - CSTB Mars 2012, Valeurs tabulées des parois vitrées - CSTB Mars 2012</p>
<p><br><u><b>Mode d'emploi</b></u> </p>
<p>Les ports thermiques <b>T_ext</b> et <b>T_int</b> doivent être reliés à des noeuds de température (habituellement Tseche et Tint).</p>
<p>Les flux incidents externes <b>FLUX</b> peuvent provenir des modèles de conditions limites du package <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar\">BoundaryConditions.Solar</a> qui font la liaison entre les parois et les lecteurs Météo.</p>
<p>Le flux incident interne <b>FluxAbsInt</b> peut provenir des occupants, systèmes de chauffage mais aussi de la redistribution du flux solaire à l'intérieur d'une pièce (modèles du package <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\">BoundaryConditions.Radiation</a>).</p>
<p><br><u><b>Limites connues du modèle / Précautions d'utilisation</b></u> </p>
<ul>
<li>Les coefficients de convection interne et externe peuvent être pris différents de ceux utilisés pour la norme pour les calculs thermiques </li>
<li>Il ne faut pas confondre le coefficient <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/> avec TL qui est la transmission lumineuse donnée souvent par les fabricants</li>
</ul>
<p>Dans le cas du calcul de l'éclairement il faut penser à préciser s'il existe des masques en amont car alors la prise en compte des ombres dues à l'architecture se fait dans le modèle de masque.</p>
<p><u><b>Validations effectuées</b></u> </p>
<p>Modèle validé en vérifiant que les coefficients d'absorption et de transmission du rayonnement direct et diffus ainsi que les conductivités en entrée du modèle FenetreRad étaient bien conformes à celles déterminées via une feuille Excel sur la base des formules des normes utilisées. </p>
<p><br>Modèle validé - Aurélie Kaemmerlen 05/2011 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 06/2011 :</p>
<ul>
<li>Introduction coefficient normatif EN 410 et 673 pour he (respectivement 23 et 25 W/m&sup2;/K) et hi à 7.7W/m&sup2;/K</li>
<li>k (conductance thermique du vitrage) est alors déterminé par he et hi de EN 673 au lieu de hs_ext et hs_int qui sont utilisées dans les calculs thermiques </li>
</ul>
<p>Aurélie Kaemmerlen 10/2011 : Ajout des échanges avec l'environnement (ciel et sol) </p>
<ul>
<li>Un nouveau booléen a été ajouté pour permettre de considérer ou non ces deux échanges</li>
<li>L'inclinaison et l'émissivité en GLO du vitrage ont ainsi été ajoutées pour caractériser ces échanges</li>
<li>La transmittivité directe est calculée par la formule de la RT</li>
</ul>
<p><br>Amy Lindsay 03/2014 : - ajout de la possibilité de commander un volet (fermeture_volet qui varie entre 0 et 1 - 1 quand le volet est fermé, 0 quand le volet est ouvert), avec la résistance thermique supplémentaire que cela engendre.</p>
<p>- ajout de la possibilité d'ouvrir la fenêtre (true quand la fenêtre est ouverte, false quand elle est fermée) avec le débit de ventilation naturelle que cela engendre</p>
<p>- ajout des coefficients de réduction des flux diffus/direct en fonction du type de fenêtre / porte fenêtre, de la présence de voilages, rideaux etc. issus des stages de Raphaelle Mrejen (2012) et Alexandre Hautefeuille (2013)</p>
<p>- changement des FluxSolInput en RealInput pour les flux absorbés intérieur pour éviter les confusions (ces flux absorbés en GLO ou en CLO peuvent non seulement provenir du soleil, mais aussi d'autres sources radiative)</p>
<p>Laura Sudries, Vincent Magnaudeix 05/2015 : Prise en compte des flux lumineux incidents sur la baie pour calculer les flux lumineux transmis à travers la baie considérée (direct, diffus, réfléchi par le sol) et l'éclairement total incident sur la baie. Equations issues de la RT2012.</p>
<p>Gilles Plessis 07/2015 : Homogénéisation des paramètres avec ceux du modèle <code>Window</code>.</p>
</html>"));
end DoubleGlazingWindow;
