within BuildSysPro.Building.Zones.HeatTransfer;
model SimplifiedZone2
  "One-zone simplified model with equivalent building envelope component (roof, wall, floor)"

// General properties
parameter Integer NbNiveaux "Number of floors, minimum = 1" annotation(Dialog(group="Global parameters"));
  parameter Modelica.Units.SI.Volume Vair=240 "Air volume"
    annotation (Dialog(group="Global parameters"));
  parameter Modelica.Units.SI.Area SH=100 "Living surface area"
    annotation (Dialog(group="Global parameters"));
    parameter Real renouv "Ventilation and/or infiltration flow [vol/h]" annotation(Dialog(group="Global parameters"));
  parameter Modelica.Units.SI.ThermalConductance Psi_L
    "Thermal bridge coefficient" annotation (Dialog(group="Global parameters"));

// Glazing parameters
  parameter Modelica.Units.SI.Area SurfaceVitree "Total glazed surface"
    annotation (Dialog(group="Glazing"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer U=1
    "Glazing deperditive coefficient" annotation (Dialog(group="Glazing"));

parameter Real AbsVitrage=0.1 "Absorptance" annotation(Dialog(group="Glazing"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_ext_Vitrage=16.7
    "Convective heat transfer coefficient on the outer face"
    annotation (Dialog(group="Glazing"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_int_Vitrage=9.1
    "Convective heat transfer coefficient on the inner face"
    annotation (Dialog(group="Glazing"));

// Walls parameters
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracParoiExt
    "External walls definition"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group="Walls"));
  parameter Modelica.Units.SI.Area SParoiExt
    "Deperditive surface area of vertical walls"
    annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_ext_ParoiExt=25
    "Convective heat transfer coefficient on the outer face for the vertical walls"
    annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_int_ParoiExt=7.7
    "Convective heat transfer coefficient on the inner face for the vertical walls"
    annotation (Dialog(group="Walls"));

  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracPlancher
    "Floor definition"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_inf_Plancher=25
    "Convective heat transfer coefficient on the lower face for the floors"
    annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_sup_Plancher=7.7
    "Convective heat transfer coefficient on the upper face for the floors"
    annotation (Dialog(group="Walls"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracToiture
    "Roof definition"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group="Walls"));
  parameter Modelica.Units.SI.Area SToiture
    "Deperditive surface area of the roofs" annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_ext_Toiture=25
    "Convective heat transfer coefficient on the outer face for the roofs"
    annotation (Dialog(group="Walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_int_Toiture=7.7
    "Convective heat transfer coefficient on the inner face for the roofs"
    annotation (Dialog(group="Walls"));

parameter Real b=1 "Weighting coefficient for non-heated zones"
                                                 annotation(Dialog(group="Walls"));

parameter Real alpha_ext=0.8 "Absorptance of outer walls SWR"
                                 annotation(Dialog(group="Walls"));
parameter Real epsParois=0.9 "Outer walls emissivity in LWR" annotation(Dialog(group="Walls"));

// Initialisation
  parameter Modelica.Units.SI.Temperature Tinit=293.15
    "Initialisation temperature" annotation (Dialog(tab="Initialisation"));

// Internal parameters
protected
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k=1/(1/U - 1/
      hs_ext_Vitrage - 1/hs_int_Vitrage)
    "Conductive heat transfer coefficient for the glazed surfaces";
  parameter Modelica.Units.SI.Length hTotal=Vair*(NbNiveaux/SH)
    "Total building height";
  parameter Modelica.Units.SI.Area Sdeper=4*hTotal*sqrt(SH/NbNiveaux) + 2*
      Splancher "Total deperditive surface area";
  parameter Modelica.Units.SI.Area Swin=SurfaceVitree
    "Total deperditive surface area of glazed surface";
  parameter Modelica.Units.SI.Area Sop=Sdeper - Swin
    "Total deperditive surface area of opaque walls";
  parameter Modelica.Units.SI.Area Splancher=SH/NbNiveaux
    "Total deperditive surface area of the lowest floor";

// Internal components
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tinit) "Air node"
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall paroiExt(
    caracParoi(
      n=caracParoiExt.n,
      mat=caracParoiExt.mat,
      m=caracParoiExt.m,
      e=caracParoiExt.e),
    Tp=Tinit,
    RadExterne=true,
    GLOext=false,
    S=SParoiExt,
    alpha_ext=alpha_ext,
    hs_ext=hs_ext_ParoiExt,
    hs_int=hs_int_ParoiExt) "External walls"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWindow vitrage(
    S=SurfaceVitree,
    k=k,
    Abs=AbsVitrage,
    hs_ext=hs_ext_Vitrage,
    hs_int=hs_int_Vitrage) "Glazing surface"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancher(
    caracParoi(
      n=caracPlancher.n,
      m=caracPlancher.m,
      e=caracPlancher.e,
      mat=caracPlancher.mat,
      positionIsolant=caracPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher,
    hs_ext=hs_inf_Plancher,
    hs_int=hs_sup_Plancher,
    RadExterne=false,
    RadInterne=true,
    GLOext=false) "Lowest floor"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall toiture(
    Tp=Tinit,
    RadExterne=true,
    alpha_ext=alpha_ext,
    caracParoi(
      n=caracToiture.n,
      mat=caracToiture.mat,
      m=caracToiture.m,
      e=caracToiture.e),
    GLOext=false,
    S=SToiture,
    hs_ext=hs_ext_Toiture,
    hs_int=hs_int_Toiture) "Roofs"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancherInt(
    caracParoi(
      n=caracPlancher.n,
      m=caracPlancher.m,
      e=caracPlancher.e,
      mat=caracPlancher.mat,
      positionIsolant=caracPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher*(NbNiveaux - 1),
    hs_ext=hs_inf_Plancher,
    hs_int=hs_sup_Plancher,
    RadInterne=true) if NbNiveaux > 1 "intermediate floors"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-70})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal ventilationSimple(Qv=
        renouv*Vair)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.ThermalBridge pontThermique(
    L=1, k=Psi_L*1)           annotation (
      Placement(transformation(extent={{-10,-120},{10,-100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-22,8},{-18,12}}), iconTransformation(
          extent={{-192,4},{-172,24}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tint annotation (
      Placement(transformation(extent={{18,8},{22,12}}), iconTransformation(
          extent={{60,-76},{80,-56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient coefficientBsol(b=b)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Math.Gain gainTransmisPlancher(k=1/NbNiveaux) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={28,-42})));
  Modelica.Blocks.Math.Gain gainTransmisPlancherIntermediaire(k=(NbNiveaux - 1)/
        NbNiveaux) if
               NbNiveaux>1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={38,-60})));
// Public components
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Air temperature" annotation (Placement(transformation(extent={{-130,70},{
            -110,90}}), iconTransformation(extent={{-130,70},{-110,90}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int
    "Indoor air heat port" annotation (Placement(transformation(extent={{80,0},
            {100,20}}), iconTransformation(extent={{70,-50},{90,-30}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncGlazing
    "Surface incident solar flux on glazings" annotation (Placement(
        transformation(extent={{-120,-10},{-80,30}}), iconTransformation(extent={{-100,10},
            {-80,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncWall
    "Surface incident solar flux on external walls" annotation (Placement(
        transformation(extent={{-120,30},{-80,70}}), iconTransformation(extent=
            {{-100,30},{-80,50}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxTrGlazing
    "Transmitted solar flux through glazings (must take into account the influence of incidence)"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncRoof
    "Surface incident solar flux on external roofs" annotation (Placement(
        transformation(extent={{-120,80},{-80,120}}), iconTransformation(extent={{-100,50},
            {-80,70}})));
BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext[2]
    "Surface temperature for LW radiation (roof and external walls)"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));

equation
// Air node and internal ports
  connect(noeudAir.port_a, T_int) annotation (Line(
      points={{60,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tint) annotation (Line(
      points={{60,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, Text) annotation (Line(
      points={{-120,80},{-50,80},{-50,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Boundary conditions
  connect(coefficientBsol.port_int, Tint) annotation (Line(
      points={{-58,-54},{-58,-67.5},{20,-67.5},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.port_ext, Text) annotation (Line(
      points={{-58,-46},{-58,-39.5},{-20,-39.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Floor connections
  connect(plancher.T_int, Tint)
                           annotation (Line(
      points={{9,-53},{9,-52.5},{20,-52.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.Tponder, plancher.T_ext) annotation (Line(
      points={{-46,-50},{-33.5,-50},{-33.5,-53},{-9,-53}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancher.FluxAbsInt, gainTransmisPlancher.y) annotation (Line(
      points={{3,-45},{28,-45},{28,-48.6}},
      color={0,0,127},
      smooth=Smooth.None));

// Connexions de la toiture
  connect(T_ext, toiture.T_ext) annotation (Line(points={{-120,80},{-50,80},{
          -50,87},{-9,87}},
                        color={191,0,0}));
  connect(toiture.T_int, noeudAir.port_a) annotation (Line(points={{9,87},{20,
          87},{20,10},{60,10}},             color={191,0,0}));
// Ventilation
  connect(ventilationSimple.port_b, Tint) annotation (Line(
      points={{9,-80},{20,-80},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ventilationSimple.port_a, Text) annotation (Line(
      points={{-9,-80},{-20,-80},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Glazing
  connect(vitrage.T_ext, Text)     annotation (Line(
      points={{-9,-13},{-9,-12.5},{-20,-12.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrage.T_int, Tint)     annotation (Line(
      points={{9,-13},{20,-13},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrage.CLOTr, gainTransmisPlancherIntermediaire.u) annotation (Line(
      points={{9,-5},{37.5,-5},{37.5,-52.8},{38,-52.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(gainTransmisPlancher.u, vitrage.CLOTr) annotation (Line(
      points={{28,-34.8},{28,-5},{9,-5}},
      color={255,170,85},
      smooth=Smooth.None));
// External walls
  connect(paroiExt.T_int, Tint)     annotation (Line(
      points={{9,27},{20,27},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExt.T_ext, Text)     annotation (Line(
      points={{-9,27},{-20,27},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Intermediate floors
  connect(plancherInt.FluxAbsInt, gainTransmisPlancherIntermediaire.y)
    annotation (Line(
      points={{65,-75},{38,-75},{38,-66.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(plancherInt.T_ext, noeudAir.port_a) annotation (Line(
      points={{77,-67},{82,-67},{82,-14},{60,-14},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancherInt.T_int, noeudAir.port_a) annotation (Line(
      points={{59,-67},{50,-67},{50,-14},{60,-14},{60,10}},
      color={255,0,0},
      smooth=Smooth.None));
      // Connexion for external LWR calculation
  connect(paroiExt.Ts_ext, Ts_ext[1]) annotation (Line(points={{-3,27},{-4.5,27},
          {-4.5,55},{-20,55}},   color={191,0,0}));
  connect(Ts_ext[2], toiture.Ts_ext) annotation (Line(points={{-20,65},{-4,65},
          {-4,87},{-3,87}},color={191,0,0}));
    // Thermal bridge
  connect(pontThermique.T_int, Tint) annotation (
     Line(points={{9,-110},{20,-110},{20,10}},
        color={191,0,0}));
  connect(pontThermique.T_ext, Text) annotation (
     Line(points={{-9,-110},{-20,-110},{-20,10}},
        color={191,0,0}));
  connect(FluxIncRoof, toiture.FluxIncExt) annotation (Line(points={{-100,100},
          {-60,100},{-60,95},{-3,95}},
                                     color={255,192,1}));
  connect(FluxIncWall, paroiExt.FluxIncExt) annotation (Line(points={{-100,50},
          {-60,50},{-60,35},{-3,35}}, color={255,192,1}));
  connect(FluxIncGlazing, vitrage.FluxIncExt) annotation (Line(points={{-100,10},
          {-60,10},{-60,-5},{-3,-5}},       color={255,192,1}));
  connect(FluxTrGlazing, vitrage.FluxTr)
    annotation (Line(points={{-100,-30},{-60,-30},{-60,-8},{-3,-8}},
                                                   color={255,192,1}));
  connect(T_ext, T_ext)
    annotation (Line(points={{-120,80},{-120,80}},           color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,
            -120},{120,120}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-120},{120,120}}), graphics={
        Polygon(
          points={{-100,100},{-60,60},{-60,-100},{-100,-58},{-100,100}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-100,100},{38,100},{100,60},{-60,60},{-100,100}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,60},{100,60},{100,-100},{-60,-100},{-60,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Polygon(
          points={{-46,54},{-46,34},{-8,34},{-8,54},{-46,54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,20},{-46,0},{-8,0},{-8,20},{-46,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-20},{-48,-40},{-10,-40},{-10,-20},{-48,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-54},{-48,-74},{-10,-74},{-10,-54},{-48,-54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,-54},{26,-74},{64,-74},{64,-54},{26,-54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,-20},{26,-40},{64,-40},{64,-20},{26,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,20},{26,0},{64,0},{64,20},{26,20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,54},{26,34},{64,34},{64,54},{26,54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,80},{-90,60},{-70,40},{-70,60},{-90,80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,40},{-90,20},{-70,0},{-70,20},{-90,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,0},{-90,-20},{-70,-40},{-70,-20},{-90,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,-40},{-90,-60},{-70,-80},{-70,-60},{-90,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i><b>Linearised and time-invariant model of a single zone considering equivalent building components</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows the representation of Individual House / Collective Housing / Tertiary Building in single zone. The modelling is simplified to consider only an equivalent external wall and an equivalent glazing surface both being independant of the orientation.</p>
<p>The level of thermal losses represented by Ubat is a parameter of the model. This model leads to a linear time-invariant model that can be reduced.</p>
<p><b>Geometry</b></p>
<p>Model of a parallelepiped 0D-1D square section single-zone. The building height depends on the number of levels (<code>NbNiveau</code>), on total air volume (<code>Vair</code>) and on the living area (<code>SH</code>). Glazing are defined by a total surface.</p>
<p><b>Building typology</b></p>
<p>Constructive system (materials and layers thicknesses) are considered in detail through wall definition <code>caracParoiExt, caracPlancher</code>...</p>
<p>Inertia is adjustable by choosing the constructive mode.</p>
<p><b>Physics</b></p>
<p>The building envelope is decomposed into 3 equivalent models for external walls, roof and floor. The external wall  and roof models are subject to short-wave and long-wave radiations (SWR and LWR).</p>
<p>Long-wave radiations on the external walls and roof are outsourced and should be computed through the <code>Ts</code> connector.</p>
<p>The calculation of incident and transmitted irradiations is outsourced of this model and is performed by a <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\">SolarBC</a> model. This calculation is detailed and considers the influence of the walls and glazing orientation. Therefore the non-linear incidence of the angle of incidence for short-wave radiation, is outsourced. The transmitted irradiation through the glazing is absorbed on floor(s) surface.</p>
<p>The coefficient B defined a boundary condition in term of temperature on the  outer face of the lowest floor.

<p><u><b>Bibliography</b></u></p>
<p>Refer to <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">walls</a> and <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\">glazings</a> modelling assumptions.</p>
<p> Eui-Jong Kim, Gilles Plessis, Jean-Luc Hubert, Jean-Jacques Roux, 2014.<i>Urban energy simulation: Simplification and reduction of building envelope models</i>. Energy and Buildings 84 p193-202.
<p><u><b>Instructions for use</b></u></p>
<p>The irradiation connectors should be connected to <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\">SolarBC</a> models. The outdoor temperature port must be connected to a weather data reader <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Meteofile\">Meteofile</a>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis, Hassan Bouia 07/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Gilles PLESSIS, Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 07/2015 : Modèle dérivé de MonozoneSimplifie de BuildSysPro 2015.04 pour les besoin du projet ANR MERUBBI.</p>
<p>Ajout d'un composant pour la toiture et pont thermique.</p>
<p>Les échanges GLO linéaire sont supprimés pour &ecirc;tre externalisé via le port <code>Ts</code> grâce à un calcul de facteur de forme.</p>
<p>Benoît Charrier 02/2017 : Deleting useless solar transmission coefficient <code>Tr</code> because of transmitted solar radiation in input.</p>
</html>"));
end SimplifiedZone2;
