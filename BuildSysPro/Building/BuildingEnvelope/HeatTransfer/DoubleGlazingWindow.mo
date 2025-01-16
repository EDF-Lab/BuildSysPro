within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model DoubleGlazingWindow "Double glazing with as only parameters U, tau and g"

//// Model parameters to fill
parameter Boolean useVolet=false annotation(Dialog(group="Options",compact=true),choices(choice=true
        "With shutter",                                                                                               choice=false
        "Without shutter",                                                                                                  radioButtons=true));
parameter Boolean useOuverture=false    annotation(Dialog(group="Options",compact=true),choices(choice=true
        "With opening",                                                              choice=false
        "Without opening",                                                                                             radioButtons=true));
    parameter Boolean useEclairement=false
     annotation(Dialog(group="Options",compact=true),choices(choice=true
        "With calculation of natural lighting",                                                             choice=false
        "Without calculation of natural lighting",                                                                                                  radioButtons=true));

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer U
    "Thermal conductivity of the glazing"
    annotation (Dialog(group="Manufacturer data"));
parameter Real tau "Coefficient of energy transmission" annotation(Dialog(group="Manufacturer data"));
parameter Real g "Solar factor" annotation(Dialog(group="Manufacturer data"));

parameter Real eps=0.9 "Glazing emittance in LWR" annotation(Dialog(group="Manufacturer data"));
  parameter Modelica.Units.SI.Area S=1 "Glazed surface";
  parameter Modelica.Units.SI.Length H=1 "Height of the glazing";
  parameter Modelica.Units.SI.Length L=1 "Width of the glazing"
    annotation (Dialog(enable=useEclairement));
  parameter Modelica.Units.NonSI.Angle_deg incl=90
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°";

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_ext=21
    "Global or convective surface exchange coefficient on the outer face depending on the selected mode (GLOext)";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hs_int=8.29
    "Surface exchange coefficient on the inner face";
  parameter Modelica.Units.SI.ThermalInsulance R_volet=0.2
    "Additional thermal resistance (shutters closed))"
    annotation (Dialog(enable=useVolet));

//// FenetreRad model parameters calculated
protected
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k=1/(1/U - 1/heEN673 -
      1/hi)
    "Surface transmission coefficient k of the glazing - without convective exchanges";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer heEN673=25
    "Coefficient of global surface exchange on the outer face used to measure the glazing properties in EN 673 standard (determination of U)";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer heEN410=23
    "Coefficient of global surface exchange on the outer face used to measure the glazing properties in EN 410 standard (Luminous and solar characteristics of glazing)";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hi=7.7
    "Coefficient of global surface exchange on the inner face used to measure the glazing properties (in 410 and 673)";

parameter Real alpha=(g-tau)*(1/hi+1/heEN410+1/k)/(2/heEN410+1/k)
    "Direct absorption coefficient of a glass";

parameter Real TrDir=tau "Direct transmission coefficient of the glazing";
parameter Real AbsDir=alpha-tau+sqrt(tau^2+2*tau*alpha-tau*alpha^2)
    "Direct absorption coefficient of glazing";

parameter Real TrDif=0.983*tau-0.068
    "Coefficient of diffuse transmission of the glazing";
parameter Real AbsDif=1.17*AbsDir-0.24*AbsDir^2
    "Coefficient of diffuse absorption of the glazing";

// Reduction factors of direct and diffuse fluxes (masking, frame, ...)
parameter Boolean useReduction=false "Inclusion or not of reduction factors"
    annotation (Dialog(tab="Type of glazing"));
parameter Integer TypeFenetrePF=1 "Choice of type of window or French window"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"),
    choices( choice= 1 "I do not know - no frame",
             choice= 2 "Wood window sashes",
             choice= 3 "Metal window sashes",
             choice= 4 "French window sashes with wood bedrock",
             choice= 5 "French window sashes without wood bedrock",
             choice= 6 "French window sashes without metal bedrock",
             choice= 7 "Wood sliding window",
             choice= 8 "Metal sliding window",
             choice= 9 "Sliding French window with wood bedrock",
             choice= 10 "Sliding French window without wood bedrock",
             choice= 11 "Sliding French window without metal bedrock"));
             parameter Real voilage=0.95
    "Presence of net curtains : = 0.95 if yes and = 1 if not"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real position=0.90
    "Glazing position: = 0.9 if inner and = 1 if outer"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real rideaux=0.85
    "Presence of curtains: = 0.85 if yes and = 1 if not"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real ombrages=0.85
    "Obstacles shading (vegetation, neighborhood): = 0.85 if yes et = 1 if not"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real r1=1 "Reduction factor for the direct if useReduction = false"
    annotation (Dialog(tab="Type of glazing",enable=not useReduction,group="Reduction factors if useReduction = false"));
