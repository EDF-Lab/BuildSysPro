within BuildSysPro.Utilities.Data.Solids;
record InsulatingDoor = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.180,
    rho=700,
    c=1950) "Insulating door (PI) (RT>2000)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
