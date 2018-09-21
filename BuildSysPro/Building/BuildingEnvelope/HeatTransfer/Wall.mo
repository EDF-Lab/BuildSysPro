within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model Wall
  "Generic wall model - conventional, resistive or water-based heating wall"

// Inclusion of wall options
 parameter Integer ParoiActive=1
      annotation(Dialog(group="Type of wall"),
      choices(choice=1 "Conventional wall",
      choice=2 "Water-based heating wall",
      choice=3 "Electric radiant wall",radioButtons=true));

  parameter Boolean RadInterne=false
    "Integration of flows which are absorbed on the inner face"
    annotation(Dialog(group="Options"),choices(choice=true "yes", choice=false "no", radioButtons=true));
  parameter Boolean ParoiInterne=false "Wall position"
    annotation(Dialog(group="Type of wall"),choices(choice=true "Internal wall",               choice=false
        "Outer wall",                                                                                                  radioButtons=true));

  parameter Boolean RadExterne=false
    "In case of internal wall, integration of flows which are absorbed on the external face"
    annotation(Dialog(group="Options"),choices(choice=true "yes", choice=false "no", radioButtons=true));
  parameter Boolean GLOext=false
    "Integration of LW radiation (infrared) between the wall, the environment and the sky"
    annotation(Dialog(group="Options"),choices(choice=true "yes", choice=false "no", radioButtons=true));

