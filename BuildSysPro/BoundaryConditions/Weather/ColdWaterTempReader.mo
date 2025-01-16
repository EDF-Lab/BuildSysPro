within BuildSysPro.BoundaryConditions.Weather;
model ColdWaterTempReader "Cold water temperature reader"

  parameter String pth=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Meteos/RT2012/eau_froide_H1a.txt")
    "Path to the meteo file" annotation (Dialog(__Dymola_loadSelector(
          filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",
          caption="Ouverture du fichier météo")));

  BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_cold
    "Cold water temperature [K]" annotation (Placement(transformation(extent=
           {{80,-10},{100,10}}, rotation=0), iconTransformation(extent={{80,-12},
            {100,8}})));
  BaseClasses.HeatTransfer.Sources.PrescribedTemperature prescribedTef
    annotation (Placement(transformation(extent={{40,-10},{60,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinTef
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTimeTable(
    tableOnFile=true,
    tableName="data",
    fileName=pth,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    columns={2}) annotation (Placement(transformation(extent={{-50,-10},{-30,10}},
          rotation=0)));
public
  Modelica.Blocks.Sources.RealExpression Temps(y=mod(time, 31536000))
    annotation (Placement(transformation(extent={{-100,-10},{-68,10}})));
equation
  connect(prescribedTef.port, T_cold) annotation (Line(
      points={{60,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(toKelvinTef.Kelvin, prescribedTef.T) annotation (Line(
      points={{11,0},{40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temps.y, combiTimeTable.u) annotation (Line(
      points={{-66.4,0},{-52,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTimeTable.y[1], toKelvinTef.Celsius) annotation (Line(
      points={{-29,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Text(
          extent={{-48,-18},{58,-46}},
          lineColor={0,0,255},
          textString="%name"),
        Bitmap(extent={{-36,28},{38,-16}}, fileName=
              "modelica://BuildSysPro/Resources/Images/icone_eau_froide.jpg")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows you to read text file indicating the cold water temperature in the pipes.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<h4>Content of file columns</h4>
<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\"><tr>
<td valign=\"top\"><p>  Time (s)</p></td>
<td valign=\"top\"><p>  Cold water temperature (&deg;C)</p></td>
</tr>
</table>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Please note that the cold water temperature is entered in Celsius in the .txt file but is converted to Kelvin as an output</p>
<p>Pay attention to the format of the input file: a csv file must be exported in .txt (tab separator text) and must look the same like the example given in the documentation:</p>
<ul>
<li>no blank line before end of file/ mandatory blank line at the end of file</li>
<li>2 first copy-pasted lines of examples (data type(double), data name(data), comments, ...)</li>
</ul>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 04/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p></html>",
        revisions="<html>
<p>Gilles Plessis 09/2015 : Utilisation de la fonction <code>Modelica.Utilities.Files.loadResource</code> pour le chargement de fichiers, pour une meilleure compatibilité avec le standard Modelica.</p>
</html>"));
end ColdWaterTempReader;
