within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model SimpleWall "Wall simple model"

// Optional parameters
parameter Boolean RadExterne=false
    "Inclusion of flows which are absorbed on the outer face"
    annotation(Dialog(group="Options",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
parameter Boolean RadInterne=false
    "Inclusion of flows which are absorbed on the inner face"
    annotation(Dialog(group="Options",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
parameter Boolean GLOext=false
    "Inclusion of LW radiation (infrared) between the wall and the environment and the sky"
    annotation(Dialog(group="Options",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));

// General properties
  parameter Modelica.SIunits.Area S=1 "Wall surface without windows"
    annotation(Dialog(group="General properties of the wall"));

  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=5.88
    "Coefficient of CONVECTIVE surface exchange on the outer face"
     annotation(Dialog(group="General properties of the wall"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=5.88
    "Coefficient of CONVECTIVE surface exchange on the inner face"
    annotation(Dialog(group="General properties of the wall"));
  parameter Real skyViewFactor=0
    "Average sky view factor between walls and the sky (example: skyViewFactor(flat roof)=1, skyViewfactor(vertical wall in clear environment)=0.5)"
    annotation(Dialog(enable=GLOext,group="General properties of the wall"));
// Optical properties
  parameter Real AbsParoi=0.6
    "Absorption coefficient of the outer wall in the visible"
    annotation(Dialog(enable=RadExterne, group="General properties of the wall"));
  parameter Real eps=0.6 "Emissivity of the outer surface of the wall in LWR"
    annotation(Dialog(enable=GLOext,  group="General properties of the wall"));

// Wall composition
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoi
    "Wall characteristics" annotation (choicesAllMatching=true,
      Dialog(group="Type of wall"));

// Initialisation
  parameter Modelica.SIunits.Temperature Tp=293.15
    "Initial temperature of the wall"
    annotation(Dialog(group="Initialisation"));

  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    annotation (Dialog(group="Initialisation"));
// Public components
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outdoor temperature" annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}}), iconTransformation(extent={{-100,-40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Indoor temperature" annotation (Placement(transformation(extent={{80,
            -40},{100,-20}}), iconTransformation(extent={{80,-40},{100,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Outdoor temperature on the surface of the wall" annotation (Placement(
        transformation(extent={{-46,-40},{-26,-20}}), iconTransformation(extent=
           {{-40,-40},{-20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Indoor temperature on the surface of the wall" annotation (Placement(
        transformation(extent={{30,-40},{50,-20}}), iconTransformation(extent={
            {20,-40},{40,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if GLOext
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}}),
        iconTransformation(extent={{-100,-100},{-80,-80}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt if
    RadExterne "SWR incident surface flux on the outer face"
    annotation (Placement(transformation(extent={{-118,12},{-80,50}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne
    "LWR and/or SWR flows which are absorbed by this wall on its inner face"
    annotation (Placement(transformation(extent={{108,22},{70,60}}),
        iconTransformation(extent={{40,40},{20,60}})));
// Internal components
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
  //slices connection in the case of a conventional wall
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
<p><b>Wall simple linear model</b></p>
<p><u><b>Hypothesis and equation</b></u></p>
<p>This is a model of a simple wall. A conductive heat transfer occurs in the material which is defined by n homogeneous layers (each layer is discretized into equal sized meshes). Convective heat transfers occur on the two faces, internal and external.</p>
<p>Input solar fluxes with short wavelength (SWR) are absorbed at the surface considering the parameters <code>AbsParoi</code>. This is the overall surface flux.</p>
<p>In case of long wavelength (LWR), exchanges are linearized with the model <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.LinearExtLWR\"><code>LinearExtLWR</code></a>. The parameter <code>skyViewFactor</code> determines the share of SW radiation of the wall with the sky, considered at <code>T_ciel</code>, and the external environment, considered at <code>T_ext</code>.</p>
<p>The coefficient of convective heat transfer with the outside <code>hs_ext</code> default value is the value of the coefficient integrating convection only. LWR exchanges are considered elsewhere.</p>
<p>This model leads to a linear time-invariant model that can be reduced.</p>
<p><u><b>Bibliography</b></u></p>
<p>TF1 CLIM2000 modified in order to obtain a linear time-invariant model for the purposes of cities study.</p>
<p><u><b>Instructions for use</b></u></p>
<p>This wall can be an outer or inner wall.</p>
<p>The thermal ports <code>T_ext</code> and <code>T_int</code> must be connected to temperature nodes (usually <code>Tseche</code> and <code>Tint</code>). The external incident flows <code>FluxAbs</code> can come from the solar boundary conditions model <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\"><code>SolarBC</code></a>.</p>
<p>The internal incident flows <code>FluxAbsInt</code> can come from occupants, heating systems but also from the redistribution of solar flux within a room (models from <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\"><code>BoundaryConditions.Radiation</code></a> package).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The limitations are mainly related to the flow LWR linearization. Think of distinguish the convective and radiative LWR shares in convection coefficients.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 03/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
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
