within BuildSysPro.BoundaryConditions.Radiation;
function BESTESTSolarDistrib
  "Computation of solar fractions following the procedure described in BESTEST appendix"

input Integer np "Number of walls";
input Integer nf "Number of windows";
input Real Sp[np] "Walls surface areas";
input Real Sf[nf] "Windows surface areas";
input Real AbsP "Short-wave diffuse absorptance of walls";
input Real AbsF "Short-wave diffuse absorptance of windows";
input Real TrF "Short-wave diffuse transmittance of windows";

input Real FFp[np] "Form factor between walls and floor for the computation of the first reflection /
BESTEST : 1-ceiling, 2-floor, 3-North, 4-South, 5-East, 6-West";

input Real FFf[nf]
    "Form factor between windows and floor for the computation of the first reflection";

// Several outputs: beware of the order!
output Real[np] SFp
    "Solar fractions of walls / BESTEST : 1-ceiling, 2-floor, 3-North, 4-South, 5-East, 6-West";
output Real[nf] SFf
    "Solar fractions of windows/ BESTEST : 1-South OR 1-East, 2-West";

//Intermediate solar fractions for walls
protected
Real B1p[np];
Real B2p[np];
Real B3p[np];
Real BRp[np];

// Intermediate solar fraction for windows
Real[nf] B1f_abs;
Real[nf] B1f_lost;
Real[nf] B2f_abs;
Real[nf] B2f_lost;
Real[nf] B3f_abs;
Real[nf] B3f_lost;
Real[nf] BRf_abs;
Real[nf] BRf_lost;

// Intermediate sums of solar fractions and surfaces
Real B2t;
Real B3t;
Real BRt;
Real St;

algorithm
// calculation of surfaces sum
St :=sum(Sp)+sum(Sf);

// B1 calculation- First reflection of the incident short-wave radiation - Hypothesis = everything hit the floor
for i in 1:np loop
  B1p[i]:= if i<>2 then 0 else AbsP;  //i=2 représente le plancher
end for;
for i in 1:nf loop
  B1f_abs[i]:= 0;
  B1f_lost[i]:= 0;
end for;

// B2 calculation - Second reflection of the incident short-wave radiation - Hypothesis = diffuse redistribution through the floor proportionally to the term : absorptance x form factor
for i in 1:np loop
  B2p[i]:= if i<>2 then (1-AbsP)*AbsP*FFp[i] else 0;
end for;
for i in 1:nf loop
  B2f_lost[i]:= (1-AbsP)*(TrF-AbsF/2)*FFf[i];
  B2f_abs[i]:= (1-AbsP)*(AbsF/2)*FFf[i];
end for;
B2t := sum(B2p)+sum(B2f_abs)+sum(B2f_lost);

// B3 calculation- Third reflection of the incident short-wave radiation - Hypothesis = remaining distribution on each surface proportionally to the term : absorptance x form factor
for i in 1:np loop
  B3p[i]:= (1-AbsP-B2t)*AbsP*Sp[i]/St;
end for;
for i in 1:nf loop
  B3f_lost[i]:= (1-AbsP-B2t)*(TrF-AbsF/2)*Sf[i]/St;
  B3f_abs[i]:= (1-AbsP-B2t)*(AbsF/2)*Sf[i]/St;
end for;
B3t := sum(B3p)+sum(B3f_abs)+sum(B3f_lost);

// BR calculation - Remaining flux distribution proportionally to the third reflection
for i in 1:np loop
  BRp[i]:= (1-AbsP-B2t-B3t)*B3p[i]/B3t;
end for;
for i in 1:nf loop
  BRf_abs[i]:= (1-AbsP-B2t-B3t)*B3f_abs[i]/B3t;
  BRf_lost[i]:= (1-AbsP-B2t-B3t)*B3f_lost[i]/B3t;
end for;

// Form factors (FF) calculation
for i in 1:np loop
  SFp[i]:= B1p[i]+B2p[i]+B3p[i]+BRp[i];
end for;
for i in 1:nf loop
  SFf[i]:= B1f_abs[i] +B2f_abs[i] +B3f_abs[i] +BRf_abs[i];
end for;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing solar fractions (<b>SF</b>) following the methodology described in appendix of the BESTEST procedure.</p>
<p>The computation is based on walls and windows short-wave absorptance and transmittance, on surface areas and form factors between each wall and the floor, on which the first reflection is considered. The approach is as follows:</p>
<ol>
<li>Radiation transmitted by the glazing reaches the floor on which a share is absorbed</li>
<li>The other share is reflected and considered as diffuse. It is distributed on other surfaces proportionally to the term : absorptance x FF with the floor</li>
<li>The remaining non-absorbed radiation is then distributed on all surfaces proportionally to the term : absorptance x surface areas</li>
<li>The rest is distributed in proportion to what has been distributed at the previous step.</li>
</ol>
<p>Note: This model takes into account what is lost through the windows and sent out of the zone./p>
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
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>

</html>"));
end BESTESTSolarDistrib;
