within BuildSysPro.Utilities.Data.Solids;
record Air110 =
      BuildSysPro.Utilities.Records.GenericSolid (
      lambda= 0.61,
      rho=1.218,
      c= 1005) "11cm air gap non ventilated (standard ISO 6946 and RT2012)" annotation (
    Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction du lambda (0,19 > 0,61 W/m.K) pour cohérence avec norme ISO 6946 et RT2012</p>
</html>"));
