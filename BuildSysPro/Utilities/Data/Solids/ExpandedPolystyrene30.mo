within BuildSysPro.Utilities.Data.Solids;
record ExpandedPolystyrene30 =
    BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.030,
    rho=35,
    c=1450) "Expansed polystyrene 0.030 interior insulation" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction du C (1210 > 1450 J/kg.K)</p>
</html>"));
