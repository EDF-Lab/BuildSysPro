within BuildSysPro.Utilities.Math;
function findValue
  "Return the index of the real val in the vector x, 0 if val is not found"

  input Real[:] x "Input vector";
  input Real val "Value to seek";
  output Integer index "Index of the value in the vector";

algorithm
  index := 1;
  while index < size(x,1)+1 loop
    if x[index]== val then
     break;
    else
      index:=index +1;
    end if;
    end while;

  if index==size(x,1)+1 then
      index:=0;
  end if;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>findValue return the first index of a value in a vector.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Example :</p>
<p>x={1,4,4} and val=4, then findValue(x,val) returns 2</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Gilles Plessis 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end findValue;
