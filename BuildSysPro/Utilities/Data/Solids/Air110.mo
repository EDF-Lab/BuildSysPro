within BuildSysPro.Utilities.Data.Solids;
record Air110 =
      BuildSysPro.Utilities.Records.GenericSolid (
      lambda= 0.61,
      rho=1.218,
      c= 1005)
  "Espace d'air 11 cm non ventilé verticalement (norme ISO 6946 et RT2012)"              annotation (
    Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction du lambda (0,19 > 0,61 W/m.K) pour cohérence avec norme ISO 6946 et RT2012</p>
</html>"));
