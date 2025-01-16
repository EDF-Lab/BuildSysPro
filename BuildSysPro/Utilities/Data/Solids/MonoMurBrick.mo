within BuildSysPro.Utilities.Data.Solids;
record MonoMurBrick = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.12,
    rho=700,
    c=1000) "MonoMur brick of thickness 30 to 50cm (source material note)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
