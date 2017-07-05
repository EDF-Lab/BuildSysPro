within BuildSysPro.Utilities.Data.WallData.RT2005;
record Floor_STD =
   BuildSysPro.Utilities.Icons.Floor (
    n=3,
    m={3,4,1},
    e={0.12,0.2,0.03},
    mat={BuildSysPro.Utilities.Data.Solids.Polyurethane25(),
                                      BuildSysPro.Utilities.Data.Solids.Concrete(),
                                                          BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={1,0,0}) "Floor STD RT2005"            annotation (
    Documentation(info="<html>
<p>RT2005 : Parameters of STD floors for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
