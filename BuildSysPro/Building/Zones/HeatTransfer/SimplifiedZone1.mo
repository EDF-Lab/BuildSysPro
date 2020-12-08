within BuildSysPro.Building.Zones.HeatTransfer;
model SimplifiedZone1
  "One-zone simplified model with equivalent building envelope component (wall, floor) and user-defined Uvalue"

// General properties
parameter Modelica.SIunits.CoefficientOfHeatTransfer Ubat
    "Deperditive coefficient for for thermal losses by transmission" annotation(Dialog(group="Global parameters"));
parameter Integer NbNiveau=1 "Number of floors, minimum = 1" annotation(Dialog(group="Global parameters"));
parameter Modelica.SIunits.Volume Vair=240 "Air volume" annotation(Dialog(group="Global parameters"));
parameter Modelica.SIunits.Area SH=100 "Living surface area" annotation(Dialog(group="Global parameters"));
parameter Real renouv(unit="1/h")
    "Ventilation and/or infiltration flow [vol/h]"                                  annotation(Dialog(group="Global parameters"));

// Glazing parameters
parameter Modelica.SIunits.Area SurfaceVitree "Total glazed surface"
                                 annotation(Dialog(group="Glazing"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer k
    "Glazing thermal conductivity" annotation(Dialog(group="Glazing"));
parameter Real skyViewFactorWindows
    "Average sky view factor between glazings and sky (example: upward=1, vertical in clear environment=0.5)"
                                                                                                        annotation(Dialog(group="Glazing"));
parameter Real AbsVitrage=0.1 "Absorptance" annotation(Dialog(group="Glazing"));
parameter Real epsWindows=0.9 "LWR emissivity" annotation(Dialog(group="Glazing"));

// Walls parameters
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraParoiExt
    "External walls definition"
    annotation (choicesAllMatching=true, Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext_paroiExt=18
    "Convective heat transfer coefficient on the outer face for the vertical walls"          annotation(Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int_paroiExt=7.7
    "Convective heat transfer coefficient on the inner face for the vertical walls"      annotation(Dialog(group="Walls"));
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall paraPlancher
    "Floor definition"
    annotation (choicesAllMatching=true, Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_sub_Plancher=5.88
    "Convective heat transfer coefficient on the lower face for the floors"          annotation(Dialog(group="Walls"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_sup_Plancher=5.88
    "Convective heat transfer coefficient on the upper face for the floors"        annotation(Dialog(group="Walls"));
parameter Real b=0.1 "Weighting coefficient for non-heated zones"
                                                              annotation(Dialog(group="Walls"));
parameter Real skyViewFactorParois
    "Average sky view factor between walls and the sky (exemple: upward=1, vertical in clear environment=0.5)"
                                                                                                        annotation(Dialog(group="Walls"));
parameter Real alpha_ext=0.6 "Absorptance of outer walls SWR"
                                 annotation(Dialog(group="Walls"));
parameter Real epsParois=0.7 "Outer walls emissivity in LWR" annotation(Dialog(group="Walls"));

// Initialisation
parameter Modelica.SIunits.Temperature Tinit=292.15
    "Initialisation temperature"  annotation(Dialog(tab="Initialisation"));

// Internal parameters
protected
parameter Modelica.SIunits.Length hTotal=Vair*(NbNiveau/SH)
    "Total building height";
parameter Modelica.SIunits.Area Sdeper=4*hTotal*sqrt(SH/NbNiveau)+2*Splancher
    "Total deperditive surface area";
parameter Modelica.SIunits.Area Swin=SurfaceVitree
    "Total glazed surface with losses";
parameter Modelica.SIunits.Area Sop=Sdeper-Swin
    "Total deperditive surface area of opaque walls";
parameter Modelica.SIunits.Area Splancher=SH/NbNiveau
    "Total deperditive surface area of the lowest floor";
parameter Modelica.SIunits.CoefficientOfHeatTransfer Uplancher=1/(sum(paraPlancher.e./paraPlancher.mat.lambda)+1/hs_sub_Plancher+1/hs_sup_Plancher)
    "Floor Uvalue";
parameter Modelica.SIunits.CoefficientOfHeatTransfer Ug= 1/(1/k+1/hs_ext_paroiExt+1/hs_int_paroiExt)
    "Glazing Uvalue";

  // First order polynomial system resolution to find the value of alpha, multiplying factor of insulating layers in vertical walls and the roof
parameter Real Anew=Ubat*Sdeper-Swin*Ug-b*Uplancher*Splancher
    "Ubat decomposition";
parameter Real coefN1=(Sop-Splancher);
parameter Real coefD1=sum(paraParoiExt.e./paraParoiExt.mat.lambda.*paraParoiExt.positionIsolant);
parameter Real coefD2=sum(paraParoiExt.e./paraParoiExt.mat.lambda.*(ones(paraParoiExt.n)-paraParoiExt.positionIsolant))+1/hs_ext_paroiExt+1/hs_int_paroiExt;

parameter Real alpha=(coefN1-Anew*coefD2)/(Anew*coefD1)
    "Factor of insulating layers (vertical walls and roof)";

  // Computation of Ubat extreme values
parameter Real Umin=(Swin*Ug+Uplancher*b*Splancher)/Sdeper
    "Ubat minimum value for the considered type of floor and glazing";
parameter Real Umax=(Swin*Ug+Uplancher*b*Splancher+(Sop-Splancher)/(sum(paraParoiExt.e./paraParoiExt.mat.lambda.*(ones(paraParoiExt.n)-paraParoiExt.positionIsolant))+1/hs_ext_paroiExt+1/hs_int_paroiExt))/Sdeper
    "Ubat maximal value for the considered type of wall and glazing";

// Internal components
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tinit) "Air node"
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall paroiExt(
    caracParoi(
      n=paraParoiExt.n,
      mat=paraParoiExt.mat,
      m=paraParoiExt.m,
      e=paraParoiExt.e .* (ones(paraParoiExt.n) - paraParoiExt.positionIsolant)
           + alpha*paraParoiExt.e .* paraParoiExt.positionIsolant),
    Tp=Tinit,
    hs_ext=hs_ext_paroiExt,
    hs_int=hs_int_paroiExt,
    skyViewFactor=skyViewFactorParois,
    RadExterne=true,
    GLOext=true,
    S=Sop - Splancher,
    alpha_ext=alpha_ext,
    eps=epsParois) "External walls"
    annotation (Placement(transformation(extent={{-10,38},{10,58}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWindow vitrage(
    hs_ext=hs_ext_paroiExt,
    hs_int=hs_int_paroiExt,
    S=SurfaceVitree,
    skyViewFactor=skyViewFactorWindows,
    k=k,
    Abs=AbsVitrage,
    eps=epsWindows) "Glazing surface"
    annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancher(
    caracParoi(
      n=paraPlancher.n,
      m=paraPlancher.m,
      e=paraPlancher.e,
      mat=paraPlancher.mat,
      positionIsolant=paraPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher,
    hs_ext=hs_sub_Plancher,
    hs_int=hs_sup_Plancher,
    RadExterne=false,
    RadInterne=true,
    GLOext=false) "Lowest floor"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.SimpleWall plancherInt(
    caracParoi(
      n=paraPlancher.n,
      m=paraPlancher.m,
      e=paraPlancher.e,
      mat=paraPlancher.mat,
      positionIsolant=paraPlancher.positionIsolant),
    Tp=Tinit,
    S=Splancher*(NbNiveau - 1),
    hs_ext=hs_sub_Plancher,
    hs_int=hs_sup_Plancher,
    RadInterne=true) if NbNiveau > 1 "intermediate floors"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-70})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal ventilationSimple(Qv=renouv
        *Vair)
    annotation (Placement(transformation(extent={{-12,-116},{8,-96}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-22,8},{-18,12}}), iconTransformation(
          extent={{-192,4},{-172,24}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tint annotation (
      Placement(transformation(extent={{18,8},{22,12}}), iconTransformation(
          extent={{60,-76},{80,-56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient coefficientBsol(b=b)
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Modelica.Blocks.Math.Gain gainTransmisPlancher(k=1/NbNiveau) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={28,-42})));
  Modelica.Blocks.Math.Gain gainTransmisPlancherIntermediaire(k=(NbNiveau - 1)/
        NbNiveau) if
               NbNiveau>1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={38,-60})));
// Public components
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Air temperature" annotation (Placement(transformation(extent={{-110,30},{
            -90,50}}),  iconTransformation(extent={{-130,70},{-110,90}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int
    "Indoor air heat port" annotation (Placement(transformation(extent={{80,0},
            {100,20}}), iconTransformation(extent={{70,-50},{90,-30}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncGlazing
    "Surface incident solar flux on glazings" annotation (Placement(
        transformation(extent={{-120,-10},{-80,30}}), iconTransformation(extent={{-100,10},
            {-80,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncWall
    "Surface incident solar flux on external walls" annotation (Placement(
        transformation(extent={{-120,52},{-80,92}}),  iconTransformation(extent=
           {{-100,30},{-80,50}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxTrGlazing
    "Transmitted solar flux through glazings (must take into account the influence of incidence)"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky
    "Sky temperature for LW radiation"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}}),
        iconTransformation(extent={{-50,110},{-30,130}})));

// For validation in stationary operation: set the parameters to have SWR, LWR (abs and eps), air renewal at zero and 1°C of difference between outdoor and indoor)
  Real UbatEffectif=T_int.Q_flow/Sdeper;

equation
assert(max(paraParoiExt.positionIsolant)==1, "No insulating layer specified for outer walls. Edit paraParoiExt.positionIsolant");
assert(max(paraPlancher.positionIsolant)==1, "No insulating layer specified for floors. Edit paraPlancher.positionIsolant");
assert(Ubat<Umax and Ubat>Umin,"The value of Ubat depends on selected types of glazing and walls. Given the current configuration, "+String(Umin)+"<Ubat<"+String(Umax));

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
      points={{-100,40},{-50,40},{-50,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Regulatory boundary limits
  connect(coefficientBsol.port_int, Tint) annotation (Line(
      points={{-49,-83},{-49,-91.5},{20,-91.5},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.port_ext, Text) annotation (Line(
      points={{-49,-77},{-49,-69.5},{-20,-69.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Floor connections
  connect(plancher.T_int, Tint)
                           annotation (Line(
      points={{9,-83},{9,-82.5},{20,-82.5},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(coefficientBsol.Tponder, plancher.T_ext) annotation (Line(
      points={{-35,-80.2},{-33.5,-80.2},{-33.5,-83},{-9,-83}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(plancher.FluxAbsInt, gainTransmisPlancher.y) annotation (Line(
      points={{3,-75},{28,-75},{28,-48.6}},
      color={0,0,127},
      smooth=Smooth.None));
// Ventilation
  connect(ventilationSimple.port_b, Tint) annotation (Line(
      points={{7,-106},{20,-106},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ventilationSimple.port_a, Text) annotation (Line(
      points={{-11,-106},{-20,-106},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));

// Glazing
  connect(vitrage.T_ext, Text)     annotation (Line(
      points={{-9,-35},{-9,-30.5},{-20,-30.5},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitrage.T_int, Tint)     annotation (Line(
      points={{9,-35},{20,-35},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(vitrage.CLOTr, gainTransmisPlancherIntermediaire.u) annotation (Line(
      points={{9,-27},{37.5,-27},{37.5,-52.8},{38,-52.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(gainTransmisPlancher.u, vitrage.CLOTr) annotation (Line(
      points={{28,-34.8},{28,-27},{9,-27}},
      color={255,170,85},
      smooth=Smooth.None));
// External walls
  connect(paroiExt.T_int, Tint)     annotation (Line(
      points={{9,45},{20,45},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(paroiExt.T_ext, Text)     annotation (Line(
      points={{-9,45},{-20,45},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(paroiExt.T_sky, T_sky) annotation (Line(
      points={{-9,39},{-30,39},{-30,120},{-40,120}},
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
  connect(FluxIncWall, paroiExt.FluxIncExt)
    annotation (Line(points={{-100,72},{-3,72},{-3,53}}, color={255,192,1}));
  connect(vitrage.FluxIncExt,FluxIncGlazing)  annotation (Line(points={{-3,-27},
          {-60,-27},{-60,10},{-100,10}}, color={255,192,1}));
  connect(FluxTrGlazing, vitrage.FluxTr)
    annotation (Line(points={{-100,-30},{-3,-30}}, color={255,192,1}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,
            -120},{120,120}})),  Icon(coordinateSystem(preserveAspectRatio=true,
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
<p><i><b>Linearised and time-invariant model of a single zone considering equivalent building components and a user-defined Uvalue</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows the representation of Individual House / Collective Housing / Tertiary Building in single zone. The modelling is simplified to consider only an equivalent external wall and an equivalent glazing surface both being independant of the orientation.</p>
<p>The level of thermal losses represented by Ubat is a parameter of the model. This model leads to a linear time-invariant model that can be reduced.</p>
<p><b>Geometry</b></p>
<p>Model of a parallelepiped 0D-1D square section single-zone.  The building height depends on the number of levels (<code>NbNiveau</code>), on total air volume (<code>Vair</code>) and on the living area (<code>SH</code>). Glazing are defined by a total surface.</p>
<p><b>Building typology</b></p>
<p>Constructive system (materials and layers thicknesses) are considered in detail through wall definition <code>caracParoiExt, caracPlancher</code>...</p>
<p>Inertia is adjustable by choosing the constructive mode.</p>
<p><b>Physics</b></p>
<p>The external wall describe the ceiling/roof and the external vertical walls. They are subject to short-wave and long-wave radiations (SWR and LWR).</p>
<p>Long-wave radiations on the glazing and walls outer faces are linearized. </p>
<p>The calculation of incident and transmitted irradiations is outsourced of this model and is performed by a <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\">SolarBC</a> model. This calculation is detailed and considers the influence of the walls and glazing orientation. Therefore the non-linear incidence of the angle of incidence for short-wave radiation, is outsourced. The transmitted irradiation through the glazing is absorbed on floor(s) surface.</p>
<p>The coefficient B defined a boundary condition in term of temperature on the  outer face of the lowest floor.

<p><u><b>Bibliography</b></u></p>
<p>Refer to <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">walls</a> and <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\">glazings</a> modelling assumptions.</p>
<p> Eui-Jong Kim, Gilles Plessis, Jean-Luc Hubert, Jean-Jacques Roux, 2014.<i>Urban energy simulation: Simplification and reduction of building envelope models</i>. Energy and Buildings 84 p193-202.
<p><u><b>Instructions for use</b></u></p>
<p>The irradiation connectors should be connected to a <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone\">FLUXzone</a> model. The outdoor temperature port must be connected to a weather data reader <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Meteofile\">Meteofile</a>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Depending on the chosen constructive system and the type of glazing, Ubat cannot be chosen anyhow. It must necessarily be bounded. An error message occurs when the selected Ubat is out of this range.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis, Hassan Bouia 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Gilles PLESSIS, Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 09/2015 : Ajout d'<code>assert</code> prévenant la non définition de couche isolante.</p>
<p>Gilles Plessis 03/2016 : Paramètres <code>hs_ext_Plancher</code> et <code>hs_int_Plancher</code> renommés en <code>hs_sub_Plancher</code> et <code>hs_sup_Plancher</code>.</p>
<p>Benoît Charrier 02/2017 : Deleting useless solar transmission coefficient <code>Tr</code> because of transmitted solar radiation in input.</p>
</html>"));
end SimplifiedZone1;
