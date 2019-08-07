within BuildSysPro.Utilities.Data.Solids;
record FibreBoard120 = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.12,
    rho=700,
    c=2000) "Fibre board (lambda = 0.12 W/m².K)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 04/2016 : Correction des valeurs (rho 400 > 700 kg/m3, C 920 > 2000 J/kg.K)</p>
</html>"));
