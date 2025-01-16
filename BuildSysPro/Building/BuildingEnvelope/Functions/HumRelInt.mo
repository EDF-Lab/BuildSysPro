within BuildSysPro.Building.BuildingEnvelope.Functions;
function HumRelInt "Hrint = f(Patm,Text, Hr_ext, T_int)"
  input Real Patm=1e5 "Ambient pressure in Pa";
  input Real Text=293.15 "Upstream temperature in K";
  input Real Hr_ext=0.5 "Relative humidity between 0 and 1";
  input Real Tint=293.15 "Upstream temperature in K";

  output Real Hr_int "Internal relative humidity between 0 and 1 at constant water content";
  //package Medium = Modelica.Media.Air.MoistAir "Used medium package";

protected
  Real Xse, Xsi;
algorithm
  Xse:=Modelica.Media.Air.MoistAir.massFraction_pTphi(p=Patm, T = Text, phi = Hr_ext);

  Xsi := Xse;  // Water vapor conservation
 // Hr_int :=Hr_ext;
   Hr_int :=Modelica.Media.Air.MoistAir.relativeHumidity_pTX(
     p=Patm,
     T=Tint,
     X={Xsi, 1-Xsi});

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Internal relative humidity between 0 and 1 at constant water content.</p>
<p><u><b>Bibliography</b></u></p>
<p>none.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia, 07/2024</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author :Hassan Bouia, Kods GRISSA NACIB EDF (2024)<br>
--------------------------------------------------------------</b></p>
</html>"));
end HumRelInt;
