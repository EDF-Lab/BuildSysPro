within BuildSysPro.Building.AirFlow.HeatTransfer;
model HeatRecoveryVentilation "Heat recovery ventilation with bypass"

// Control parameters

parameter Boolean use_Qv_in=false "Prescribed volume flow rate"   annotation(Evaluate=true,HideResult=true,Dialog(group="Ventilation/infiltration"),choices(choice=true
        "Prescribed",                                                                       choice=false "Fixed",   radioButtons=true));

parameter Real Qv=0 "Constant volume flow rate for ventilation [m3/h]"                                         annotation(Dialog(group="Ventilation/infiltration",enable=not use_Qv_in));

parameter Boolean use_Efficacite_in=false "Prescribed efficiency" annotation(Evaluate=true,HideResult=true,Dialog(group="Heat recovery"),choices(choice=true "Yes", choice=false
        "No (constant)",                                                                                                    radioButtons=true));
        parameter Real Efficacite=0.5 "Constant efficiency [0-1]"
    annotation(Dialog(group="Heat recovery",enable=not use_Efficacite_in));
 // Fan power consumption
parameter Boolean use_Pelec=false "Compute power consumption"   annotation(Evaluate=true,HideResult=true,Dialog(group="Electric power consumption"),choices(choice=true "Yes",
                                                                                            choice=false "No",   radioButtons=true));
parameter Real Pelec_spe=0.667
    "Specific power consumption for ventilation [W/m3.h]"
    annotation(Dialog(group="Electric power consumption",enable=use_Pelec));

// Air properties
  parameter Modelica.Units.SI.Density rhoair=1.24 "Air density"
    annotation (Dialog(group="Air properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp=1005
    "Air specific heat capacity" annotation (Dialog(group="Air properties"));

  // Components

public
  Modelica.Blocks.Interfaces.RealInput Qv_in if use_Qv_in
    "Prescribed air flow rate[m3/h]"   annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={80,100}),                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,90})));
  Modelica.Blocks.Interfaces.RealInput Efficacite_in if use_Efficacite_in
    "Prescribed efficiency [0-1]"    annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}),                          iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,90})));
  Modelica.Blocks.Interfaces.BooleanInput Bypass
    "True : Bypass /  False : no Bypass" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-80,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,90})));

protected
  BuildSysPro.Systems.HVAC.HeatExchangers.Air2AirSimplifiedHeatEx
    echangeurSimplifie(
    use_Qv_in=true,
    use_Efficacite_in=true,
    rho=rhoair,
    Cp=Cp) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,52})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-72,60},{-52,80}})));
  Modelica.Blocks.Interfaces.RealInput Qv_in_internal
    "Internal connector for optional configuration";
  Modelica.Blocks.Interfaces.RealInput Efficacite_in_internal
    "Internal connector for optional configuration";
  Modelica.Blocks.Math.Gain CalcPelec(k=Pelec_spe) if use_Pelec
    "Conversion du debit (m3/h) en Pelec (W)"
    annotation (Placement(transformation(extent={{46,36},{66,56}})));
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Blocks.Interfaces.RealOutput PelecVentil if use_Pelec
    "Puissance électrique de ventilation (W)"
    annotation (Placement(transformation(extent={{86,26},{126,66}}),
        iconTransformation(extent={{88,40},{108,60}})));

equation
  connect(Qv_in, Qv_in_internal);
  if not use_Qv_in then
    Qv_in_internal= Qv;
  end if;
  connect(echangeurSimplifie.Qv_in, Qv_in_internal);

  connect(Efficacite_in, Efficacite_in_internal);
  if not use_Efficacite_in then
    Efficacite_in_internal= Efficacite;
  end if;
  connect(Efficacite_in_internal, switch1.u3);
  connect(switch1.y, echangeurSimplifie.Efficacite_in) annotation (Line(
      points={{-15,52},{-8,52},{-8,2.8},{-7.4,2.8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(Bypass, switch1.u2) annotation (Line(
      points={{-80,100},{-80,52},{-38,52}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(const1.y, switch1.u1) annotation (Line(
      points={{-51,70},{-48,70},{-48,60},{-38,60}},
      color={0,0,127},
      smooth=Smooth.None));
  if use_Pelec then
  connect(Qv_in_internal, CalcPelec.u);
  connect(CalcPelec.y, PelecVentil);
  end if;

  connect(echangeurSimplifie.port_b, port_b) annotation (Line(
      points={{7,0},{48,0},{48,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(echangeurSimplifie.port_a, port_a) annotation (Line(
      points={{-11,0},{-90,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
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
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><i><b>Heat recovery ventilation with bypass for pure thermal modelling</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The volume flow value can be prescribed or fixed throughout the simulation as well as the exchanger efficiency.</p>
<p> The enthalpy flow is defined based on the energy balance and heat exchanges between 2 air flows.</p>
<p>The main assumptions are:</p>
<ul>
<li>the air temperature is uniform in a zone: well-mixed assumption</li>
<li>the air specific heat capacity is considered constant cp = constant</li>
<li>the air density in a zone is constant: rho = constant</li>
</ul>
<p> In addition the power consumption could be calculated. The default value correspond to 0.667 W/m3.h (insufflation and extraction fan).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The conservation of mass in a thermal zone is imperative and is left to the user's care, otherwise the transfered work (PdV) can not be equal to zero. </p>
<p>By construction, this model can not ensure it. For example, for a thermal zone exchanging air with outdoor environment, two head-to-toe models should be used. </p>
<p>Similarly, this model can not be used alone for a single zone.</p>
<p>For more information refer to the user manual TF101 of CLIM2000.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This model describes the heat transfer corresponding to the air renewal with heat recovery. This component is particularly important during heating periods. It can represent both an air renewal between a room and outside, and an air renewal between two rooms. For large temperature differences, prefer a pressure and temperature model.
<p><u><b>Validations</b></u></p>
<p>Model validated - Gilles Plessis 02/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>
",        revisions="<html>
<p>Benoît Charrier 12/2015 : Ajout du calcul de la puissance électrique liée à la ventilation, activable depuis un booléen. La puissance calculée est accessible pour les deux modes : débit commandé ou non.</p>
</html>"));
end HeatRecoveryVentilation;