// General parameters
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°"
    annotation(Dialog(enable=GLOext, group="General properties of the wall"));

  parameter Modelica.SIunits.Area S=1 "Wall surface without windows"
    annotation(Dialog(group="General properties of the wall"));

  parameter Modelica.SIunits.Temperature Tp=293.15
    "Initial temperature of the wall"
    annotation(Dialog(group="General properties of the wall"));

  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (Dialog(group="General properties of the wall"));

  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=25
    "Global or convective surface exchange coefficient on the outer face depending on the selected mode (GLOext)"
     annotation(Dialog(group="General properties of the wall"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=7.69
    "Surface exchange coefficient on the inner face"
    annotation(Dialog(group="General properties of the wall"));
  parameter Real alpha_ext=0.6
    "Absorption coefficient of the outer walls in the visible (around 0.3 for clear walls and 0.9 for dark shades)"
    annotation(Dialog(enable=(not ParoiInterne), group="General properties of the wall"));
  parameter Real eps=0.9 "Emissivity of the outer surface of the wall in LWR (concrete 0.9)"
    annotation(Dialog(enable=GLOext, group="General properties of the wall"));

// Composition of the wall
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoi
    "Wall characteristics" annotation (choicesAllMatching=true,
      Dialog(group="Type of wall"));

// Parameter common to resistive and water-based heating walls
 parameter Integer nP=1
    "Number of the layer whose upper border is the site of power injection - must be strictly lower than n"
    annotation (Dialog(enable=not
                                 (ParoiActive==1), group="Type of wall"));

// Parameters specific to a water-based heating wall
  parameter Integer nD=8 "Number of discretization slices of the water floor"
    annotation(Dialog(enable=ParoiActive==2, tab="Water-based heating wall parameters"));
  parameter Modelica.SIunits.Distance Ltube=128 "Floor heating coil length"
    annotation(Dialog(enable=ParoiActive==2, tab="Water-based heating wall parameters"));
  parameter Modelica.SIunits.Distance DiametreInt=0.013
    "Inside diameter of the tube"
    annotation(Dialog(enable=ParoiActive==2, tab="Water-based heating wall parameters"));
  parameter Modelica.SIunits.Distance eT=0.0015 "Tube thickness"
    annotation (Dialog(enable=ParoiActive==2, tab="Water-based heating wall parameters"));
  parameter Modelica.SIunits.ThermalConductivity lambdaT=0.35
    "Thermal conductivity of the tube"
    annotation (Dialog(enable=ParoiActive==2, tab="Water-based heating wall parameters"));

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
    "Wall surface divided into nD active walls with water circulation inside"
    annotation (Placement(transformation(extent={{-8,-44},{16,-20}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Exterior temperature" annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}}), iconTransformation(extent={{-100,-40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Indoor temperature" annotation (Placement(transformation(extent={{80,
            -40},{100,-20}}), iconTransformation(extent={{80,-40},{100,-20}})));
Modelica.Blocks.Math.Gain AbsMurExt(k=alpha_ext*S) if  (not ParoiInterne)
    annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-35,71})));
Modelica.Blocks.Math.Add add if (not ParoiInterne)
    annotation (Placement(transformation(extent={{-72,64},{-58,78}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt[3] if not
    ParoiInterne
    "Surface incident solar flux information 1-Diffuse Flux [W/m2], 2-Direct Flux [W/m2], 3-Cosi"
    annotation (Placement(transformation(extent={{-119,52},{-81,90}}),
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
        origin={48,52})));
Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne "Flows (SWR/LWR) absorbed by this wall on its inner face [W]"
    annotation (Placement(transformation(extent={{138,50},{100,88}}),
        iconTransformation(extent={{40,40},{20,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Outside temperature at the wall surface" annotation (Placement(
        transformation(extent={{-40,-40},{-20,-20}}), iconTransformation(extent=
           {{-40,-40},{-20,-20}})));
Modelica.Blocks.Interfaces.RealInput                            FluxAbsExt if
    RadExterne and ParoiInterne
    "Flows (SWR/LWR) absorbed by this wall on its outer face [W]"
    annotation (Placement(transformation(extent={{-120,9},{-80,51}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCLOAbsExt2 if
    RadExterne and ParoiInterne annotation (Placement(transformation(
        extent={{8,8},{-8,-8}},
        rotation=180,
        origin={-60,30})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtLWR EchangesGLOext(
    S=S,
    eps=eps,
    incl=incl,
    GLO_env=GLOext,
    GLO_ciel=GLOext) if GLOext
    annotation (Placement(transformation(extent={{-66,-70},{-46,-50}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky if  GLOext
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}}),
        iconTransformation(extent={{-100,-100},{-80,-80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Inside temperature at the wall surface" annotation (Placement(
        transformation(extent={{30,-40},{50,-20}}), iconTransformation(extent={
            {20,-40},{40,-20}})));
  Modelica.Blocks.Interfaces.RealInput WaterIn[2] if   ParoiActive==2
    "Vector containing 1-the fluid temperature (K), 2-the flow (kg/s)"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2] if  ParoiActive==2
    "Vector containing 1-the fluid temperature (K), 2-the flow (kg/s)"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}}),
        iconTransformation(extent={{80,-80},{100,-60}})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor Echange_a(G=hs_ext*
        S) annotation (Placement(transformation(extent={{-68,-40},{-48,-20}},
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
    "Electric power injected into the floor"    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={10,100}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));
equation
if ParoiActive==1 then
  //slices connection in the case of a conventional wall
  connect(ParoiNCouchesHomogenes.port_a, Ts_ext);
  connect(ParoiNCouchesHomogenes.port_b, Ts_int);
elseif ParoiActive==2 then
//connection of the nD slices in the case of a heating with water wall
  for i in 1:nD loop
    connect(paroiActiveEau[i].Ts_b, Ts_int);
    connect(paroiActiveEau[i].Ts_a, Ts_ext);
  end for;
    connect(paroiActiveEau[1].WaterIn, WaterIn);
  for i in  2:nD loop
      connect(paroiActiveEau[i - 1].WaterOut, paroiActiveEau[i].WaterIn);
  end for;
    connect(paroiActiveEau[nD].WaterOut, WaterOut);

else // ParoiActive==3
  //slices connection in the case of a electric heating wall
  connect(Ts_ext, ParoiChauffanteElec.Ts_a);
  connect(ParoiChauffanteElec.Ts_b, Ts_int);
  connect(PelecPRE, ParoiChauffanteElec.PelecIn);
end if;

  connect(add.y, AbsMurExt.u) annotation (Line(
      points={{-57.3,71},{-48.2,71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AbsMurExt.y, prescribedCLOAbsExt.Q_flow) annotation (Line(
      points={{-22.9,71},{-16,71},{-16,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.Q_flow, FluxAbsInt)
                                              annotation (Line(
      points={{48,60},{48,69},{119,69}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u1, FluxIncExt[2]) annotation (Line(
      points={{-73.4,75.2},{-88.7,75.2},{-88.7,71},{-100,71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u2, FluxIncExt[1]) annotation (Line(
      points={{-73.4,66.8},{-100,66.8},{-100,58.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedCLOAbsExt2.Q_flow, FluxAbsExt)
                                                  annotation (Line(
      points={{-68,30},{-100,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_sky, EchangesGLOext.T_sky) annotation (Line(
      points={{-90,-90},{-74,-90},{-74,-64},{-65,-64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, EchangesGLOext.T_ext)
                                   annotation (Line(
      points={{-90,-30},{-75,-30},{-75,-56},{-65,-56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EchangesGLOext.Ts_ext, Ts_ext) annotation (Line(
      points={{-47,-60},{-30,-60},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.port, Ts_int) annotation (Line(
      points={{48,44},{48,35.6},{40,35.6},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsExt2.port, Ts_ext) annotation (Line(
      points={{-52,30},{-52,30},{-30,30},{-30,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsExt.port, Ts_ext) annotation (Line(
      points={{-16,48},{-16,30},{-30,30},{-30,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Echange_a.port_b, Ts_ext) annotation (Line(
      points={{-49,-30},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_ext, Echange_a.port_a) annotation (Line(
      points={{-90,-30},{-67,-30}},
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
    annotation(Dialog(enable=BoolActiveEau, tab="Heating wall Parameters", group="Layers between the outside and the heating coil integrated in the wall"),
      Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
            100,100}}),        graphics={Text(
          extent={{-6,-5},{10,-15}},
          lineColor={0,128,0},
          textString="OR"),                                      Text(
          extent={{-6,-47},{10,-57}},
          lineColor={0,128,0},
          textString="OR")}),
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
<p><u><b>Hypothesis and equation</b></u></p>
<ul>
<li>This wall can be an inner wall or an outer wall. Depeding on the configuration, longwave or shortwave radiations can be considered on its faces</li>
<li>A heat transfer by conduction occurs in the material which is defined by <code>n</code> homogeneous layers (each layer is discretized in <code>m</code> equidistant meshes)</li>
<li>Heat transfers by convection occurs on the two internal and external faces</li></ul>
<p>Available heating options :</p>
<ul>
<li>This wall can be heated (or cooled) by an hydraulic system integrated by discretization in <code>nD</code> slices of the floor surface. A sensitivity analysis has allowed to define the default value of <code>nD</code> = 8 which can be with variable pitch</li>
<li>This wall can also integrate a heating element (ex. electric radiant floor - PRE). The real port <code>PelecPRE</code> allows to inject a thermal power to model heating floor cables</li>
</ul>
<p>SWR solar fluxes are divided into :</p>
<ul>
<li>Direct and diffuse incident on the external faces flows</li>
<li>The diffuse solar flux transmitted in the room and reflected by the room internal surface areas and which is received by the internal face</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>TF1 CLIM2000</p>
<p><u><b>Instructions for use</b></u></p>
<p>The thermal ports <code>T_ext</code> and <code>T_int</code> must be connected to temperature nodes (connect <code>T_ext</code> to <code>T_dry</code> of <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Meteofile\"><code>Meteofile</code></a>).</p>
<p>The external incident flows <code>FLUX</code> can come from models <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar\"><code>BoundaryConditions.Solar</code></a> models, which are the link between walls and weather readers.</p>
<p>The internal incident flows <code>FluxAbsInt</code>, activated by the parameter <code>RadInterne</code>, can come from occupants, heating systems but also from the redistribution of solar flux within a room (models from <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\"><code>BoundaryConditions.Radiation</code></a> package).</p>
<p>In the same way, and in case of inner wall, the internal incident flows <code>FluxAbsExt</code> on the other face of the wall (face named \"external\") can be activated by the parameter <code>RadExterne</code>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Warning, default values of convective coefficients are indicative only, and should not be taken as real values in all cases.</p>
<p>The given exchange coefficients can be either global coefficients (sum of convective and radiative), or purely convective exchanges if radiative exchanges are treated elsewhere.</p>
<ul>
<li>If <code>GLOext = True</code>, then <code>hs_ext</code> is a purely convective coefficient</li>
<li>5,15 W/m&sup2;.K outside and 5.71 W:m&sup2;.K inside can be removed from the value of the recommended global exchange coefficient.</li>
</ul>
<p>Some indications :</p>
<ul>
<li>Vertical surfaces: <code>hs_int</code> = 7.69, <code>hs_ext</code> = 25</li>
<li>Horizontal surfaces: <code>hs_int</code> = 10, <code>hs_ext</code> = 25</li>
</ul>
<p><u><b>Validations</b></u></p>
<p>BESTEST validation procedure</p>
<p>Validated model - Aurélie Kaemmerlen 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 : </p>
<ul>
<li>Ajout du choix de considérer ou non des flux absorbés (CLO ou GLO) sur les 2 faces via 2 booléens RadInterne et RadExterne</li>
<li>Ajout d'une liste déroulante pour le choix des matériaux via l'annotation(choicesAllMatching=true)</li>
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
<li>Gilles Plessis 06/2012 : Insertion du record ParoiGenerique pour le paramètrage des caractéristiques de la paroi sous une forme &quot;replaceable&quot;, Protection des composants internes pour éviter le trop grand nombre de variables lors de l'exploitation des résultats de simulation.</li>
<li>Remarque GP : Le &quot;modifier&quot; replaceable est obligatoire pour autoriser la taille variable de ParoiGenerique (Erreur dans le check d'un modèle utilisant la paroi). Il permet aussi d'envisager l'utilisation de matériaux à changement de phase dans les couches de parois.</li>
</ul>
<p><br>Aurélie Kaemmerlen 10/2012 : Correction de l'inversion depuis la dernière version des hs_int et hs_ext</p>
<p>Aurélie Kaemmerlen 09/2013 : Changement des hs par défaut (correspondent désormais à ceux de surfaces verticales)</p>
<p>Aurélie Kaemmerlen 12/2013 : Modification de la valeur par défaut de l'émissivité : 0.9 (béton) au lieu de 0.6</p>
<p>Amy Lindsay 03/2014 : changement des FluxSolInput en RealInput pour les flux absorbés extérieur et intérieur pour éviter les confusions (ces flux absorbés en GLO ou en CLO peuvent non seulement provenir du soleil, mais aussi d'autres sources radiatives ; de plus, le flux solaire est déjà absorbé via le FLUX[3])</p>
<p>Hassan Bouia 04/2014 : au vu des changements de ParoiNCouchesHomogenes, pour décrire une ParoiNEW, il n'est plus possible d'écrire l'égalité des records caracParoi=caracParoi; il faut étendre cette définition (caracParoi(n=caracParoi.n, m=caracParoi.m, mat=caracParoi.mat, e=caracParoi.e, positionIsolant=caracParoi.positionIsolant)).</p>
</html>"));
end Wall;
