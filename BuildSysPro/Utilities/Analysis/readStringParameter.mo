within BuildSysPro.Utilities.Analysis;
function readStringParameter "Read the value of a String parameter from file"
  extends Modelica.Icons.Function;
  input String fileName "Name of file"       annotation(Dialog(
                         loadSelector(filter="Text files (*.txt)",
                         caption="Open file in which Real parameters are present")));
  input String name "Name of parameter";
  output String result "Actual value of parameter on file";

protected
  String line,name2;
  Integer index1,index2;
  Integer iline=1;
  String message = "in file \"" + fileName + "\" on line ";
  String message2;
  Boolean found = false;
  Boolean endOfFile=false;
algorithm
  (line,endOfFile) := Modelica.Utilities.Streams.readLine(fileName, iline);

  while not found and not endOfFile loop
    index1 :=Modelica.Utilities.Strings.find(line, name);
    if index1>0 then
        found:=true;
        index2:=Modelica.Utilities.Strings.find(line, "=");
        result:=Modelica.Utilities.Strings.substring(
        line,
        index2 + 1,
        Modelica.Utilities.Strings.length(line));
    else
      iline:=iline + 1;
      (line,endOfFile) := Modelica.Utilities.Streams.readLine(fileName, iline);
    end if;
  end while;

  if not found then
    Modelica.Utilities.Streams.error("Parameter \"" + name + "\" not found in file \""
       + fileName + "\"");
  end if;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Syntax :</p>
<blockquote><pre>
result = <b>readStringParameter</b>(fileName, name);
</pre></blockquote>
<p>
This function demonstrates how a function can be implemented
that reads the value of a String parameter from file. The function
performs the following actions:
</p>
<ol>
<li> It opens file \"fileName\" and reads the lines of the file.</li>
<li> When the name of the parameter is found, the whole String after \"=\" is returned.</li>
</ol>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>
On file \"test.txt\" the following lines might be present:
</p>
<blockquote><pre>
// Building data

S=100
G=3
V=250
Meteo=trappes.txt
</pre></blockquote>
<p>
The function returns the value \"trappes.txt\" when called as:
</p>
<blockquote><pre>
readRealParameter(\"test.txt\", \"Meteo\")
</pre></blockquote>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>
Be careful, each character after \"=\" will be returned, included space characters at the beginning.
</p>
<p><u><b>Validations</b></u></p>
Model validated - Hassan Bouia 09/2015
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hassan BOUIA, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
end readStringParameter;
