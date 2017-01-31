within BuildSysPro.Utilities.Records;
record SimpleStudySetup
  "Record for the configuration for variables recording according to parameters"
BuildSysPro.Utilities.Types.FileNameOut CSVfile=
      Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Resultats/Results.csv")
    "Name of the result file";
String                                                      modelName annotation (Dialog(__Dymola_translatedModel),experiment(__Dymola_experimentSetupOutput(events=false)));

BuildSysPro.Utilities.Records.Parameters parameters[:]=fill(Parameters(), 0)
    annotation (Dialog(label="Model parameters", importDsin(
        button="Select parameters" "Click here to import the parameters",
        onlyStart=true,
        fields(
          name=initialName,
          Value=initialValue.value,
          min=initialValue.minimum,
          max=initialValue.maximum))));
BuildSysPro.Utilities.Records.Variables variables[:]=fill(Variables(), 0);
//Preferences preferences "Simulation and optimization preferences"
 //   annotation (Dialog(label="Preferences"));
BuildSysPro.Utilities.Records.SimulationOptions simulationOptions
    "Simulation options" annotation (Dialog(label="Simulation options"));
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end SimpleStudySetup;
