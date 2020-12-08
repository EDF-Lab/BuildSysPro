within BuildSysPro.BoundaryConditions.Radiation;
partial model RadDistrib
  "Partial model for the construction of radiative distribution models"

parameter Integer np=6 "Number of opaque surfaces" annotation(Dialog(group="Opaque surfaces"));
parameter Integer nf=1 "Number of windows" annotation(Dialog(group="Windows"));
parameter Real Sp[np] "Walls surface areas"  annotation(Dialog(group="Opaque surfaces"));
parameter Real Sf[nf] "Windows surface areas"
                                             annotation(Dialog(group="Windows"));

Modelica.Blocks.Interfaces.RealOutput                            FLUXParois[np]
    "Long-wave and/or short-wave radiation transmitted to opaque surfaces / BESTEST : 1-ceiling, 2-floor, 3-North, 4-South, 5-East, 6-West"
    annotation (Placement(transformation(extent={{62,-69},{100,-31}}, rotation=
            0), iconTransformation(extent={{100,-30},{120,-10}})));
Modelica.Blocks.Interfaces.RealOutput                            FLUXFenetres[nf]
    "Long-wave and/or short-wave radiation transmitted to windows/ BESTEST : 1-South OR 1-East, 2-West"
    annotation (Placement(transformation(extent={{62,31},{100,69}}, rotation=0),
        iconTransformation(extent={{100,10},{120,30}})));

  annotation (Icon(graphics={
        Rectangle(
          extent={{-81,18},{32,-34}},
          lineColor={0,0,255},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,18},{-40,34},{72,34},{32,18},{-80,18}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{72,34},{72,-18},{32,-34},{32,18},{72,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-62,-30},{-62,14},{-16,14}},
          color={255,255,0},
          smooth=Smooth.None),
        Line(
          points={{-46,-30},{-62,14},{-26,-8}},
          color={255,255,0},
          smooth=Smooth.None),
        Line(
          points={{-50,12},{-66,-32},{-30,-10}},
          color={255,128,0},
          smooth=Smooth.None),
        Line(
          points={{-66,12},{-66,-32},{-20,-32}},
          color={255,128,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-10,12},{27,-11}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-84,74},{78,44}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This partial model provides as outputs the vectors of heat flows absorbed by the walls and windows according to their number.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (BESTEST) - Aurélie Kaemmerlen 2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 03/2014 : changement des FluxSolOutput en RealOutput pour éviter les confusions : ce modèle sert à la redistribution des flux radiatifs GLO/CLO quels qu'ils soient (apports internes, soleil...)</p>
</html>"));
end RadDistrib;
