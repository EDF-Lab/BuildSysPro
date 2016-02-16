within BuildSysPro.Utilities.Data.Solids;
record MonoMurBrick =
                   BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.12,
    rho=700,
    c=1000) "Brique MonoMur épaisseur 30 à 50cm (source fiche matériau)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
