within BuildSysPro.Utilities.Data.Solids;
record SoilSandGravel = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=2.0,
    rho=2000,
    c=1050) "Soil of type sand/gravel (standard ISO 10456)"                                              annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type terre argile/glaise de la norme ISO 10456 (lambda 0,8 > 1,5 W/m.K, C 1320 > 2100 J/kg.K)</p>
</html>"));
