within BuildSysPro.Utilities.Data.Solids;
record TimberHighDensity = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.18,
    rho=700,
    c=1600) "Timber high density from hardwood (standard ISO 10456 and RT2012)"                       annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
