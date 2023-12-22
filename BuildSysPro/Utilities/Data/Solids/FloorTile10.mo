within BuildSysPro.Utilities.Data.Solids;
record FloorTile10=BuildSysPro.Utilities.Records.GenericSolid (
    lambda=1.300,
      rho=800,
    c=850) "floor tile (RE2020)"                     annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type carreaux de carrelage en céramique de la norme ISO 10456 (rho 800 > 2300 kg/m3, C 850 > 840 J/kg.K)</p>
</html>"));
