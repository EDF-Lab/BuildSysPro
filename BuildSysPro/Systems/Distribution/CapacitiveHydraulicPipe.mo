within BuildSysPro.Systems.Distribution;
model CapacitiveHydraulicPipe

  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"                             annotation (
      Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (kg/s)"                             annotation (
     Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-10},{100,10}})));

parameter Integer N=5 "number of elements";
  parameter Modelica.Units.SI.Length L=10 "length of pipe [m]";
  parameter Modelica.Units.SI.Diameter D=0.03 "diameter of pipe [m]";
  constant Modelica.Units.SI.Length ep=0.005 "pipe thickness [m]";
  constant Modelica.Units.SI.Density ro_p=7000 "pipe wall density [kg/m3]";
  constant Modelica.Units.SI.SpecificHeatCapacity cp_p=500
    "pipe wall specific heat [J/kg/K]";
  constant Modelica.Units.SI.Density ro_w=1000 "water density [kg/m3]";
  constant Modelica.Units.SI.SpecificHeatCapacity cp_w=4200
    "water specific heat [J/kg/K]";
  Modelica.Units.SI.Temperature[N] T;

equation
  der(T[1])=WaterIn[2]*cp_w/((L*3.14*(D/2-ep)^2*ro_w*cp_w + 3.14*D*ep*L*ro_p*cp_p)/N)*(WaterIn[1]-T[1]);
  for i in 2:N loop
  der(T[i])=WaterIn[2]*cp_w/((L*3.14*(D/2-ep)^2*ro_w*cp_w + 3.14*D*ep*L*ro_p*cp_p)/N)*(T[i-1]-T[i]);
  end for;
  WaterOut[1]=T[N];
  WaterOut[2]=WaterIn[2];

  annotation (Diagram(coordinateSystem(extent={{-100,-60},{100,60}},
          preserveAspectRatio=true),
                      graphics),              Icon(coordinateSystem(extent=
            {{-100,-60},{100,60}}),                graphics={
        Rectangle(
          extent={{-70,10},{72,-10}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          lineThickness=1),
        Ellipse(
          extent={{62,10},{78,-10}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Ellipse(
          extent={{-78,10},{-62,-10}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Text(
          extent={{-20,10},{20,-10}},
          lineColor={255,255,255},
          textString="C")}),
    Documentation(revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>",
      info="<html>
<p><h4>Capacitive pipe (non deparditive) of a hydraulic network</h4></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model is based on an addition of a hydraulic port on the basic model for the need of heated floor study.</p>
<p>The model distributes the water flow according to the mode of operation dictated by the regulation.</p>
<p><u><b>Bibliography</b></u></p>
<p>Based on the model of Nasma SAHBANI, internship report (&quot;Optimisation du système de régulation de la PAC hybride&quot;) </p>
<p><u><b>Instructions for use</b></u></p>
<p>Link <a href=\"modelica://BuildSysPro.Systems.Distribution.DistributionPipe\">DistributionPipe</a>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end CapacitiveHydraulicPipe;
