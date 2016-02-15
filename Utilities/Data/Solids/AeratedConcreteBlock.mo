within BuildSysPro.Utilities.Data.Solids;
record AeratedConcreteBlock =
                   BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.22,
    rho=600,
    c=920) "Béton cellulaire (source Papter)"              annotation (
   Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
