within BuildSysPro.Utilities.Data.Solids;
record PlasterBoard =
      BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.25,
    rho=900,
    c=1000) "Plaster board (standard ISO 10456 and RT2012)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type plaster board de la norme ISO 10456 et RT2012 (lambda 0,35 > 0,25 W/m.K, C 837 > 1000 J/kg.K)</p>
</html>"));
