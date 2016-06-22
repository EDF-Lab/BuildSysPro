within BuildSysPro.BoundaryConditions.Radiation;
model SumDistribRad
  "Redistribution of radiative internal gains with sum of internal gains and solar gains"

extends RadDistrib;

parameter Real AbsP "Short-wave diffuse absorptance of walls"   annotation(Dialog(group="Opaque walls"));
parameter Real AbsF "Short-wave diffuse absorptance of windows" annotation(Dialog(group="Windows"));
parameter Real TrF "Short-wave diffuse transmittance of windows"  annotation(Dialog(group="Windows"));
parameter Real FFp[np]={0.49420,0,0.14610,0.05681,0.10680,0.10680} "Form factor between walls and floor for the calculation of the first reflection/ 
    BESTEST : 1-ceiling, 2-floor, 3-North, 4-South, 5-East, 6-West";
parameter Real FFf[nf]={0.08929}
    "Form factor between windows and floor for the calculation of the first reflection";

  PintRadDistrib ApportsInternes(
    np=np,
    nf=nf,
    Sp=Sp,
    Sf=Sf)
    annotation (Placement(transformation(extent={{-62,20},{-16,66}})));
  FractionSolarDistrib RedistribCLOtr(
    np=np,
    nf=nf,
    Sp=Sp,
    Sf=Sf,
    AbsP=AbsP,
    AbsF=AbsF,
    TrF=TrF,
    FFp=FFp,
    FFf=FFf)
    annotation (Placement(transformation(extent={{-60,-42},{-14,4}})));
  BuildSysPro.Utilities.Math.Addn addn(n=nf)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  BuildSysPro.Utilities.Math.Addn addn1(n=np)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput CLOEntrant
    "Solar irradiation to be redistributed" annotation (Placement(transformation(
          extent={{-120,-10},{-80,30}}), iconTransformation(extent={{-100,-30},
            {-80,-10}})));

Modelica.Blocks.Interfaces.RealInput                            Pint
    "Radiative internal gains" annotation (Placement(transformation(extent={{
            -120,52},{-80,92}}), iconTransformation(extent={{-100,10},{-80,30}})));
equation

  connect(ApportsInternes.FLUXFenetres, addn.u1)
                                                annotation (Line(
      points={{-13.7,47.6},{-1.15,47.6},{-1.15,56},{18,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RedistribCLOtr.FLUXFenetres, addn.u2)       annotation (Line(
      points={{-11.7,-14.4},{0,-14.4},{0,43.95},{18,43.95},{18,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addn.y, FLUXFenetres) annotation (Line(
      points={{41,50},{81,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ApportsInternes.FLUXParois, addn1.u1)
                                               annotation (Line(
      points={{-13.7,38.4},{-13.7,33.35},{38,33.35},{38,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RedistribCLOtr.FLUXParois, addn1.u2)       annotation (Line(
      points={{-11.7,-23.6},{0.85,-23.6},{0.85,-56},{38,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(addn1.y, FLUXParois) annotation (Line(
      points={{61,-50},{81,-50}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(Pint, ApportsInternes.RayEntrant) annotation (Line(
      points={{-100,72},{-88,72},{-88,43},{-59.7,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CLOEntrant, RedistribCLOtr.FluxEntrant) annotation (Line(
      points={{-100,10},{-88,10},{-88,-19},{-57.7,-19}},
      color={255,192,1},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model distributes on surfaces from radiative internal gain and solar heat gain transmitted through glazing.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (BESTEST) - Aurélie Kaemmerlen 09/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 03/2014 : changement du FluxSolInput en RealInput pour éviter les confusions : Pint est plut&ocirc;t un apport interne radiatifs qu'un flux solaire en CLO (déjà pris en compte via CLOEntrant)</p>
</html>"));
end SumDistribRad;
