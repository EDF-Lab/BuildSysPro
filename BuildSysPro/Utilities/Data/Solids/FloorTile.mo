within BuildSysPro.Utilities.Data.Solids;
record FloorTile =
      BuildSysPro.Utilities.Records.GenericSolid (
    lambda=1.300,
    rho=2300,
    c=840) "Carreau de carrelage en céramique (norme ISO 10456)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type carreaux de carrelage en céramique de la norme ISO 10456 (rho 800 > 2300 kg/m3, C 850 > 840 J/kg.K)</p>
</html>"));
