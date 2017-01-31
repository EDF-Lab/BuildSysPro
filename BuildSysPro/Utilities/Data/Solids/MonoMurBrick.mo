within BuildSysPro.Utilities.Data.Solids;
record MonoMurBrick =
                   BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.12,
    rho=700,
    c=1000) "MonoMur brick of thickness 30 to 50cm (source material note)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
