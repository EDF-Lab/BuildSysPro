within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneSlab
  "Model of parallelepiped zone on unglazed slab-on-grade floor, in pure thermal modelling"

parameter Boolean ChoixPint=false
    "Consideration of radiative contributions in proportion to surfaces" annotation (
      choices(choice=true "Yes",
      choice=false "No",radioButtons=true));

 parameter Boolean ChoixGLOext=false
    "Consideration of LW radiation (infrared) between vertical walls and the sky"
    annotation(choices(choice=true "Yes: warnings, hext purely convective", choice=false "No", radioButtons=true));

 parameter Modelica.SIunits.Volume Vair "Volume d'air intérieur";
 parameter Real beta=0
    "Vertical walls azimuth correction (azimutf=azimutf{0,90,180,-90}+beta)";

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
    "Outer surface absorption coefficient in the visible"                       annotation(Dialog(tab="Vertical walls"));
parameter Real eps=0.6 "Emissivity in LWR"
    annotation(Dialog(enable=ChoixGLOext, tab="Vertical walls"));

//Horizontal walls//
//Ceiling//
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall CaracPlaf
    "Ceiling characteristics" annotation (choicesAllMatching=true,
      Dialog(tab="Horizontal walls", group="Ceiling"));
parameter Modelica.SIunits.Area Splaf=1 "surface du plafond" annotation(Dialog(tab="Horizontal walls", group="Ceiling"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hplaf annotation(Dialog(tab="Horizontal walls", group="Ceiling"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hintplaf annotation(Dialog(tab="Horizontal walls", group="Ceiling"));
parameter Real b=0.5 "Weighting coefficient of ceiling and floor temperatures";

//Floor//
 parameter Integer PlancherActif=1
      annotation(Dialog(tab="Horizontal walls", group="Floor",compact=true),
      choices(choice=1 "Conventional floor",
      choice=2 "Heating floor with water circulation",
      choice=3 "Electric radiant floor",radioButtons=true));
 parameter Boolean CLfixe=true
    "Consideration of a fixed temperature for the ground"
                                            annotation(Dialog(tab="Horizontal walls", group="Floor",compact=true),choices(radioButtons=true));

  parameter Boolean SurEquivalentTerre=true
    "Consideration of an earth layer between the wall and ground temperature"
     annotation(Dialog(tab="Horizontal walls", group="Floor",compact=true),choices(choice=true
        "Yes: wall in contact with a material equivalent to the earth",                                                                          choice=false
        "No: conventional wall",                                                                                                    radioButtons=true));

 parameter Modelica.SIunits.Temperature Ts=293.15 "Ground temperature";
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall CaracPlanch
    "Floor characteristics" annotation (choicesAllMatching=true,
      Dialog(tab="Horizontal walls", group="Floor"));
  parameter Modelica.SIunits.Area Splanch=1 "Floor surface" annotation(Dialog(tab="Horizontal walls", group="Floor"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hplanch annotation(Dialog(tab="Horizontal walls", group="Floor"));

// Parameter common to the water active wall and the electric radiant wall
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
    annotation (Dialog(enable=PlancherActif==2, tab="Horizontal walls", group="Floor"));

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
        iconTransformation(extent={{20,-42},{40,-22}})));

protected
  AirFlow.HeatTransfer.AirNode                       noeudAir(V=Vair, Tair(
        displayUnit="K") = Tair)
    annotation (Placement(transformation(extent={{18,0},{38,20}})));
  BuildingEnvelope.HeatTransfer.Wall              Sud(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S1nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,10},{-40,28}})));

  BuildingEnvelope.HeatTransfer.Wall              Ouest(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S2nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps)
    annotation (Placement(transformation(extent={{-58,-44},{-40,-26}})));

  BuildingEnvelope.HeatTransfer.Wall              Nord(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S3nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,38},{-40,56}})));

  BuildingEnvelope.HeatTransfer.Wall              Est(
    InitType=InitType,
    caracParoi(
      n=CaracParoiVert.n,
      m=CaracParoiVert.m,
      e=CaracParoiVert.e,
      mat=CaracParoiVert.mat,
      positionIsolant=CaracParoiVert.positionIsolant),
    S=S4nv,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    eps=eps) annotation (Placement(transformation(extent={{-58,-18},{-40,0}})));

  BuildingEnvelope.HeatTransfer.Wall              Plafond(
    InitType=InitType,
    caracParoi(
      n=CaracPlaf.n,
      m=CaracPlaf.m,
      e=CaracPlaf.e,
      mat=CaracPlaf.mat,
      positionIsolant=CaracPlaf.positionIsolant),
    S=Splaf,
    hs_ext=hplaf,
    hs_int=hintplaf,
    Tp=Tp,
    ParoiInterne=true,
    RadInterne=ChoixPint)
    annotation (Placement(transformation(extent={{-58,70},{-38,90}})));
  BuildingEnvelope.HeatTransfer.FloorOnSlab paroiTerrePleinRadAvecSol(
    InitType=InitType,
    caracParoi(
      n=CaracPlanch.n,
      m=CaracPlanch.m,
      e=CaracPlanch.e,
      mat=CaracPlanch.mat,
      positionIsolant=CaracPlanch.positionIsolant),
    S=Splanch,
    Ts=Ts,
    hs=hplanch,
    RadInterne=ChoixPint,
    ParoiActive=PlancherActif,
    SurEquivalentTerre=SurEquivalentTerre,
    CLfixe=CLfixe)
    annotation (Placement(transformation(extent={{-56,-76},{-36,-56}})));

  BuildingEnvelope.HeatTransfer.B_Coefficient                      coefficient_b(b=b)
    annotation (Placement(transformation(extent={{-144,50},{-124,70}})));

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta,
      albedo=albedo)
    annotation (Placement(transformation(extent={{-116,4},{-96,24}})));

