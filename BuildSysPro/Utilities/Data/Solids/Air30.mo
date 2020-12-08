within BuildSysPro.Utilities.Data.Solids;
record Air30 = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.167,
    rho=1.218,
    c=1005) "3cm air gap non ventilated (standard ISO 6946 and RT2012)" annotation (
    Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction du lambda (0,19 > 0,167 W/m.K) pour cohérence avec norme ISO 6946 et RT2012</p>
</html>"));
