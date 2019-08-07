within BuildSysPro.Utilities.Data.Solids;
record WoodParquet = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.120,
    rho=500,
    c=1600) "Wood parquet (softwood - resinous)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs (rho 700 > 500 kg/m3, C 920 > 1600 J/kg.K)</p>
</html>"));
