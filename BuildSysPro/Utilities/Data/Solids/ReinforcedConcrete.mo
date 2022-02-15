within BuildSysPro.Utilities.Data.Solids;
record ReinforcedConcrete = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=2.5,
    rho=2400,
    c=1000) "Reinforced concrete (standard ISO 10456)"
  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
