within BuildSysPro.BuildingStock.RnCm;
model R3C2 "Simplified R3C2 electric model of a building"
  parameter Real Cres = 1/9.2178e-07 "Capacity of air" annotation(Dialog(group="Modèle R3C2"));
  parameter Real Cs =   1/7.1675e-08 "Capacity of heavy walls" annotation(Dialog(group="Modèle R3C2"));
  parameter Real Rf =   1/19.979 "Resistance Rf" annotation(Dialog(group="Modèle R3C2"));
  parameter Real Ri =   1/400.38 "Resistance Ri" annotation(Dialog(group="Modèle R3C2"));
  parameter Real Ro =   1/81.191 "Resistance Rf" annotation(Dialog(group="Modèle R3C2"));
  parameter Real S=1 "Surface of South equivalent glazing" annotation(Dialog(group="Vitrage Sud équivalent"));
  parameter Real TrDir=0.747 "Direct transmission coefficient of the glazing" annotation(Dialog(group="Vitrage Sud équivalent"));
  parameter Real TrDif=0.665 "Diffuse transmission coefficient of the glazing" annotation(Dialog(group="Vitrage Sud équivalent"));

  BuildSysPro.BaseClasses.HeatTransfer.Components.HeatCapacitor Tint(C=Cres)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,2})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HeatCapacitor Ts(C=Cs)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,2})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow AI
    annotation (Placement(transformation(extent={{-80,-48},{-60,-28}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow Qch
    annotation (Placement(transformation(extent={{-80,-68},{-60,-48}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance res_Rsi(R=Ri)
    annotation (Placement(transformation(extent={{0,-18},{20,2}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance res_Rf(R=Rf)
    annotation (Placement(transformation(extent={{0,22},{20,42}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance res_Ro(R=Ro)
    annotation (Placement(transformation(extent={{60,-18},{80,2}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow Qs
    annotation (Placement(transformation(extent={{12,-88},{32,-68}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_Text
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput P_AI "Internal gains" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-141,40},{-101,80}})));
  Modelica.Blocks.Interfaces.RealInput P_Qch "Power (heating/cooling)"
    annotation (Placement(transformation(extent={{-140,-52},{-100,-12}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput G[10]
    "G meteofile vector {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur}"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_Tint
    annotation (Placement(transformation(extent={{-6,-74},{14,-54}}),
        iconTransformation(extent={{-10,-90},{10,-70}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf(azimut=0,
      incl=90)
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));

protected
  Real cosi=fLUXsurf.FLUX[3],TransDir;

equation
  TransDir =  if noEvent(cosi>0) then (if noEvent(cosi>0.8) then TrDir else TrDir*2.5*cosi*(1-0.625*cosi)) else 0;  // Cardonnel
  Qs.Q_flow = S*(TrDif*fLUXsurf.FLUX[1]+TransDir*fLUXsurf.FLUX[2]);

  connect(AI.port, Tint.port) annotation (Line(points={{-59,-39.4},{-29,
          -39.4},{-29,-7}},
                     color={191,0,0}));
  connect(Qch.port, Tint.port) annotation (Line(points={{-59,-59.4},{-29,
          -59.4},{-29,-7}},
                      color={191,0,0}));
  connect(res_Rsi.port_b, Ts.port)
    annotation (Line(points={{19,-8},{41,-8},{41,-7}},    color={191,0,0}));
  connect(res_Rsi.port_a, Tint.port)
    annotation (Line(points={{1,-8},{-29,-8},{-29,-7}},    color={191,0,0}));
  connect(res_Ro.port_a, Ts.port)
    annotation (Line(points={{61,-8},{41,-8},{41,-7}},    color={191,0,0}));
  connect(res_Rf.port_b, res_Ro.port_b) annotation (Line(points={{19,32},{
          86,32},{86,-8},{79,-8}},
                              color={191,0,0}));
  connect(Qs.port, Ts.port) annotation (Line(points={{33,-79.4},{41,-79.4},
          {41,-7}},
                 color={191,0,0}));
  connect(res_Ro.port_b, port_Text)
    annotation (Line(points={{79,-8},{110,-8},{110,0}}, color={191,0,0}));
  connect(P_Qch, Qch.Q_flow) annotation (Line(points={{-120,-32},{-94,-32},{-94,
          -59.4},{-79,-59.4}}, color={0,0,127}));
  connect(P_AI, AI.Q_flow) annotation (Line(points={{-120,0},{-90,0},{-90,-39.4},
          {-79,-39.4}}, color={0,0,127}));
  connect(res_Rf.port_a, Tint.port) annotation (Line(points={{1,32},{-20,32},
          {-40,32},{-40,-7},{-29,-7}},
                                    color={191,0,0}));
  connect(Tint.port, port_Tint) annotation (Line(points={{-29,-7},{-29,
          -28.5},{4,-28.5},{4,-64}}, color={191,0,0}));
  connect(G, fLUXsurf.G) annotation (Line(points={{-120,-60},{-98,-60},{-98,-80},
          {-91,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder),
        Bitmap(extent={{-122,-70},{122,40}}, fileName="modelica://BuildSysPro/Resources/Images/RnCm/R3C2_1.png"),
        Text(
          extent={{-60,86},{60,46}},
          lineColor={28,108,200},
          textString="R3C2")}), Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Bitmap(extent={{-148,42},{46,98}}, fileName="modelica://BuildSysPro/Resources/Images/RnCm/R3C2_1.png")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Here is the electric diagram of the simplified R3C2 building model :</p>
<p><img src=\"modelica://BuildSysPro/Resources//Images/RnCm/R3C2_2.png\"/></p>
<ul><li>Ri, Ro, Cs represent the building envelope</li>
<ul><li>Cs : higher capacity of the system (envelope)</li>
<li>Ri, Ro : resistances of heavy walls on inner and outer sides</li></ul>
<li>Rf : equivalent resistance of 3 resistances in parallel</li>
<ul><li>Rra : air renewal losses</li>
<li>Rp : out of air renewal losses</li>
<li>Rie : resistance of light walls</li></ul>
<li>Qs : solar flux</li>
<li>Qres : power (heating + internal gains)</li></ul>
<p>Inputs/outputs of the global closed loop system, with parameters of the PI controller (gain K and integration constant Tau) :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/RnCm/R3C2_3.png\"/></p>
<p>Identification of the variables and default values :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/RnCm/R3C2_4.png\"/></p>
<p>Comparison measurement / calculation :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/RnCm/R3C2_5.png\"/></p>
<p><u><b>Bibliography</b></u></p>
<p>This simplified R3C2 building model is part of the thesis of Chadia Zayane (EMP, 2001), entitled :</p>
<p><i><a href=\"modelica://BuildSysPro/Resources/Documentation/These Chadia ZAYANE (R3C2).pdf\">Identification d'un modèle de comportement thermique de bâtiment à partir de sa courbe de charge</a></i></p>
<p><u><b>Instructions for use</b></u></p>
<p>Take care to parameter your PID controller with the default values of the table above :
<ul><li>Gain K = 87.787</li>
<li>Time constant Tau =1 / 0.0030396</li></ul></p>
<p>Glazings of the building are represented apart from the R3C2 model by a South equivalent glazed surface with these parameters :
<ul><li>S : surface of the South equivalent glazing</li>
<li>Trdir, Trdif : transmission coefficient of the glazing</li></ul></p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 01/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hassan BOUIA, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end R3C2;