public
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tsol if
                                         not
                                            (CLfixe) "Ground temperature"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput PelecPRE if PlancherActif==3
    "Electric power injected into the floor"    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-64}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-76})));
public
  Modelica.Blocks.Interfaces.RealInput EntreeEau[2] if PlancherActif==2
    "Vector containing  1-the fluid temperature (K), 2-the flow(kg/s)"
    annotation (Placement(transformation(extent={{-130,-94},{-110,-74}}),
        iconTransformation(extent={{-160,-86},{-140,-66}})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2] if PlancherActif==2
    "Vector containing  1-the fluid temperature (K), 2-the flow(kg/s)"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}}),
        iconTransformation(extent={{60,-86},{80,-66}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if
                                         ChoixGLOext annotation (Placement(
        transformation(extent={{-160,-40},{-140,-20}}), iconTransformation(
          extent={{-178,60},{-158,80}})));
Modelica.Blocks.Interfaces.RealInput      Pint if ChoixPint
    "Internal radiative heat gains"
    annotation (Placement(
        transformation(extent={{120,62},{80,102}}),iconTransformation(extent={{60,-18},
            {40,2}})));
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
equation
  connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
      points={{-39,77},{-2,77},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tairint) annotation (Line(
      points={{28,6},{30,6},{30,-48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, Text) annotation (Line(
      points={{-182,-12},{-180,-12},{-180,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(coefficient_b.Tponder, Plafond.T_ext) annotation (Line(
      points={{-129,59.8},{-87.5,59.8},{-87.5,77},{-57,77}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, coefficient_b.port_ext) annotation (Line(
      points={{-182,-12},{-182,64},{-143,64},{-143,63}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, Sud.FLUX) annotation (Line(
      points={{-95,14.4},{-88,14.4},{-88,27.1},{-51.7,27.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, Est.FLUX) annotation (Line(
      points={{-95,10.4},{-88,10.4},{-88,-0.9},{-51.7,-0.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, Ouest.FLUX) annotation (Line(
      points={{-95,6.4},{-88,6.4},{-88,-26.9},{-51.7,-26.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, Nord.FLUX) annotation (Line(
      points={{-95,18.2},{-90,18.2},{-90,55.1},{-51.7,55.1}},
      color={255,192,1},
      smooth=Smooth.None));
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
  connect(coefficient_b.port_int, Tairint) annotation (Line(
      points={{-143,57},{-150,57},{-150,-78},{30,-78},{30,-48}},
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
  connect(paroiTerrePleinRadAvecSol.T_int, noeudAir.port_a) annotation (Line(
      points={{-37,-66},{-2,-66},{-2,6},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Tsol, paroiTerrePleinRadAvecSol.Tsol) annotation (Line(
      points={{-70,-110},{-70,-66},{-57,-66}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.SortieEau, SortieEau) annotation (Line(
      points={{-37,-73},{-6.5,-73},{-6.5,-90},{30,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.EntreeEau, EntreeEau) annotation (Line(
      points={{-45.4,-75},{-45.4,-84},{-120,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.PelecPRE, PelecPRE) annotation (Line(
      points={{-46.8,-75},{-46.8,-82},{-104,-82},{-104,-64},{-120,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_ciel, Ouest.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,-43.1},{-57.1,-43.1}},
      color={191,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(T_ciel, Est.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,-17.1},{-57.1,-17.1}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Sud.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,10.9},{-57.1,10.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_ciel, Nord.T_ciel) annotation (Line(
      points={{-150,-30},{-76,-30},{-76,38.9},{-57.1,38.9}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Plafond.FluxAbsInt, pintDistribRad.FLUXParois[1]) annotation (Line(
      points={{-45,85},{11.5,85},{11.5,81.25},{36.2,81.25}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(paroiTerrePleinRadAvecSol.FluxAbsInt, pintDistribRad.FLUXParois[2])
    annotation (Line(
      points={{-43,-61},{12,-61},{12,80.75},{36.2,80.75}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Nord.FluxAbsInt, pintDistribRad.FLUXParois[5]) annotation (Line(
      points={{-46.3,51.5},{12,51.5},{12,79.25},{36.2,79.25}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Sud.FluxAbsInt, pintDistribRad.FLUXParois[3]) annotation (Line(
      points={{-46.3,23.5},{12,23.5},{12,80.25},{36.2,80.25}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Est.FluxAbsInt, pintDistribRad.FLUXParois[6]) annotation (Line(
      points={{-46.3,-4.5},{12,-4.5},{12,78.75},{36.2,78.75}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Ouest.FluxAbsInt, pintDistribRad.FLUXParois[4]) annotation (Line(
      points={{-46.3,-30.5},{12,-30.5},{12,79.75},{36.2,79.75}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Ensoleillement, fLUXzone.G) annotation (Line(
      points={{-172,14},{-144.45,14},{-144.45,14.5},{-116.3,14.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pint, pintDistribRad.RayEntrant) annotation (Line(
      points={{100,82},{87,82},{87,77},{72.2,77}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p><b>Model of parallelepiped unglazed zone on slab-on-grade floor, in pure thermal modelling</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Parallelepiped unglazed single-zone building on slab-on-grade floor model, to be connected to a boundary conditions model (left thermal port) and a left realOutput for solar fluxes. By default walls are oriented in the four cardinal points; the orientation modification is represented by the parameter beta. The right thermal port is connected to the inner volume (heat capacity). Floor and ceiling are subject to outside temperatures which are weighted by a coefficient b.</p>
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
<p>To consider walls radiation in long wavelength (LWR), exchange coefficients h must be <b>global exchange coefficients</b>.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Ludovic Darnaud 07/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Ludovic DARNAUD, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen &amp; Gilles Plessis 03/2011 </p>
<ul>
<li>Changement du modèle de coefficient B pour vérifier la conservation d'énergie + Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(choicesAllMatching=true)</li>
<li>Remplacement des modèles de ParoiEclairee et FenetreSimple par ParoiRad et FenetreRad avec externalisation du calcul des flux solaires incidents</li>
<li>Ajout des surfaces des parois verticales !</li>
</ul>
<p><br>Gilles Plessis 02/2012 : Suppression du modifier <i>each </i>dans la définition des matériaux des parois. Le mot clé each n'a pas à être présent car les matériaux des parois sont définis en temps que vecteur.</p>
<p>Gilles Plessis 02/2012 : Modification du type de paroi pour le plafond de<i> paroiComplete</i> en <i>paroi</i></p>
<p>Gilles Plessis 06/2012 : </p>
<ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul>
<p><br>Aurélie Kaemmerlen 07/2012 : Ajout de booléens supplémentaires présents dans les parois</p>
<ul>
<li>Plancher chauffant électrique ou à eau,</li>
<li>Température de sol pouvant être non constante</li>
<li>Rayonnement avec le ciel pour les parois verticales, </li>
<li>Injection d'un flux radiatif (via des panneaux rayonnants par exemple, avec distribution au prorata des surfaces)</li>
</ul>
<p><br>Amy Lindsay 03/2014 : - changement des FluxSolInput en RealInput pour les apports internes Pint</p>
<p>- rajout du connect entre Pint et pintDistribRad</p>
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
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-200,-76},{100,-100}},
          lineColor={0,255,0},
          fillColor={0,255,0},
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
end ZoneSlab;
