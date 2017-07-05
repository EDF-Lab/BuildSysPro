within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneNWalls "Model of zone with N walls and NF windows"

//Global parameters of the model//
parameter Integer N=4 "Vertical walls number";
parameter Integer NF=1 "Windows number";
parameter Real albedo=0.2 "Environment albedo";
parameter Modelica.SIunits.Temperature Tp=293.15
    "Initial temperatureof walls and air node";

//Inputs and outputs of the model//
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ground "Tsol"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-70,-110},{-50,-90}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int "Tint"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}}),
        iconTransformation(extent={{30,-70},{50,-50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext "Text"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Interfaces.RealInput G[10]
    "Sun data : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle, Solar elevation angle}"
                                            annotation (Placement(
        transformation(extent={{-120,40},{-80,80}}), iconTransformation(extent={{-110,50},
            {-90,70}})));
//Horizontal walls//
//Ceiling//
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracPlaf
    "Ceiling characteristics" annotation (choicesAllMatching=true,
      Dialog(tab="Horizontal walls", group="Ceiling"));
    parameter Modelica.SIunits.Area SPlaf=1 "Ceiling surface" annotation(Dialog(tab="Horizontal walls",group="Ceiling"));
    parameter Real azimutPlaf=0
    "Ceiling azimuth in relation to the South: S=0°, E=-90°, O=90°, N=180°"
                        annotation(Dialog(tab="Horizontal walls",group="Ceiling"));
    parameter Real inclPlaf=0 "Ceiling tilt"
                             annotation(Dialog(tab="Horizontal walls",group="Ceiling"));
    parameter Real alphaPlaf=0.5 "Solar absorption coefficient of the ceiling"
                                                  annotation(Dialog(tab="Horizontal walls",group="Ceiling"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hPlaf=1
    "Global surface exchange coefficient on the face a" annotation(Dialog(tab="Horizontal walls",group="Ceiling"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintPlaf=1
    "Global surface exchange coefficient on the face b" annotation(Dialog(tab="Horizontal walls",group="Ceiling"));
protected
  Building.BuildingEnvelope.HeatTransfer.Wall Plafond(
    caracParoi(
      n=caracPlaf.n,
      m=caracPlaf.m,
      e=caracPlaf.e,
      mat=caracPlaf.mat,
      positionIsolant=caracPlaf.positionIsolant),
    S=SPlaf,
    alpha_ext=alphaPlaf,
    hs_ext=hPlaf,
    hs_int=hintPlaf,
    Tp=Tp,
    RadInterne=true,
    ParoiInterne=false,
    RadExterne=false);

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf ProjectionSolairePlafond(
    albedo=albedo,
    azimut=azimutPlaf,
    incl=inclPlaf);

//Floor//
public
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracPlanch
    "Floor characteristics" annotation (choicesAllMatching=true,
      Dialog(tab="Horizontal walls", group="Floor"));
    parameter Modelica.SIunits.Area SPlan=1 "Floor surface" annotation(Dialog(tab="Horizontal walls",group="Floor"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintPlan=1
    "Global surface exchange coefficient on the inner face" annotation(Dialog(tab="Horizontal walls",group="Floor"));
protected
  Building.BuildingEnvelope.HeatTransfer.Wall Plancher(
    caracParoi(
      n=caracPlanch.n,
      m=caracPlanch.m,
      e=caracPlanch.e,
      mat=caracPlanch.mat,
      positionIsolant=caracPlanch.positionIsolant),
    S=SPlan,
    hs_int=hintPlan,
    Tp=Tp,
    RadInterne=true,
    ParoiInterne=true,
    RadExterne=false);

//Vertical walls//
public
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracParoiVert[N] "Vertical walls characteristics" annotation (
      choicesAllMatching=true, Dialog(tab="Vertical walls"));
    parameter Modelica.SIunits.Area[N] SVert=ones(N) "Vertical walls surface"
                             annotation(Dialog(tab="Vertical walls"));
    parameter Real[N] alphaVert=fill(0.5,N)
    "Solar absorption coefficient of vertical walls (departure South wall then in clockwise direction)"
     annotation(Dialog(tab="Vertical walls"));
    parameter Real[N] azimutVert={0,90,180,-90}
    "Vertical walls azimuth in relation to the South: S=0°, E=-90°, O=90°, N=180°"
                                                                                    annotation(Dialog(tab="Vertical walls"));
    parameter Real[N] inclVert=fill(90,N) "Vertical walls tilt"
                                        annotation(Dialog(tab="Vertical walls"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hVert=25
    "Global surface exchange coefficient on the outer face" annotation(Dialog(tab="Vertical walls"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintVert=8.29
    "Global surface exchange coefficient on the inner face" annotation(Dialog(tab="Vertical walls"));
protected
  Building.BuildingEnvelope.HeatTransfer.Wall[N] paroisVerticales(
    caracParoi(
      n=caracParoiVert.n,
      m=caracParoiVert.m,
      e=caracParoiVert.e,
      mat=caracParoiVert.mat,
      positionIsolant=caracParoiVert.positionIsolant),
    S=SVert,
    alpha_ext=alphaVert,
    each hs_int=hintVert,
    each hs_ext=hVert,
    Tp=fill(Tp, N),
    each RadInterne=true,
    each ParoiInterne=false,
    each RadExterne=false);

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf[N] ProjectionSolaireVert(
    each albedo=albedo,
    azimut=azimutVert,
    incl=inclVert);
//Windows//
public
    parameter Modelica.SIunits.CoefficientOfHeatTransfer[NF] Ufen=fill(3,NF)
    "Glazings thermal conductivity (from South window then in clockwise direction)"
                                                                               annotation(Dialog(tab="Windows"));
    parameter Real[NF] tauFen= fill(0.5,NF)
    "Eenergy transmission coefficients (from South window then in clockwise direction)"
                                                                                       annotation(Dialog(tab="Windows"));
    parameter Real[NF] gFen= fill(0.6,NF)
    "Solar factors (from South window then in clockwise direction)"                         annotation(Dialog(tab="Windows"));
    parameter Modelica.SIunits.Area[NF] SFen=ones(NF)
    "Surface of each window (from South window then in clockwise direction)" annotation(Dialog(tab="Windows"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hFen=25
    "Global surface exchange coefficient on the outer face (25 W/m²/K with the standard EN 410 and 673)"
                                                                                                        annotation(Dialog(tab="Windows"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer hintFen=8.29
    "Global surface exchange coefficient on the inner face (8.29 W/m²/K with the standard EN 410 and 67)"
                                                                                                        annotation(Dialog(tab="Windows"));
    parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg[NF]
    azimutFen =                                                               zeros(NF)
    "Azimuth of each window in direction to the South: S=0°, E=-90°, O=90°, N=180°"
                                                                                      annotation(Dialog(tab="Windows"));
    parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg[NF] inclFen=fill(90,NF)
    "Windows tilt (from South window then in clockwise direction)"        annotation(Dialog(tab="Windows"));
protected
    BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow[NF] DVitrages(
    U=Ufen,
    tau=tauFen,
    g=gFen,
    S=SFen,
    each hs_ext=hFen,
    each hs_int=hintFen,
    each RadInterne=true,
    each DifDirOut=false);

  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf[NF] ProjectionSolaireFen(
    each albedo=albedo,
    azimut=azimutFen,
    incl=inclFen);

//Inner zone//
public
    parameter Modelica.SIunits.Volume Vzone=10 "Zone air volume [mCube]"
                                annotation(Dialog(tab="Inner zone"));
protected
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(Tair=Tp, V=Vzone);

//Air renewal//
    final constant Modelica.SIunits.Volume changUnit=1;
public
    parameter Real DebitRenouv=Vzone/changUnit "Air renewal hourly flow [m3/h]"
                                     annotation(Dialog(tab="Air renewal"));
protected
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        DebitRenouv);

// Solar fluxes distribution in proportion to the surfaces

  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib RepartitionSolaireInterne(
    np=N + 2,
    Sp=cat(
        1,
        SVert,
        {SPlaf},
        {SPlan}),
    nf=NF,
    Sf=SFen);

     Modelica.Blocks.Math.MultiSum SommeFluxSolaireInterne(nu=NF);

equation
  // Connections on vertical walls
  for i in 1:N loop
  connect(G,ProjectionSolaireVert[i].G);
  connect(ProjectionSolaireVert[i].FluxIncExt,paroisVerticales[i].FluxIncExt);
    connect(T_ext, paroisVerticales[i].T_ext);
  connect(paroisVerticales[i].T_int,noeudAir.port_a);
  connect(RepartitionSolaireInterne.FLUXParois[i],paroisVerticales[i].FluxAbsInt);
  end for;

  // Connections on windows
  for i in 1:NF loop
  connect(G,ProjectionSolaireFen[i].G);
  connect(ProjectionSolaireFen[i].FluxIncExt,DVitrages[i].FluxIncExt);
    connect(T_ext, DVitrages[i].T_ext);
  connect(DVitrages[i].T_int,noeudAir.port_a);
  connect(DVitrages[i].CLOTr,SommeFluxSolaireInterne.u[i]);
  connect(RepartitionSolaireInterne.FLUXFenetres[i],DVitrages[i].FluxAbsInt);
  end for;

// Connection on the ceiling
  connect(G,ProjectionSolairePlafond.G);
  connect(ProjectionSolairePlafond.FluxIncExt,Plafond.FluxIncExt);
  connect(T_ext, Plafond.T_ext);
  connect(Plafond.T_int,noeudAir.port_a);
  connect(RepartitionSolaireInterne.FLUXParois[N+1],Plafond.FluxAbsInt);

// Connection on the floor
  connect(T_ground,Plancher.Ts_ext);
  connect(Plancher.T_int,noeudAir.port_a);
  connect(RepartitionSolaireInterne.FLUXParois[N+2],Plancher.FluxAbsInt);

// Connection of air renewal
  connect(noeudAir.port_a, renouvellementAir.port_b);
  connect(renouvellementAir.port_a, T_ext);

// Connection of indoor thermal port port_Tint
  connect(noeudAir.port_a, T_int);

// Connection of total solar flux transmite for distribution
connect(SommeFluxSolaireInterne.y,RepartitionSolaireInterne.RayEntrant);

 annotation (Documentation(info="<html>
<p><b>Model of zone with N walls and NF windows, in pure thermal modelling</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Model of a thermal zone with N vertical walls, NF windows, 1 floor and a ceiling. The walls are of type Wall and windows are of type Window. This model also has an air renewal.</p>
<p>Vertical walls and the ceiling are connected on their outer face to the heat port <code>T_ext</code> and on their inner face to the heat port <code>T_int</code>. Windows are connected in the same way to external and internal boundary conditions. The floor is connected to the port <code>T_ground</code> on its outer face and to the port <code>T_int</code> on its inner face. The air renewal is connected to the indoor air node and to the outdoor thermal port. All these boundary conditions are of convective type and are thus connected to the convection temperature and not the surface temperature, except for the port <code>T_ground</code>.</p>
<p>The distribution of SW fluxes transmitted inside through the windows is done in proportion to the surfaces. The sunshine is still considered, contrary to the Wall model.</p>
<p>The initialisation is done in stationary condition to the temperature <code>Tp</code>.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This single zone building model is to be connected to a weather boundary conditions model on the left (outside temperature, sunlight-related data). The right thermal port is connected to the inner volume (heat capacity) and can, if desired, be connected to any model using a thermal port.</p>
<p>The floor and ceiling parameterization is done via the parameter caracParoi (caracPlaf, caracPlanch), however it still can be done by a wall parametrization layer by layer without creating any type of wall.</p>
<ol>
<li>Click on the small arrow of caracParoi + Edit</li>
<li>Fill in the fields on the number of layers, their thickness, the mesh. The parameter positionIsolant is optional</li>
<li>For the mat parameter, click on the small arrow + Edit array, match the number of boxes in a column to the number of materials layer in the window that is displayed, then, in each box, right-click + Insert function call and browse the library to specify the path of the desired material (in <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\"><code>Utilities.Data.Solids</code></a>)</li>
</ol>
<p>The vertical walls parameterization is done via the caracParoiVert parameter (dimension N) of the tab <i>Vertical walls.</i></p>
<ol>
<li>Click on the small arrow of caracParoiVert + Edit Array</li>
<li>Adjust the number of cells (lines) to the number of vertical walls N</li>
<li>In each box right-click + Insert function call then browse the library to specify the path of the desired type of wall (in <a href=\"modelica://BuildSysPro.Utilities.Data.WallData\"><code>Utilities.Data.WallData</code></a>)</li>
</ol>
<p>Note that walls can always be set layer by layer without creating any type of wall. For that:</p>
<ol>
<li>Click on the small arrow of caracParoiVert + Edit Combined</li>
<li>Adjust the number of lines to the number of vertical walls N</li>
<li>Fill in the fields on thickness, meshes and the number of layers in each wall, then for each material right-click + Insert function call then browse the library to specify the path of the desired type of material (in <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\"><code>Utilities.Data.Solids</code></a>)</li>
</ol>
<p><b>Warning</b>, it is imperative that the walls order is the same in the definition of the different fields, orientation, materials, surface, thicknesses ... For example, see <a href=\"modelica://BuildSysPro.Building.Examples.TestZoneNWalls\"><code>TestZoneNWalls</code></a> validation.</p>
<p>By default, the zone has a south window and four vertical walls oriented in the four cardinal points.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The solar flux distribution inside the frame is made in proportion to the surfaces. It is relatively simplistic. To consider walls radiation in long wavelength (LWR), exchange coefficients h must be <b>global exchange coefficients</b>.</p>
<p><u><b>Validations</b></u></p>
<p>Validation in free evolution by comparison to the assembly model - Gilles Plessis 10/2011</p>
<p>Validation in <a href=\"modelica://BuildSysPro.Building.Examples.TestZoneNWalls\"><code>TestZoneNWalls</code></a></p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Gilles Plessis 03/2011 : Ajout d&apos;une liste d&eacute;roulante pour le choix des mat&eacute;riaux via l&apos;annotation annotation(choicesAllMatching=true).</p>
<p>Gilles Plessis 02/2012 : Modification du mod&egrave;le de renouvellement d&apos;air.</p>
<p>Gilles Plessis 06/2012 : </p>
<ul>
<li>Int&eacute;gration du changement de param&eacute;trage des parois. Voir les r&eacute;visions apport&eacute;es au mod&egrave;le de parois</li>
<li>Protection de composants pour &eacute;viter le grand nombre de variables dans la fen&ecirc;tre des r&eacute;sultats.</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),
    DymolaStoredErrors,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-38,10},{34,-42}},
          lineColor={0,0,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-84,26},{66,-92}}, lineColor={0,0,255}),
        Line(
          points={{90,60},{-60,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-84,26},{-60,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{66,26},{90,60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{90,60},{90,-58}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{66,-92},{90,-58}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{74,28},{-54,50}},
          lineColor={0,0,255},
          textString="ZoneNparois"),
        Ellipse(
          extent={{-90,80},{-50,40}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),      graphics),
    DymolaStoredErrors);
end ZoneNWalls;
