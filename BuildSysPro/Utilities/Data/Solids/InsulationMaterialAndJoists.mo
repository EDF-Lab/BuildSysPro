within BuildSysPro.Utilities.Data.Solids;
record InsulationMaterialAndJoists =
    BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.050,
    rho=100,
    c=980) "Insulation material + joists (lambda = 0.050)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
