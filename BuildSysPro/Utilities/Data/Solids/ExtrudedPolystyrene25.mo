within BuildSysPro.Utilities.Data.Solids;
record ExtrudedPolystyrene25 =
    BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.025,
    rho=35,
    c=1450) "Extruded polystyrene 0.025 (HE-12/96/015)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction du C (1210 > 1450 J/kg.K)</p>
</html>"));
