within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneCrawlSpace
  "Model of a zone on a crawl space in pure thermal modelling"

 parameter Modelica.SIunits.Volume Vair "Indoor air volume";
 parameter Real beta=0
    "Correction of vertical walls azimuth (azimuth=azimuth{0,90,180,-90}+beta)";

 parameter Boolean ChoixPint=false
    "Consideration of radiative contributions in proportion to surfaces" annotation (
      choices(choice=true "Yes",
      choice=false "No",radioButtons=true));
 parameter Boolean ChoixGLOext=false
    "Consideration of LW radiation (infrared) between vertical walls and the sky"
    annotation(choices(choice=true "Yes : warnings, hext purely convective", choice=false "No", radioButtons=true));

 parameter Modelica.SIunits.Temperature Tair=293.15
    "Indoor air initial temperature" annotation(Dialog(enable = not  InitType== Utilitaires.Types.InitCond.SteadyState,group="Initialisation parameters"));
 parameter Modelica.SIunits.Temperature Tp=293.15 "Walls initial temperature"
                                annotation (Dialog(group="Initialisation parameters"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (Dialog(group="Initialisation parameters"));

//Vertical walls//
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    CaracParoiVert "Vertical walls characteristics" annotation (
      choicesAllMatching=true, Dialog(tab="Vertical walls"));
parameter Modelica.SIunits.Area S1nv=1 "South wall surface (unglazed)"  annotation(Dialog(tab="Vertical walls"));
parameter Modelica.SIunits.Area S2nv=1 "West wall surface (unglazed)"  annotation(Dialog(tab="Vertical walls"));
parameter Modelica.SIunits.Area S3nv=1 "North wall surface (unglazed)"           annotation(Dialog(tab="Vertical walls"));
parameter Modelica.SIunits.Area S4nv=1 "East wall surface (unglazed)"  annotation(Dialog(tab="Vertical walls"));

parameter Modelica.SIunits.CoefficientOfHeatTransfer hextv annotation(Dialog(tab="Vertical walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hintv annotation(Dialog(tab="Vertical walls"));
parameter Real albedo=0.2 "Environment albedo" annotation(Dialog(tab="Vertical walls"));
parameter Real alpha= 0.6
    "Absorption coefficient of the outer surface in the visible"                       annotation(Dialog(tab="Vertical walls"));
parameter Real eps=0.6 "Emissivity in LWR"
    annotation(Dialog(enable=ChoixGLOext, tab="Vertical walls"));

//Horizontal walls//
//Ceiling//
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall CaracPlaf
    "Ceiling characteristics" annotation (choicesAllMatching=true,
      Dialog(tab="Horizontal walls", group="Ceiling"));
      parameter Modelica.SIunits.Area Splaf=1 "Ceiling surface" annotation(Dialog(tab="Horizontal walls", group="Ceiling"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hplaf annotation(Dialog(tab="Horizontal walls", group="Ceiling"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hintplaf annotation(Dialog(tab="Horizontal walls", group="Ceiling"));

parameter Real bCombles=0.5
    "Weighting coefficient of ceiling temperatures on lost roofs";
parameter Real bVS=0.5
    "Weighting coefficient of floor temperatures on crawl space";

//Floor//
 parameter Integer PlancherActif=1
      annotation(Dialog(tab="Horizontal walls", group="Floor",compact=true),
      choices(choice=1 "Conventional floor",
      choice=2 "Heating floor with water circulation",
      choice=3 "Electric radiant floor",radioButtons=true));

  replaceable parameter BuildSysPro.Utilities.Records.GenericWall CaracPlanch
    "Floor characteristics" annotation (choicesAllMatching=
        true, Dialog(tab="Horizontal walls", group="Plancher"));
parameter Modelica.SIunits.Area Splanch=1 "Floor surface" annotation(Dialog(tab="Horizontal walls", group="Floor"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hplanch annotation(Dialog(tab="Horizontal walls", group="Floor"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hintplanch annotation(Dialog(tab="Horizontal walls", group="Floor"));

// Parameter common to the water active floor and the electric radiant floor
 parameter Integer nP=1
    "Number of the layer whose upper border is the site of power injection - must be strictly lower than n"
    annotation (Dialog(enable=not
                                 (PlancherActif==1), tab="Horizontal walls", group="Floor"));

// Parameters specific to a heating wall with water
  parameter Integer nD=8 "Number of discretization slices of the water floor"
    annotation(Dialog(enable=PlancherActif==2, tab="Horizontal walls", group="Floor"));
  parameter Modelica.SIunits.Distance Ltube=128 "Floor heating coil length"
    annotation(Dialog(enable=PlancherActif==2, tab="Horizontal walls", group="Floor"));
  parameter Modelica.SIunits.Distance DiametreInt=0.013
    "Inner diameter of tube"
    annotation(Dialog(enable=PlancherActif==2, tab="Horizontal walls", group="Floor"));
  parameter Modelica.SIunits.Distance eT=0.0015 "Tube thickness"
    annotation (Dialog(enable=PlancherActif==2, tab="Horizontal walls", group="Floor"));
  parameter Modelica.SIunits.ThermalConductivity lambdaT=0.35
    "Tube thermal conductivity"
    annotation (Dialog(enable=PlancherActif==2, tab="Parois Horizontales", group="Floor"));
// Components
  Modelica.Blocks.Interfaces.RealInput Ensoleillement[10]
    "Sun data : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle, Solar elevation angle}"
    annotation (Placement(transformation(extent={{-192,-6},{-152,34}}),
        iconTransformation(extent={{-140,40},{-120,60}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-192,-22},{-172,-2}}),
        iconTransformation(extent={{-140,80},{-120,100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tairint
    annotation (Placement(transformation(extent={{20,-58},{40,-38}}),
        iconTransformation(extent={{20,-62},{40,-42}})));

protected
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tair)
    annotation (Placement(transformation(extent={{18,0},{38,20}})));

  BuildingEnvelope.HeatTransfer.Wall Sud(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S1nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,10},{-40,28}})));

  BuildingEnvelope.HeatTransfer.Wall Ouest(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S2nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps)
    annotation (Placement(transformation(extent={{-58,-44},{-40,-26}})));

  BuildingEnvelope.HeatTransfer.Wall Nord(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S3nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,38},{-40,56}})));

  BuildingEnvelope.HeatTransfer.Wall Est(
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    InitType=InitType,
    S=S4nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,-18},{-40,0}})));

  BuildingEnvelope.HeatTransfer.Wall Plafond(
    caracParoi(
      n=CaracPlaf.n,
      m=CaracPlaf.m,
      e=CaracPlaf.e,
      mat=CaracPlaf.mat,
      positionIsolant=CaracPlaf.positionIsolant),
    InitType=InitType,
    S=Splaf,
    hs_ext=hplaf,
    hs_int=hintplaf,
    Tp=Tp,
    ParoiInterne=true,
    RadInterne=ChoixPint)
    annotation (Placement(transformation(extent={{-58,70},{-38,90}})));

  BuildingEnvelope.HeatTransfer.Wall Plancher(
    caracParoi(
      n=CaracPlanch.n,
      m=CaracPlanch.m,
      e=CaracPlanch.e,
      mat=CaracPlanch.mat,
      positionIsolant=CaracPlanch.positionIsolant),
    InitType=InitType,
    S=Splanch,
    hs_ext=hplanch,
    hs_int=hintplanch,
    Tp=Tp,
    ParoiInterne=true,
    ParoiActive=PlancherActif,
    nP=nP,
    nD=nD,
    Ltube=Ltube,
    DiametreInt=DiametreInt,
    eT=eT,
    lambdaT=lambdaT,
    RadInterne=ChoixPint)
    annotation (Placement(transformation(extent={{-58,-74},{-38,-54}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient coefficient_bCombles(b=
        bCombles)
    annotation (Placement(transformation(extent={{-144,70},{-124,50}})));

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta,
      albedo=albedo)
    annotation (Placement(transformation(extent={{-116,4},{-96,24}})));
public
  Modelica.Blocks.Interfaces.RealInput EntreeEau[2] if PlancherActif==2
    "Vector containing  1-the fluid temperature (K), 2-the flow(kg/s)"
    annotation (Placement(transformation(extent={{-110,-104},{-90,-84}}),
        iconTransformation(extent={{-160,-110},{-140,-90}})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2] if PlancherActif==2
    "Vector containing  1-the fluid temperature (K), 2-the flow(kg/s)"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}}),
        iconTransformation(extent={{60,-110},{80,-90}})));
  Modelica.Blocks.Interfaces.RealInput PelecPRE if PlancherActif==3
    "Electric power injected into the floor"    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-74}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-100})));
  BuildingEnvelope.HeatTransfer.B_Coefficient coefficient_bVS(b=bVS)
    annotation (Placement(transformation(extent={{-146,-68},{-126,-48}})));
  BoundaryConditions.Radiation.PintRadDistrib pintDistribRad(
    np=6,
    nf=4,
    Sp={Splaf,Splanch,S1nv,S2nv,S3nv,S4nv},
    Sf={1,1,1,1}) if         ChoixPint
    "Distribution proportionally to surfaces of any radiative flux"
    annotation (Placement(transformation(
        extent={{-18,-15},{18,15}},
        rotation=180,
        origin={56,77})));
