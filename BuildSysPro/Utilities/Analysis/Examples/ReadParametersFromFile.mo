within BuildSysPro.Utilities.Analysis.Examples;
model ReadParametersFromFile
  "Demonstrate how to read Real and String parameters in a file"
  extends Modelica.Icons.Example;

  parameter String file = Modelica.Utilities.Files.loadResource(
  "modelica://BuildSysPro/Resources/Documentation/Examples_ReadParametersFromFile.txt")
    "File on which data is present"
        annotation(Dialog(loadSelector(filter="Text files (*.txt)",
                      caption="Open text file to read parameters of the form \"name = value\"")));
  parameter Modelica.Units.SI.Area S=
      Modelica.Utilities.Examples.readRealParameter(file, "S") "Surface";
  parameter Modelica.Units.SI.ThermalConductance G=
      Modelica.Utilities.Examples.readRealParameter(file, "G")
    "Conductance of thermal bridges";
  parameter Modelica.Units.SI.Volume V=
      Modelica.Utilities.Examples.readRealParameter(file, "V") "Air volume";
  parameter String Meteo = BuildSysPro.Utilities.Analysis.readStringParameter(file, "Meteo")
    "Name of the meteo file";
  parameter String pth=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Meteos/RT2012/"+Meteo);

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Example that shows the usage of functions <a href=\"modelica://Modelica.Utilities.Examples.readRealParameter\">readRealParameter</a> and <a href=\"modelica://BuildSysPro.Utilities.Analysis.readStringParameter\">readStringParameter</a>.<p>
<p>The example model has 4 parameters of types Real and String, the values of these parameters are read from a file.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Benoit CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p></html>"));
end ReadParametersFromFile;
