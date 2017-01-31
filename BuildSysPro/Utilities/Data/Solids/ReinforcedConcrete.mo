within BuildSysPro.Utilities.Data.Solids;
record ReinforcedConcrete =
                   BuildSysPro.Utilities.Records.GenericSolid (
    lambda=2.5,
    rho=2400,
    c=1000) "Reinforced concrete (standard ISO 10456)"
  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
