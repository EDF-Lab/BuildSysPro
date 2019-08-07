within BuildSysPro.Utilities.Data.Solids;
record TimberMediumDensity = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.13,
    rho=500,
    c=1600)
  "Timber medium density from softwood (resinous) (standard ISO 10456 and RT2012)"         annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence avec le type bois résineux de la norme ISO 10456 et RT2012 (lambda 0,14 > 0,13 W/m.K, rho 220 > 500 kg/m3, C 2700 > 1600 J/kg.K)</p>
</html>"));
