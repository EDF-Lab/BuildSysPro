within BuildSysPro.Building.AirFlow.HeatTransfer;
model AirRenewal_DynProp "Air renewal - Variable air properties"

extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

// Control parameters
parameter Boolean use_Qv_in=true "Prescribed volume flow rate"   annotation(Evaluate=true,HideResult=true,Dialog(group="Ventilation/infiltration"),choices(choice=true
        "Prescribed",                                                                       choice=false "Fixed",   radioButtons=true));
parameter Real Qv=0
    "Constant volume flow rate for ventilation and/or infiltrations [m3/h]"                             annotation(Dialog(group="Ventilation/infiltration",enable=not use_Qv_in));

 // Fan power consumption
parameter Boolean use_Pelec=false "Compute power consumption"   annotation(Evaluate=true,HideResult=true,Dialog(group="Electric power consumption"),choices(choice=true "Yes",
                                                                                            choice=false "No",   radioButtons=true));
                                                                                            parameter Real Pelec_spe=0.334
    "Specific power consumption for ventilation [W/m3.h]"
    annotation(Dialog(group="Electric power consumption",enable=use_Pelec));

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

public
  Modelica.Blocks.Tables.CombiTable1Ds proprietes_air(
    tableOnFile=true,
    tableName="data",
    columns=2:8,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=
        "modelica://BuildSysPro/Resources/Donnees/Tables/proprietes_Air.txt")
    annotation (Placement(transformation(extent={{8,-18},{24,-2}})));
protected
  Modelica.Blocks.Sources.RealExpression T_in(y=port_a.T)
    "Inlet air temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-12,-10})));

equation
connect(Qv_in, Qv_in_internal);
  if not use_Qv_in then
    Qv_in_internal= Qv;

  end if;

  Q_flow = proprietes_air.y[1]*proprietes_air.y[3]*(Qv_in_internal/3600)*dT;

  if use_Pelec then
  connect(Qv_in_internal, CalcPelec.u);
  connect(CalcPelec.y, PelecVentil);
  end if;

  connect(T_in.y, proprietes_air.u)
    annotation (Line(points={{-1,-10},{6.4,-10},{6.4,-10}}, color={0,0,127}));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}})),     Icon(coordinateSystem(preserveAspectRatio=false,
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
<p><i><b>Simple air renewal model for a single zone with variable air properties</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Based on <a href=\"modelica//BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal\">AirRenewal</a> model.</p>
<p>Added a table of air properties, so that the calculation takes into account the variations of air thermo-physical properties depending on the temperature.</p>
<p><u><b>Bibliography</b></u></p>
See <a href=\"modelica//BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal\">AirRenewal</a> model.</p>
<p><u><b>Instructions for use</b></u></p>
<p>None</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Naixin Chen 07/2016</b></p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Naixin CHEN, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
</html>"));
end AirRenewal_DynProp;
