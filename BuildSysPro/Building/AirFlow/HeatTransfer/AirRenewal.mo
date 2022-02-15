within BuildSysPro.Building.AirFlow.HeatTransfer;
model AirRenewal "Air renewal"

extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

// Control parameters
parameter Boolean use_Qv_in=false "Prescribed volume flow rate"   annotation(Evaluate=true,HideResult=true,Dialog(group="Ventilation/infiltration"),choices(choice=true
        "Prescribed",                                                                       choice=false "Fixed",   radioButtons=true));
parameter Real Qv=0
    "Constant volume flow rate for ventilation and/or infiltrations [m3/h]"                             annotation(Dialog(group="Ventilation/infiltration",enable=not use_Qv_in));

 // Fan power consumption
parameter Boolean use_Pelec=false "Compute power consumption"   annotation(Evaluate=true,HideResult=true,Dialog(group="Electric power consumption"),choices(choice=true "Yes",
                                                                                            choice=false "No",   radioButtons=true));
                                                                                            parameter Real Pelec_spe=0.334
    "Specific power consumption for ventilation [W/m3.h]"
    annotation(Dialog(group="Electric power consumption",enable=use_Pelec));

// Air properties
  parameter Modelica.Units.SI.Density rhoair=1.24 "Air density"
    annotation (Dialog(group="Air properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp=1005
    "Air specific heat capacity" annotation (Dialog(group="Air properties"));

// Connecteur public
  Modelica.Blocks.Interfaces.RealInput Qv_in if use_Qv_in
    "Prescribed air flow rate[m3/h]"   annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,44}),                           iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,88})));
  Modelica.Blocks.Interfaces.RealOutput PelecVentil if use_Pelec
    "Electric power consumption [W]"
    annotation (Placement(transformation(extent={{86,26},{126,66}}),
        iconTransformation(extent={{88,40},{108,60}})));

// Connecteur interne
protected
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Internal connector for optional configuration";

  Modelica.Blocks.Math.Gain CalcPelec(k=Pelec_spe) if use_Pelec
    "Conversion [m3/h] to [Welec]"
    annotation (Placement(transformation(extent={{46,36},{66,56}})));

equation
connect(Qv_in, Qv_in_internal);
  if not use_Qv_in then
    Qv_in_internal= Qv;

  end if;

  Q_flow = rhoair*Cp*(Qv_in_internal/3600)*dT;

  if use_Pelec then
  connect(Qv_in_internal, CalcPelec.u);
  connect(CalcPelec.y, PelecVentil);
  end if;

   annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),           Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-110,-98},{112,-136}},
          lineColor={0,0,0},
          textString="%name"),
        Line(
          points={{-80,-10},{0,10},{80,-10}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={0,-70},
          rotation=180),
        Polygon(
          points={{-6,7},{10,-7},{-10,-7},{-6,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-70,-67},
          rotation=180),
        Polygon(
          points={{64,74},{80,60},{60,60},{64,74}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,60},{0,80},{80,60}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-30,0},
          rotation=90),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={0,-30},
          rotation=180),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={30,0},
          rotation=270),
        Polygon(
          points={{-30,30},{30,30},{0,-30},{-30,30}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={0,30},
          rotation=360),
        Ellipse(extent={{-60,60},{60,-60}}, lineColor={0,0,0}),
        Ellipse(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i><b>Simple air renewal model for a single zone</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model calculates an enthalpy flow between a single zone and outside. It assumes that the mass-balance is met.</p>
<p>The value of the volume flow rate can be controlled or fixed throughout the simulation.</p>
<p> The enthalpy flow is defined based on the energy balance:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-6ZmrjEsS.png\" alt=\"Q_flow = rho*(Q_v/3600)*c_p*Delta.T\"/></p>
<p>The main assumptions are:</p>
<ul>
<li>the air temperature is uniform in a zone: well-mixed assumption</li>
<li>the air specific heat capacity is considered constant cp = constant</li>
<li>the air density in a zone is constant: rho = constant</li>
</ul>
<p> In addition the power consumption could be calculated. The default value correspond to 0.334 W/m3.h (extraction fan).</p>
<p><u><b>Bibliography</b></u></p>
<p>Model TF5 from CLIM 2000</p>
<p><u><b>Instructions for use</b></u></p>
<p>This is a none directional model. The <b>port_a</b> can be connected to the thermal port of the <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Meteofile\">Meteofile model</a> and the <b>port_b </b> to the thermal port of a <a href=\"modelica://BuildSysPro.Building.AirFlow.HeatTransfer.AirNode\">Zone model</a> or vice versa. To use the ventilation scenario control <b>use_Qv_in = true</b>), connect a real source to the RealInput named <b>Qv_in</b>.<p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This model describes the heat transfer corresponding to the air renewal (ventilation and infiltration). This component is particularly important during heating periods. It can represent both an air renewal between a room and outside, and an air renewal between two rooms. For large temperature differences, prefer a pressure and temperature model.
<p>Do not considered infiltration when calculating the electric power consumption.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 02/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Ajout du calcul de la puissance électrique liée à la ventilation, activable depuis un booléen. La puissance calculée est accessible pour les deux modes : débit commandé ou non.</p>
</html>"));
end AirRenewal;
