within BuildSysPro.Utilities.Data.WallData.RT2012;
record Floor_MTD_UnheatedRoom =
   BuildSysPro.Utilities.Icons.Floor (
    n=1,
    m={4},
    e={0.2},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={0}) "Floor LNC MTD RT2012"            annotation (
    Documentation(info="<html>
<p>RT2012 : Parameters of MTD LNC floors for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
