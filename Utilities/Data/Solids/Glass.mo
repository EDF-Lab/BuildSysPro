within BuildSysPro.Utilities.Data.Solids;
record Glass =  BuildSysPro.Utilities.Records.GenericSolid (
    lambda=1,
    rho=2500,
    c=750) "Verre (norme ISO 10456 et RT2012)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence norme ISO 10456 et RT2012 (rho 2700 > 2500 kg/m3, C 900 > 750 J/kg.K)</p>
</html>"));
