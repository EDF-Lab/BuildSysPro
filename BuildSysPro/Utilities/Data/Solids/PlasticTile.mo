within BuildSysPro.Utilities.Data.Solids;
record PlasticTile =     BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.2,
    rho=1000,
    c=1000) "Plastic tile (standard ISO 10456)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type dalles thermoplastiques de la norme ISO 10456 (lambda 0,4 > 0,2 W/m.K, rho 1400 > 1000 kg/m3)</p>
</html>"));
