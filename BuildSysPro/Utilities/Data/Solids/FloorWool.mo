within BuildSysPro.Utilities.Data.Solids;
record FloorWool =
                BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.029,
    rho=35,
    c=1180) "Floor Wool (RE2020)"                  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence norme ISO 10456 et RT2012 (rho 2700 > 2500 kg/m3, C 900 > 750 J/kg.K)</p>
</html>"));
