within BuildSysPro.Utilities.Data.Solids;
record PVC =  BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.17,
    rho=1390,
    c=1900) "PVC (standard ISO 10456 and RT2012)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type PVC de la norme ISO 10456 et RT2012 (lambda 0,15 > 0,17 W/m.K, rho 1390 > 1380 kg/m3, C 1004 > 1900 J/kg.K)</p>
</html>"));
