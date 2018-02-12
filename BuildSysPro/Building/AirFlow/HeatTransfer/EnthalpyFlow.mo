within BuildSysPro.Building.AirFlow.HeatTransfer;
model EnthalpyFlow "Enthalpy flow"

extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

// Control parameters
parameter Boolean use_Qv_in=false "Prescribed volume flow rate"   annotation(Evaluate=true,HideResult=true,Dialog(group="Ventilation/infiltration"),choices(choice=true
        "Prescribed",                                                                       choice=false "Fixed",   radioButtons=true));

parameter Real Qv=0
    "Constant volume flow rate for ventilation and/or infiltrations [m3/h]"                             annotation(Dialog(group="Ventilation/infiltration",enable=not use_Qv_in));

// Propriétés de l'air
parameter Modelica.SIunits.Density rhoair = 1.24 "Air density" annotation(Dialog(group="Air properties"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp=1005
    "Air specific heat capacity"                                                     annotation(Dialog(group="Air properties"));

// Connecteur public
  Modelica.Blocks.Interfaces.RealInput Qv_in if use_Qv_in
    "Prescribed air flow rate[m3/h]"   annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,44}),                           iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,88})));

// Connecteur interne
protected
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Internal connector for optional configuration";

equation
connect(Qv_in, Qv_in_internal);

  if not use_Qv_in then
    Qv_in_internal= Qv;
  end if;

Q_flow = Qv_in_internal/3600*rhoair*Cp*port_a.T;

  annotation (
Documentation(info="<html>
<p><i><b>Enthalpy flow due to air ventilation and infiltration</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model calculates an enthalpy flow between two rooms at different temperatures, assuming that the mass balance is met. Only one enthalpy exchange, oriented from upstream to downstream, is modelled.</p>
<p>The volume flow rate can be prescribed or fixed throughout the simulation.</p>

<p>The enthalpy flux between thermal zone and outside is defined as follows:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-PDJSex77.png\" alt=\"Q_flow=rho*(Q_v/3600)*c_p*T_amont\"/></p>
<p>The main assumptions are:</p>
<ul>
<li>Variations in potential and kinetic energies of the air are neglected <img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-Gefs5rIZ.png\"/> and <img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-SBxQyO58.png\"/></li>
<li>mechanical work exchanged with the solid walls is zero  <img src=\"modelica://BuildSysPro/Resources/Images/equations/Ventilation/equation-KzWFZkpI.png\"/></li>
<li>the air temperature is uniform throughout the room: Tair uniforme</li>
<li>the air specific heat is considered constant and uniform: Cp = constant</li>
<li>the density of an air zone is constant and uniform: rho = constant</li>
</ul>
<p>The model represents a quantity of air in zone A (upstream) at <b>port_a.T</b> temperature and at rho density moving to zone B (downstream). The enthalpy variation is only due to the temperature difference between these areas.</p>
<p><u><b>Bibliography</b></u></p>
<p>CLIM2000 : étude du renouvellement d'air, C. Rogari , Rapport de stage 3ème année ESIP-EDF. Juin1990.</p>
<p>model TF 101 from CLIM2000. 02/2002</p>
<p><u><b>Instructions for use</b></u></p>
<p>The conservation of mass in a thermal zone is imperative and is left to the user's care, otherwise the transfered work (PdV) can not be equal to zero. </p>
<p>By construction, this model can not ensure it. For example, for a thermal zone exchanging air with outdoor environment, two head-to-toe models should be used. </p>
<p>Similarly, this model can not be used alone for a single zone.</p>
<p>For more information refer to the user manual TF101 of CLIM2000.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Use this type of model only for temperature differences lower than 5°C. Beyond, prefer pressure and temperature models, which provide a more accurate modeling.</p>
<p>Caution related to the conservation of mass.</p>
<p><u><b>Validations</b></u></p>
<p>Model validated - Gilles Plessis 02/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 10/2011 : Suppresion du paramètre V volume de la zone d'air amont par rapport au modèle CLIM2000.</p>
<p>Gilles Plessis 02/2012 : Modification du modèle pour permettre un scénario de ventilation fixe ou commandé.</p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),      graphics={
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
    Diagram(graphics));
end EnthalpyFlow;
