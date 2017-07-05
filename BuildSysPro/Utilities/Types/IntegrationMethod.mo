within BuildSysPro.Utilities.Types;
type IntegrationMethod = enumeration(
    Lsodar "Lsodar",
    Dassl "Dassl",
    Euler "Euler",
    Rkfix2 "Rkfix2",
    Rkfix3 "Rkfix3",
    Rkfix4 "Rkfix4",
    RadauIIa "Radau IIa",
    Esdirk23a "Esdirk23a",
    Esdirk34a "Esdirk34a",
    Esdirk45a "Esdirk45a",
    Dopri45 "Dopri45",
    Dopri7813 "Dopri7813",
    Sdirk34hw "Sdirk34hw",
    Cerk23 "Cerk23",
    Cerk34 "Cerk34",
    Cerk45 "Cerk45",
    Cvode "Cvode") annotation(choicesAllMatching=true,
      Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
