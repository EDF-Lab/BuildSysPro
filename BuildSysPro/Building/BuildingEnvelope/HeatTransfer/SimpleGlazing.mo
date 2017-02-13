within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model SimpleGlazing "Simple model of glazing"

// General properties

parameter Boolean useVolet=false "Presence of a shutter" annotation(Dialog(group="Options",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
parameter Boolean GLOext=false
    "Inclusion of LW radiation (infrared) between the wall and the environment and the sky in linearized form"
    annotation(Dialog(group="Options",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
    parameter Modelica.SIunits.Area S=1 "Glazing surface" annotation(Dialog(group="General properties"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=16
    "Coefficient of convective or global surface exchange on the outer face depending on the selected mode (GLOext)"
                                                                                                        annotation(Dialog(group="General properties"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=8.29
    "Coefficient global surface exchange on the inner face" annotation(Dialog(group="General properties"));
parameter Modelica.SIunits.ThermalInsulance R_volet=0.2
    "Additional thermal resistance (shutters closed)"                                                          annotation(Dialog(group="General properties",enable=useVolet==true));
parameter Modelica.SIunits.CoefficientOfHeatTransfer k=1.43
    "Glazing coefficient of surface transmission Ug  - without convective exchanges"  annotation(Dialog(group="General properties"));
parameter Real skyViewFactor=0
    "Sky view factor between glazings and the sky (exemple: skyViewFactor(flat roof)=1, skyViewfactor(vertical wall in clear environment)=0.5)"
                                                                                                        annotation(Dialog(enable=GLOext,group="General properties"));

// Optical properties
parameter Real Abs=0.1 "Window absorption coefficient" annotation(Dialog(group="Optical properties"));
parameter Real eps=0.9 "Emissivity" annotation(Dialog(enable=GLOext,group="Optical properties"));

// Public components
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxTr
    "Global solar flux information for the transmission. Must integrate the impact of incidence."
    annotation (Placement(transformation(extent={{-120,50},{-80,90}}),
        iconTransformation(extent={{-40,10},{-20,30}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt
    "SWR incident surface fluxes on the outer face" annotation (
      Placement(transformation(extent={{-120,20},{-80,60}}), iconTransformation(
          extent={{-40,40},{-20,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr
    "SW radiation transmitted inside" annotation (Placement(
        transformation(extent={{60,50},{100,90}}), iconTransformation(extent={{
            80,40},{100,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outdoor temperature" annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}}), iconTransformation(extent={{-100,-40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Temperature of outer surface" annotation (Placement(transformation(
          extent={{-40,-40},{-20,-20}}), iconTransformation(extent={{-40,-40},{
            -20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Temperature of inner surface" annotation (Placement(transformation(
          extent={{20,-40},{40,-20}}), iconTransformation(extent={{20,-40},{40,
            -20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Indoor temperature" annotation (Placement(transformation(extent={{80,
            -40},{100,-20}}), iconTransformation(extent={{80,-40},{100,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if GLOext
    "Sky temperature for LW radiation" annotation (Placement(
        transformation(extent={{-100,-100},{-80,-80}}), iconTransformation(
          extent={{-100,-100},{-80,-80}})));
public
  Modelica.Blocks.Interfaces.RealInput fermeture_volet if      useVolet==true
    "Closing rate of the shutter" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={6,110}), iconTransformation(extent={{-100,66},{-72,94}},
          rotation=0)));

// Internal components

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
Modelica.Blocks.Math.Gain FluxTransmis(k=S)    annotation (Placement(
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

  // The flux is transmitted only through the window (blackout shutter)
  FluxTransmis.u=(1-volet_internal)*FluxTr;

  // Calculation of the full window thermal conductance (glazing + shutters) excluding convection
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
<p><b>Simple linear model of glazing</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This is a model of a simple window. Incident flows with short wavelength (SWR) are global surface flows. The influence of the angle of incidence on the direct flows transmission (non-linear) is outsourced and therefore not described in this model.</p>
<p>Long wavelength (LW) exchanges are linearized with the model <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.LinearExtLWR\"><code>LinearExtLWR</code></a>. The parameter <code>skyViewFactor</code> determines the share of long wavelength radiation of the wall with the sky, considered at <code>T_ciel</code>, and the external environment, considered at <code>T_ext</code>.</p>
<p>The coefficient <code>k</code> represents the glazing conductivity without considering convective exchanges (different from Ug or Uw usually used). The coefficient of convective heat transfer with the outside <code>hs_ext</code> default value is the value of the coefficient integrating convection only. LWR exchanges are considered elsewhere.</p>
<p>This model leads to a linear time-invariant model that can be reduced.</p>
<p>Regarding the rolling shutters, the assumptions are:</p>
<ul>
<li>No solar flux transmitted by the part obscured by the shutters</li>
<li>Absorbed flux unchanged (PVC absorbency similar to that of glass)</li>
<li>If the shutter is not completely closed (Coeff_Fermeture &lt;95&#37;), unchanged thermal resistance</li>
<li>If the shutter is fully closed, increased thermal resistance of an additional thermal resistance, evaluated at 0.2 m&sup2;K / W (PVC thickness of 12 mm approx.)</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p><a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\"><code>Window</code></a> model modified in order to obtain a linear time-invariant model for the purposes of cities study.</p>
<p>CSTB. 2005. Guide réglementaire RT 2005. Règle d&apos;application Th-Bât Th-U 3/5 Parois vitrées.</p>
<p><u><b>Instructions for use</b></u></p>
<p>The thermal ports <code>T_ext</code> and <code>T_int</code> must be connected to temperature nodes (usually <code>Tseche</code> and <code>Tint</code>). The external incident flows <code>FluxIncExt</code> and <code>FluxTr</code> come from the solar boundary conditions model <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.SolarBC\"><code>SolarBC</code></a>. The correspondence between their settings must be made.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The limitations are mainly related to the LWR flows linearization and to the outsourcing of the influence of the impact on SWR transmitted fluxes.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Gilles PLESSIS, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 03/2014 : ajout de la possibilité de commander un volet (fermeture_volet qui varie entre 0 et 1 - 1 quand le volet est fermé, 0 quand le volet est ouvert), avec la résistance thermique supplémentaire que cela engendre.</p>
<p>Gilles Plessis 07/2015 : ajout de la possibilité optionnelle de prise en compte du rayonnement GLO linéarisé.</p>
<p>Benoît Charrier 02/2017 : deleting useless application of solar transmission coefficient because of transmitted solar radiation in input.</p>
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
