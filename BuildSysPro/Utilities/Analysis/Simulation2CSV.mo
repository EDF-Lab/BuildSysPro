within BuildSysPro.Utilities.Analysis;
function Simulation2CSV
  "Function for simulation and recording of variables in CSV format"

// Import of needed package
  import DataFiles;

// Users parameters
input BuildSysPro.Utilities.Records.SimpleStudySetup setup;

protected
Integer n;
Real[:,:] traj;
Real[:,:] DATA;
String[:] Headers=fill("",size(setup.variables,1));
Boolean successfullSimulation;

// Integration method assignment
String methodIntegration= if setup.simulationOptions.integrationMethod==1 then "Lsodar"  elseif setup.simulationOptions.integrationMethod==3 then "Euler" elseif setup.simulationOptions.integrationMethod==4 then "Rkfix2" elseif setup.simulationOptions.integrationMethod==5 then "Rkfix3" elseif setup.simulationOptions.integrationMethod==6 then "Rkfix4" elseif setup.simulationOptions.integrationMethod==7 then "Radau IIa" elseif setup.simulationOptions.integrationMethod==8 then "Esdirk23a" elseif setup.simulationOptions.integrationMethod==9 then "Esdirk34a" elseif setup.simulationOptions.integrationMethod==10 then "Esdirk45a" elseif setup.simulationOptions.integrationMethod==11 then "Dopri45" elseif setup.simulationOptions.integrationMethod==12 then "Dopri7813" elseif setup.simulationOptions.integrationMethod==13 then "Sdirk34hw" elseif setup.simulationOptions.integrationMethod==14 then "Cerk23" elseif setup.simulationOptions.integrationMethod==15 then "Cerk34" elseif setup.simulationOptions.integrationMethod==16 then "Cerk45" elseif setup.simulationOptions.integrationMethod==17 then "Cvode" else "Dassl";
algorithm
// Workspace cleaning
clearlog();

// Simulation
Modelica.Utilities.Streams.print("Start of the simulation");
experimentSetupOutput(events=setup.simulationOptions.saveEvents,equdistant=true);

successfullSimulation:=simulateExtendedModel(problem=setup.modelName,startTime= setup.simulationOptions.startTime,stopTime=setup.simulationOptions.stopTime, method=methodIntegration, tolerance=setup.simulationOptions.integrationTolerance,fixedstepsize=setup.simulationOptions.fixedStepSize,outputInterval=setup.simulationOptions.outputInterval,initialNames=setup.parameters[:].name, initialValues=setup.parameters[:].Value,finalNames=setup.variables[:].name, resultFile=setup.modelName);
Modelica.Utilities.Streams.print("End of the simulation");

// Analysis
Modelica.Utilities.Streams.print("Start of post treatment");
  // Simulation data recovery
n:=readTrajectorySize(setup.modelName+".mat");
traj:=readTrajectory(setup.modelName+".mat",setup.variables[:].name,n);
DATA:=transpose(traj);

// Headers definition based on variables descriptions and in default variables name
for i in 1:size(setup.variables,1) loop
  if Modelica.Utilities.Strings.isEqual(setup.variables[i].description, "") then
    Headers[i]:=setup.variables[i].name;
    else
    Headers[i]:=setup.variables[i].description;
  end if;
end for;

// Results export per time step
Modelica.Utilities.Streams.print("Results export in the file : "+setup.CSVfile);

if Modelica.Utilities.Files.exist(setup.CSVfile) then
Modelica.Utilities.Streams.print("Previous file "+setup.CSVfile+" has been deleted. A new file will be created.");
end if;
Modelica.Utilities.Files.removeFile(setup.CSVfile);

DataFiles.writeCSVmatrix(fileName=setup.CSVfile,headers=Headers,data=DATA);

Modelica.Utilities.Streams.print("End of the study");
annotation(interactive=true,
    Documentation(info="<html>
<p><i><b>Function for recording variables in CSV format</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function allows you to choose a template, to select parameters to be changed from their default values and then to select the variables to export to a CSV file</p>
<p>It allows the modification of a set of simulation option such as</p>
<ul>
<li>Starting time of the simulation, <i>startTime</i>,</li>
<li>End of the simulation, <i>stopTime</i>,</li>
<li>Events recording or not, <i>saveEvents</i>,</li>
<li>Restitution interval, <i>outputInterval</i>, or number of intervals <i>numberOfIntervals</i>,</li>
<li>Tolerance of the solver used, <i>integrationTolerance</i>,</li>
<li>Integration time step size when the solver used has a fixed time step, <i>fixedStepSize</i>.</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Use the following procedure:</p>
<ol>
<li>Right click on the function then <i>Call Function</i>,</li>
<li>In the tab <i>setup</i>, select the name and location of the CSV file and the name of the model to simulate</li>
<li>In the tab <i>Model parameters</i> select the parameters to be modified from their default value. <b>Warnings, parameters of type String are not changeable by this function,</b></li>
<li>In the tab <i>Model variables</i> select the variables to be registered in the CSV file, the column <i>description</i> is used to set the title to be associated with the CSV file columns. If it is not given, then the variable name is used.</li>
<li>The tab <i>preferences -&gt; simulationOptions</i> allows the modification of simulation parameters (<i>startTime..</i>).</li>
</ol>
<p><br>After the successful parameterization of the function, click on <i>Execute</i> in the bottom right of the dialog window. The simulation is performed and variables are saved in the specified CSV file.</p>
<p><br>This function normally performs a simulation without recording events (<i>saveEvents</i> variable set to <i>false</i> by default), corresponding to the <i>store variables at events</i> box shakeout in the <i>Output</i> tab of the <i>Setup</i> menu (see figure below).</p>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/Simulation2CSV/StoreVariableAtEvents.png\"/></p>
<p><br><u><b>Known limits / Use precautions</b></u></p>
<p>Warnings, parameters of type String are not changeable by this function. It is a limit from Dymola.</p>
<p>It happened that Dymola crashes during the model variables selection. This error appears due to the annotation <i>importDsin</i> that must be incorporated in the record <i>Variables</i> and not at the top level in the record <a href=\"modelica://BuildSysPro.Utilities.Records.SimpleStudySetup\">SimpleStudySetup</a>.</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Gilles Plessis 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 03/2013 : Ajout des fonctions Dymola pour la simulation avec/sans événements et pas de temps equidistant. Suppresion de la possibilité de paramétrer l'étude en nombre de pas de temps.</p>
</html>"));
end Simulation2CSV;