Modelica.Blocks.Interfaces.RealInput      Pint if ChoixPint
    "Internal radiative heat gains"
    annotation (Placement(
        transformation(extent={{120,60},{80,100}}),iconTransformation(extent={{60,-18},
            {40,2}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if
                                         ChoixGLOext annotation (Placement(
        transformation(extent={{-160,-40},{-140,-20}}), iconTransformation(
          extent={{-180,60},{-160,80}})));
equation

  connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
      points={{-39,77},{4,77},{4,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plancher.T_int, noeudAir.port_a) annotation (Line(
      points={{-39,-67},{4,-67},{4,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tairint) annotation (Line(
      points={{28,6},{30,6},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bCombles.Tponder, Plafond.T_ext)
                                                annotation (Line(
      points={{-129,60.2},{-89.5,60.2},{-89.5,77},{-57,77}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, coefficient_bCombles.port_ext)
                                        annotation (Line(
      points={{-182,-12},{-182,56},{-143,56},{-143,57}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ensoleillement, fLUXzone.G) annotation (Line(
      points={{-172,14},{-144.45,14},{-144.45,14.5},{-116.3,14.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, Sud.FLUX) annotation (Line(
      points={{-95,14.4},{-88,14.4},{-88,27.1},{-51.7,27.1}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
  connect(fLUXzone.FLUXEst, Est.FLUX) annotation (Line(
      points={{-95,10.4},{-88,10.4},{-88,-0.9},{-51.7,-0.9}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
  connect(fLUXzone.FLUXouest, Ouest.FLUX) annotation (Line(
      points={{-95,6.4},{-88,6.4},{-88,-26.9},{-51.7,-26.9}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
  connect(fLUXzone.FLUXNord, Nord.FLUX) annotation (Line(
      points={{-95,18.2},{-90,18.2},{-90,55.1},{-51.7,55.1}},
      color={255,192,1},
      smooth=Smooth.None,
      thickness=0.5));
  connect(Nord.T_ext, Text) annotation (Line(
      points={{-57.1,44.3},{-80,44.3},{-80,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Sud.T_ext, Text) annotation (Line(
      points={{-57.1,16.3},{-80,16.3},{-80,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Est.T_ext, Text) annotation (Line(
      points={{-57.1,-11.7},{-121.55,-11.7},{-121.55,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_ext, Text) annotation (Line(
      points={{-57.1,-37.7},{-80,-37.7},{-80,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bCombles.port_int, Tairint)
                                           annotation (Line(
      points={{-143,63},{-150,63},{-150,96},{30,96},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Nord.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,44.3},{-2,44.3},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Sud.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,16.3},{-2,16.3},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Est.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,-11.7},{-2,-11.7},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_int, noeudAir.port_a) annotation (Line(
      points={{-40.9,-37.7},{-2,-37.7},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(EntreeEau, Plancher.EntreeEau) annotation (Line(
      points={{-100,-94},{-86,-94},{-86,-61.4},{-57,-61.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Plancher.SortieEau, SortieEau) annotation (Line(
      points={{-39,-71},{-20,-71},{-20,-100},{50,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Plancher.PelecPRE, PelecPRE) annotation (Line(
      points={{-57,-63},{-86,-63},{-86,-74},{-100,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Text, coefficient_bVS.port_ext) annotation (Line(
      points={{-182,-12},{-182,-55},{-145,-55}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bVS.port_int, Tairint) annotation (Line(
      points={{-145,-61},{-180,-61},{-180,-106},{30,-106},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bVS.Tponder, Plancher.T_ext) annotation (Line(
      points={{-131,-58.2},{-93.5,-58.2},{-93.5,-67},{-57,-67}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Pint, pintDistribRad.RayEntrant) annotation (Line(
      points={{100,80},{90,80},{90,77},{72.2,77}},
      color={0,0,127},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pintDistribRad.FLUXParois[1], Plafond.FluxAbsInt) annotation (Line(
      points={{36.2,81.25},{10,81.25},{10,85},{-45,85}},
      color={0,0,127},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pintDistribRad.FLUXParois[2], Plancher.FluxAbsInt) annotation (Line(
      points={{36.2,80.75},{38,80.75},{38,80},{10,80},{10,-59},{-45,-59}},
      color={0,0,127},
      smooth=Smooth.None,
      thickness=0.5));
  connect(T_ciel, Nord.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,38.9},{-57.1,38.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Sud.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,10.9},{-57.1,10.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Est.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,-17.1},{-57.1,-17.1}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Ouest.T_ciel) annotation (Line(
      points={{-150,-30},{-74,-30},{-74,-43.1},{-57.1,-43.1}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[5], Nord.FluxAbsInt) annotation (Line(
      points={{36.2,79.25},{10,79.25},{10,51.5},{-46.3,51.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[3], Sud.FluxAbsInt) annotation (Line(
      points={{36.2,80.25},{10,80.25},{10,23.5},{-46.3,23.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[6], Est.FluxAbsInt) annotation (Line(
      points={{36.2,78.75},{22,78.75},{22,80},{10,80},{10,-4.5},{-46.3,-4.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[4], Ouest.FluxAbsInt) annotation (Line(
      points={{36.2,79.75},{10,79.75},{10,-30.5},{-46.3,-30.5}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p><b>Model of parallelepiped unglazed zone on crawl space, in pure thermal modelling</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Parallelepiped unglazed single-zone building on crawl space model, to be connected to a boundary conditions model (left thermal port) and a left realOutput for solar fluxes. By default walls are oriented in the four cardinal points; the orientation modification is represented by the parameter beta. The right thermal port is connected to the inner volume (heat capacity). Floor and ceiling are subject to outside temperatures which are weighted by a coefficient b.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This single zone building model is to be connected to a weather boundary conditions model on the left (outside temperature, sunlight-related data). The right thermal port is connected to the inner volume (heat capacity) and can, if desired, be connected to any model using a thermal port (internal heat gains...).</p>
<p>The walls parameterization is done via the parameter caracParoi, however it still can be done layer by layer without creating any type of wall.</p>
<ol>
<li>Click on the small arrow of caracParoi + Edit</li>
<li>Fill in the fields on the number of layers, their thickness, the mesh. The parameter positionIsolant is optional</li>
<li>For the mat parameter, click on the small arrow + Edit array, match the number of boxes in a column to the number of materials layer in the window that is displayed, then, in each box, right-click + Insert function call and browse the library to specify the path of the desired material (in <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\"><code>Utilities.Data.Solids</code></a>)</li>
</ol>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>To consider walls radiation in long wavelength (LWR), exchange coefficients h must be<b> global exchange coefficients</b>.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Ludovic Darnaud 07/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Ludovic DARNAUD, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2011: Changement du modèle de coefficient B pour vérifier la conservation d'énergie + Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(choicesAllMatching=true)</p>
<p>Aurélie Kaemmerlen 03/2011 : Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</p>
<p>Gilles Plessis 02/2012 : Suppression du modifier <i>each </i>dans la définition des matériaux des parois. Le mot clé each n'a pas à être présent car les matériaux des parois sont définis en temps que vecteur.</p>
<p>Gilles Plessis 02/2012 : Modification du type de paroi pour le plancher et le plafond de<i> paroiComplete</i> en <i>paroi</i></p>
<p>Gilles Plessis 06/2012 : </p>
<ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul>
<p>Vincent Magnaudeix 06/2012 : Coefficient b de réduction de température distinct pour le plafond et le plancher</p>
<p>Aurélie Kaemmerlen 07/2012 : Ajout de booléens supplémentaires présents dans les parois</p>
<ul>
<li>Plancher chauffant électrique ou à eau,</li>
<li>Rayonnement avec le ciel pour les parois verticales, </li>
<li>Injection d'un flux radiatif (via des panneaux rayonnants par exemple, avec distribution au prorata des surfaces)</li>
</ul>
<p><br>Amy Lindsay 03/2014 : changement des FluxSolInput en RealInput pour les apports internes Pint</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-140,20},{60,-100}},
          lineColor={0,0,255},
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-140,20},{60,20},{-40,98},{-140,20}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={226,98,12},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-200,98},{-140,42}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),                                                          Dialog(tab="Parois Horizontales", group="Plafond"), Diagram(
        coordinateSystem(preserveAspectRatio=false,extent={{-200,-100},{100,100}}),
        graphics),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,-100},
            {100,100}}),       graphics),
                               Icon(coordinateSystem(preserveAspectRatio=true,
                  extent={{-200,-100},{100,100}}), graphics={
        Ellipse(
          extent={{12,98},{72,42}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-160,20},{40,-100}},
          lineColor={0,0,255},
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-160,20},{40,20},{-60,98},{-160,20}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={226,98,12},
          fillPattern=FillPattern.Solid)}));
end ZoneCrawlSpace;