parameter Real r2=1 "Reduction factor for the diffuse if useReduction = false"
    annotation (Dialog(tab="Type of glazing",enable=not useReduction,group="Reduction factors if useReduction = false"));

// Consideration of radiative flux within the window
public
parameter Boolean RadInterne=false "Consideration radiative fluxes inside"
                                            annotation(Dialog(tab="Advanced parameters",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
parameter Boolean DifDirOut=false
    "Output of direct and diffuse fluxes instead of the total flux" annotation(Dialog(tab="Advanced parameters",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
parameter Boolean GLOext=false
    "Consideration of LW radiation toward the environment and the sky" annotation(Dialog(tab="Advanced parameters",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));

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
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt[3]
    "Incident solar surface flux information 1-Diffuse flux [W/m2], 2-Direct flux [W/m2], 3-Cosi"
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr if not
    DifDirOut "SW radiation transmitted inside [W]" annotation (Placement(
        transformation(extent={{60,50},{100,90}}), iconTransformation(extent={{
            80,40},{100,60}})));
  Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt
 if RadInterne "Flux (LWR/SWR) absorbed by the glazing on its inner face [W]"
    annotation (Placement(transformation(extent={{120,-10},{82,28}}),
        iconTransformation(extent={{40,20},{20,40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outdoor temperature" annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}}), iconTransformation(extent={{-100,-40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Outer surface temperature" annotation (Placement(transformation(
          extent={{-40,-40},{-20,-20}}), iconTransformation(extent={{-40,-40},{
            -20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Inner surface temperature" annotation (Placement(transformation(
          extent={{20,-40},{40,-20}}), iconTransformation(extent={{20,-40},{40,
            -20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Indoor temperature" annotation (Placement(transformation(extent={{80,
            -40},{100,-20}}), iconTransformation(extent={{80,-40},{100,-20}})));

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr2[3]
 if DifDirOut "SW radiation transmitted inside 1-Diffuse [W], 2-Direct [W], 3-cosi"
    annotation (Placement(transformation(extent={{60,24},{100,64}}),
        iconTransformation(extent={{80,40},{100,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky  if GLOext
    "Sky temperature" annotation (Placement(transformation(extent={{-100,-100},
            {-80,-80}}), iconTransformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Interfaces.RealInput fermeture_volet      if useVolet
    "Shutters closing rate (0 opened, 1 closed)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,112}), iconTransformation(extent={{-88,66},{-60,94}},
          rotation=0)));
public
  Modelica.Blocks.Interfaces.BooleanInput
                                       ouverture_fenetre if useOuverture
    "True if opened false if not" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,112}), iconTransformation(extent={{-48,-14},{-20,14}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput V    if useOuverture
    "Wind speed perpendicular to the glazing (m/s)" annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-100,-10},{-80,10}})));
public
  Modelica.Blocks.Interfaces.RealOutput Flum[3] if useEclairement
    "Tranmitted luminous fluxes -direct -diffuse -reflected (lumen)"
    annotation (Placement(transformation(extent={{80,-84},{126,-38}}),
        iconTransformation(extent={{80,-108},{106,-82}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Incident illumination -direct -diffuse -reflected (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-101,81}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,30})));
  parameter Real e=0.35
    "Thickness of the vertical wall in which the glazing is integrated" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real azimut=0
    "Surface azimut (orientation compared to the south) - S=0°, E=-90°, W=90°, N=180°"    annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Boolean MasqueProche=false
    "True if mask model used upstream, false if not" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Boolean Protection=false
    "True if external mobile protection in place, false if not" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLw=0.5
    "Global light transmission factor of the bay without protection" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLw_dif=0
    "Diffuse light transmission factor of the bay without protection" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLws=0
    "Global light transmission factor of the bay with protection" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLws_dif=0
    "Diffuse light transmission factor of the bay with protection" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
public
  Modelica.Blocks.Interfaces.RealOutput Etp if useEclairement
    "Total incident illumination on the bay (lumen)"
    annotation (Placement(transformation(extent={{-23,-23},{23,23}},
        rotation=270,
        origin={3,-105}),
        iconTransformation(extent={{-13,-13},{13,13}},
        rotation=270,
        origin={1,-109})));

equation
  connect(FluxIncExt, fenetreRad.FluxIncExt) annotation (Line(
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
  connect(T_sky, fenetreRad.T_sky) annotation (Line(
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
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>Double glazing model based on the <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\"><code>Window</code></a> model but with simplified settings including the characterization of glazing properties according to the three following parameters:</p>
<ul>
<li><i>U</i> (thermal conductivity of the glazing)</li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/> (energy transmission of solar energy)</li>
<li><i>g</i> (solar factor)</li>
</ul>
<p><u><b>Hypothesis and equation</b></u></p>
<p>As for the generic glass model:</p>
<ul>
<li>SW (short wavelength) radiations for solar irradiance on the outer face are separated into diffuse and direct. They are obtained by separate calculations after consideration of the glazing tilt and azimuth.</li>
<li>LW (long wavelength) radiations with the external environment can be taken into account by connecting this model to a sky temperature (boolean <code>GLOext=True</code> in advanced parameters) and by specifying the surface tilt.</li>
</ul>
<p>Regarding the rolling shutters, the assumptions are:</p>
<ul>
<li>No solar flux transmitted by the part obscured by the shutters</li>
<li>Absorbed flux unchanged (PVC absorbency similar to that of glass)</li>
<li>If the shutter is not completely closed (Coeff_Fermeture &lt;95&#37;), unchanged thermal resistance</li>
<li>If the shutter is fully closed, increased thermal resistance of an additional thermal resistance, evaluated at 0.2 m&sup2;K / W (PVC thickness of 12 mm approx.)</li>
</ul>
<p>When the window is open, there is \"broke\" of the conductance through the glass, and instead of that a debit of air renewal by natural ventilation is computed (refer to <a href=\"modelica://BuildSysPro.Building.AirFlow.HeatTransfer.WindowNaturalVentilation\"><code>WindowNaturalVentilation</code></a>). </p>
<p>Reduction coefficients of direct and diffuse fluxes may also be considered (if <code>useReduction=True</code>), based on:</p>
<ul>
<li>Type of window / French window (the &#37; of frame is deduced from that)</li>
<li>Coefficient representing the decrease in fluxes through net curtains</li>
<li>Coefficient representing the decrease in fluxes due to window position (inner or outer)</li>
<li>Coefficient representing the decrease in fluxes through curtains</li>
<li>Coefficient representing the decrease in fluxes due to shadows (NB: there is also a model that can calculate precisely the surface fluxes on a vertical wall in case of eaves: <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.SolarMasks.FLUXsurfMask\"><code>FLUXsurfMask</code></a>)</li>
</ul>
<p>In addition, it is assumed that:</p>
<ul>
<li>The glazing coefficient <code>U</code> is given by the manufacturer for <code>heEN673</code> = 25 W / m&sup2;K and <code>hi</code> = 7.7 W / m&sup2;K (standard EN673)</li>
<li>The absorption and transmission coefficients are calculated for <code>heEN410</code> = 23 W/m&sup2;.K et <code>hi</code> = 7,7 W/m&sup2;.K (standard EN673)</li>
<li>Outer glass properties are considered to be identical to inner glass ones (<img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/>, <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau.png\" alt=\"tau\"/> et <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-o2Vygno2.png\" alt=\"rho\"/>)</li>
<li>The glass absorption and reflection coefficients are considered independent of the direction</li>
<li>The coefficients for the diffuse radiation are derived from Cadiergues formulas</li>
<li>The glazing direct transmissivity is calculated based on the angle of incidence according to the French building regulation (RT) formulas</li>
</ul>
<p>The Window model needs to know the surface transmission coefficient <code>k</code> of the glazing and coefficients of transmission and direct and diffuse absorption (<code>TRDIR</code>, <code>TrDif</code>, <code>AbsDir</code> and <code>AbsDif</code>).</p>
<p><i>k</i> is defined directly depending on <code>U</code> according to the standard EN673: <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-FvfBsv4U.png\" alt=\"1/k = 1/U - 1/he - 1/hi\"/> where <code>he</code> = 25 and <code>hi</code> = 7.7 W/m&sup2;.K </p>
<p>Then, knowing that <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-D2vKnZ8U.png\" alt=\"g=tau_0+q_i\"/>, where <code>qi</code> is the factor of thermal retransmission towards the inside of the glazing.</p>
<p>And that <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-8MhqSdry.png\" alt=\"q_i=(2*alpha/he+alpha/k)/(1/he+1/hi+1/k)\"/> where <code>he</code> = 23 and <code>hi</code> =7.7 W/m&sup2;.K (standard EN410). The direct absorption coefficient of the solar energy outside of the glass is considered identical to the one inside.</p>
<p>The glass absorption coefficient <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/> is: <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-nP3B5gfM.png\" alt=\"alpha=q_i*(1/he+1/hi+1/k)/(2/he+1/k)\"/> </p>
<p>Coefficients of absorption and transmission by double glazing (<img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha0.png\" alt=\"alpha_0\"/> et <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/>) of the direct radiation at normal incidence are then determined considering the laws of reflection and transmission in a double glazing with <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/>, <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau.png\" alt=\"tau\"/> and <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-o2Vygno2.png\" alt=\"rho\"/> glass properties</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-m3qW2Cwk.png\" alt=\"tau_0=tau^2/(1-rho^2)\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-STEihD6L.png\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-QsKZWFtl.png\"/></p>
<p>Knowing <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha.png\" alt=\"alpha\"/> and <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/>, <img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-alpha0.png\" alt=\"alpha_0\"/> is deduced after resolution of the above equations system.</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-qPfx1u3Y.png\"/></p>
<p><br>The coefficient of direct radiation is deduced:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-KIFEKL9z.png\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-hWbo2Tq3.png\"/></p>
<p><i>Note: these coefficients are then the ones used in the block <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans\"><code>DirectTrans</code></a> that uses a correlation to determine these coefficients as a function of the angle of incidence. Then the weighting used is the one specified in the RT (French building regulation).</i> </p>
<p>Then Cadiergues relations are used for the diffuse radiation</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-RUGaOnGV.png\"/></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-2SHxA04v.png\"/></p>
<p>Concerning the calculation of natural lighting, global and diffuse light transmission factors that must be filled correspond to <code>TLW</code>, <code>TLw_dif</code>, <code>TLsw</code> and <code>TLsw_dif</code> which are calculated precisely in the EN 410 standard. However, it is possible to find tabulated values in the document <i>Valeurs tabulées des caractéristiques des parois vitrées et des correctifs associés aux baies (Tabulated values of glass walls features and patches associated with windows)</i> from CSTB. Thus, by default:</p>
<ul>
<li>For double glazing without sunscreen: <code>TLW</code> = 0.5, <code>TLW dif</code> = 0</li>
<li>For double glazing with opaque and dark sunscreen on the outside: <code>TLsw</code> = 0, <code>TLsw_dif</code> = 0</li>
<li>For double glazing with non-opaque and clear sunscreen on the outside: <code>TLsw</code> = 0.09, <code>TLsw_dif</code> = 0.03</li>
</ul>
<p><u><b>Bibliography</b></u> </p>
<p>Normes EN410 et EN673</p>
<p>R. Cadiergues, 1978, <i>L'absorption du rayonnement par les vitrages et son calcul</i>. 1-Les vitrages non réfléchissants, Promoclim E, Etudes Thermique et Aérauliques, Tome 9 E, n°1</p>
<p>R. Cadiergues, 1978, <i>Un mode simple de calcul des flux à travers les vitrages</i>. 1-Les vitrages non traités, Promoclim E, Etudes Thermique et Aérauliques, Tome 9 E, n°1</p>
<p>Eclairement naturel : Règles Th-L - Caractérisation du facteur de transmission lumineuse des parois du bâtiment - CSTB Mars 2012, Valeurs tabulées des parois vitrées - CSTB Mars 2012</p>
<p><u><b>Instructions for use</b></u></p>
<p>The thermal ports <code>T_ext</code> and <code>T_int</code> must be connected to temperature nodes (connect <code>T_ext</code> to <code>T_dry</code> of <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Meteofile\"><code>Meteofile</code></a>).</p>
<p>The external incident flows <code>FLUX</code> can come from the <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar\"><code>BoundaryConditions.Solar</code></a> models which are the link between walls and weather readers.</p>
<p>The internal incident flows <code>FluxAbsInt</code> can come from occupants, heating systems but also from the redistribution of solar flux within a room (models from <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\"><code>BoundaryConditions.Radiation</code></a>).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The following precautions should be considered:</p>
<ul>
<li>Internal and external convection coefficients can be different from those used for the standard for thermal calculations</li>
<li><img src=\"modelica://BuildSysPro/Resources/Images/equations/equationsDVitrage/equation-tau0.png\" alt=\"tau_0\"/> should not be confused with the coefficient <code>TL</code> which is light transmission often given by manufacturers</li>
</ul>
<p>For the calculation of illuminance, it is needed to clarify whether there are upstream masks because then the consideration of shadows caused by the architecture is done in the mask model.</p>
<p><u><b>Validations</b></u></p>
<p>Model validated by verifying that the coefficients of absorption and transmission of direct and diffuse radiation as well as the input conductivities of Window model were well consistent with those determined via an Excel sheet based on the formulas of the standards used.</p>
<p>Validated model - Aurélie Kaemmerlen 05/2011 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
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
