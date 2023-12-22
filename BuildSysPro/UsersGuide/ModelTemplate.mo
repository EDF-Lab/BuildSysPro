within BuildSysPro.UsersGuide;
partial model ModelTemplate
  "Model template with recommendations in terms of documentation and code-writing"

//----------------------------------------------------------------------------------------------------------------------------------------------//
//----- Declarative section - please comment each variable and parameter -----//
// Do not write any equation in this section for variables. Otherwise, the variable will be considered as a parameter (constant).

// Declaration of model parameters using associated units and range of variation if necessary
parameter Real alpha( min=0, max=1)
    "Alpha coefficient - range of variation between 0 and 1";
  parameter Modelica.Units.SI.Length L=2 "Length";
  parameter BuildSysPro.Utilities.Types.FileNameIn Data=
      Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Meteos/RT2012/H1a.txt")
    "Path of weather data file";
    parameter Boolean Bool "Parameter showing radio buttons" annotation(Dialog(tab="Advanced",group="Radio buttons",compact=true),choices(choice=true "true", choice=false "false",
                radioButtons=true));
                parameter Integer Choice "Parameter showing a drop-down menu" annotation(Dialog(tab="Advanced",group="Drop-down menu"),choices(choice=1
        "Choice 1",                                                                                                    choice=2
        "Choice 2",choice=3 "Choice 3"));
  parameter BuildSysPro.Utilities.Records.GenericWall Wall
    "Choice between wall data records" annotation (Dialog(tab="Advanced", group=
         "Drop-down menu"), choicesAllMatching=true);

// Declaration of variables
  Modelica.Units.SI.Length D "Distance";

// Used models

// Variables or parameters visible only in the model
protected
  parameter Real beta=alpha*100 "Alpha in the form of a percentage...";
Real gamma "Intermediate variable not visible by default in the results";

//----------------------------------------------------------------------------------------------------------------------------------------------//
//----- Section of algorithms &amp; equations -----//

//-- Algorithms - for classic or sequential calculations, not taking part of the equational system of the model to be resolved --//
// Be careful, an algorithm should not be considered as an equation, contrary to equations there is no memory to save the results at the last time steps for algorithms
algorithm
  D:=beta*L; // For instance...

//-- Equations and connections between models --//
// The equations form the matrix system solved by the solver - Number of equation = Number of unknowns
equation
gamma = if Bool then D else 0;

  annotation (
    Icon(graphics={
        Text(
          extent={{-76,124},{62,96}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,6},{72,0}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Icon illustrating the model features")}),
    Diagram(graphics={Text(
          extent={{-70,6},{68,0}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Assembly of submodels constituting the model")}),
    Documentation(info="<html>
<p><i><b>Complete the description of the model using <u>Info Editor</u> or <u>Info Source</u> views and fill in the next sections</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/example.bmp\"/></p>
<p><i><span style=\"color: #0000ff;\">If the image does not appear while you are using a relative path, make sure that your work directory (File/Change Directory) is the one containing BuildSysPro and the Resources folder</span></i></p> You can also use hyperlink to another model : <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">HYPERLINK to the WALL model</a></p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (or not) - First name LAST NAME month/year <b>(MANDATORY)</b></p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : First name LAST NAME, company (year of creation of the code)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p><i><b>Complete the thread of the changes made in the model using <u>Revision Editor</u> or<u> Revision Source</u> views</b></i></p>
<p>First name LAST NAME month/year : Description of the changes made in the model</p>
</html>"));
end ModelTemplate;
