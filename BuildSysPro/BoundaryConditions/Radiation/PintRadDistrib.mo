within BuildSysPro.BoundaryConditions.Radiation;
model PintRadDistrib
  "Redistribution of radiative heat flow entering a zone on each wall and window - based on surfaces only"

extends RadDistrib;
Modelica.Blocks.Interfaces.RealInput                            RayEntrant
    "Entering radiative heat flow to be redistributed" annotation (Placement(transformation(
          extent={{-120,-10},{-80,30}}), iconTransformation(extent={{-100,-10},
            {-80,10}})));

Real St "Total surface area of walls and windows";
Real SFp[np]
    "Walls radiative fractions / BESTEST : 1-ceiling, 2-floor, 3-North, 4-South, 5-East, 6-West";
Real SFf[nf]
    "Windows radiative fractions / BESTEST : 1-South OR 1-East, 2-West";

algorithm
St :=sum(Sp)+sum(Sf);
for i in 1:np loop
  SFp[i] := Sp[i]/St;
end for;
for i in 1:nf loop
  SFf[i] := Sf[i]/St;
end for;

equation
for i in 1:np loop
  FLUXParois[i]=RayEntrant*SFp[i];
end for;
for i in 1:nf loop
  FLUXFenetres[i]=RayEntrant*SFf[i];
end for;

  annotation (Icon(graphics), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}),
                                      graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model distributes the radiation proportionally to the surface areas.</p>
<p>Notes: usually used to model the distribution of radiative internal gains. For solar short-wave radiation, consider the surfaces absorptances instead.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (BESTEST) - Aurélie Kaemmerlen 09/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 03/2014 : changement des FluxSolInput et FluxSolOutput en RealInput et RealOutput pour éviter les confusions : ce modèle sert à la redistribution des flux radiatifs tels qu'apports internes</p>
</html>"));
end PintRadDistrib;
