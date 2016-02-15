within BuildSysPro.BoundaryConditions.Radiation;
model FractionSolarDistrib
  "Redistribution of short-wave radiation entering a zone on each wall and window - based on absorptance/transmittance coefficients, surfaces and form factors"

extends RadDistrib;
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxEntrant
    "Solar irradiation to be redistributed" annotation (Placement(transformation(
          extent={{-120,-10},{-80,30}}), iconTransformation(extent={{-100,-10},
            {-80,10}})));

parameter Real AbsP "Short-wave diffuse absorptance of walls"  annotation(Dialog(group="Opaque walls"));
parameter Real AbsF "Short-wave diffuse absorption coefficient of windows" annotation(Dialog(group="Windows"));
parameter Real TrF "Short-wave diffuse transmission coefficient of windows" annotation(Dialog(group="Windows"));
parameter Real FFp[np]={0.49420,0,0.14610,0.05681,0.10680,0.10680} "Form factor between walls and floor for the calculation of the first reflection/ 
    BESTEST : 1-ceiling, 2-floor, 3-North, 4-South, 5-East, 6-West";
parameter Real FFf[nf]={0.08929}
    "Form factor between windows and floor for the calculation of the first reflection";

//  Intermediate solar fractions for windows
Real[np] SFp
    "Walls solar fractions / BESTEST : 1-ceiling, 2-floor, 3-Northe, 4-South, 5-East, 6-West";
Real[nf] SFf "Windows solar fractions/ BESTEST : 1-South OR 1-East, 2-West";

algorithm
 when initial() then
    (SFp,SFf) := BESTESTSolarDistrib(
              np=np,
              nf=nf,
              Sp=Sp,
              Sf=Sf,
              FFp=FFp,
              FFf=FFf,
              AbsP=AbsP,
              AbsF=AbsF,
              TrF=TrF);
 end when;

equation
  for i in 1:np loop
  FLUXParois[i]=FluxEntrant*SFp[i];
end for;
for i in 1:nf loop
  FLUXFenetres[i]=FluxEntrant*SFf[i];
end for;

  annotation (Icon(graphics), Documentation(info="<html>


<p><a name=\"result_box\">T</a>his model distributes the radiation received in proportion to the computed solar fractions.</p>
<p>Notes: The computation of solar fractions is done via the method described in the BESTEST procedure</p>
<p>Validated model (BESTEST) - Aurélie Kaemmerlen 09/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>"));
end FractionSolarDistrib;
