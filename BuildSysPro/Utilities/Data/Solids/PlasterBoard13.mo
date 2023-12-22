within BuildSysPro.Utilities.Data.Solids;
record PlasterBoard13=BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.32,
    rho=790,
    c=801) "Plaster board (RE2020)"                        annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type plaster board de la norme ISO 10456 et RT2012 (lambda 0,35 > 0,25 W/m.K, C 837 > 1000 J/kg.K)</p>
</html>"));
