within BuildSysPro.Utilities.Data.Solids;
record PolystyreneSlab = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.066,
    rho=700,
    c=900) "Polystyrene slab (thickness = 14 cm) (source Ca-Sis)"
                                                         annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
