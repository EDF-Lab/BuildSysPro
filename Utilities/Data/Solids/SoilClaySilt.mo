within BuildSysPro.Utilities.Data.Solids;
record SoilClaySilt =  BuildSysPro.Utilities.Records.GenericSolid (
    lambda=1.5,
    rho=1500,
    c=2100) "Terre type argile/glaise (norme ISO 10456)"                                              annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type terre argile/glaise de la norme ISO 10456 (lambda 0,8 > 1,5 W/m.K, C 1320 > 2100 J/kg.K)</p>
</html>"));
