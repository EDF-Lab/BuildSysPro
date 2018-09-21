within BuildSysPro.Systems.Controls;
model PIDPrescribedSingleMode
  "Calculation of heating or air conditioning needs (PID with temperature scenario)"

parameter Boolean saisieTableau=false
    "= false if the setpoint temperature is connected to a RealInput , = true if the setpoint temperature is defined in a table"
    annotation(Dialog(group="Setpoint entry mode"));
parameter Boolean tableauSurFichier=false
    "= true, if the setpoint temperatures are indicated in a text file"
    annotation(Dialog(group="Setpoint temperature scenario",enable=saisieTableau));
parameter Real tableau[:, :] = [0, 292.15]
    "Table to define here if it's not done in a text file (first column = time in seconds, second column = setpoint temperature in Kelvin) - by default set to 19°C"
       annotation(Dialog(group="Setpoint temperature scenario", enable = not tableauSurFichier and saisieTableau));
parameter String nomTableau="data"
    "Name of the table specified in the text file"
       annotation(Dialog(group="Setpoint temperature scenario", enable = tableauSurFichier and saisieTableau));
parameter String nomFichier=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ConsigneChauffageRT2012_Kelvin.txt")
    "Location of the text file containing the setpoint temperatures table"
       annotation(Dialog(group="Setpoint temperature scenario", enable = tableauSurFichier and saisieTableau,
                         __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Open the file containing the setpoint temperatures scenario")));
parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Type of data interpolation in the table"
  annotation(Dialog(group="Setpoint temperature scenario",enable=saisieTableau));
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Setpoint temperature extrapolation outside the domain of definition of the table"
  annotation(Dialog(group="Setpoint temperature scenario",enable=saisieTableau));

parameter Real PuissanceNom=1000
    "Power of heating or cooling system (always positive)";
parameter Integer chaud_froid=0 "0 - heating, 1 - cooling"
    annotation (Dialog(
      compact=true), choices(
      choice=0 "Heating",
      choice=1 "Cooling",
      radioButtons=true));
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10000,
    Ni=0.1,
    initType=Modelica.Blocks.Types.InitPID.SteadyState,
    Td=0.,
    yMin= if chaud_froid==0 then 0. else -PuissanceNom,
    limitsAtInit=true,
    yMax= if chaud_froid==0 then PuissanceNom else 0,
    Ti=1)
    annotation (Placement(transformation(extent={{44,-10},{24,-30}})));
  BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{0,-38},{-20,-18}})));
  BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_room annotation (Placement(
        transformation(extent={{-100,-100},{-80,-80}}),
                                                 iconTransformation(extent={{-100,
            -100},{-80,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable1(
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableOnFile=tableauSurFichier,
    table=tableau,
    tableName=nomTableau,
    fileName=nomFichier,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) if
                            saisieTableau
                      annotation (Placement(transformation(extent={{36.8,-92.5},
            {56.8,-72.5}})));
  Modelica.Blocks.Continuous.Integrator integrator annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={11,-65})));
  Modelica.Blocks.Math.Gain gain(k=1/(1000*3600))
                                           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={12,-46})));
  Modelica.Blocks.Interfaces.RealOutput Pth "Thermal power demand"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-6,-58}),  iconTransformation(extent={{80,10},{100,30}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput kWh_th "Thermal kWh cumulated"
                                           annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=-90,
        origin={12,-93}), iconTransformation(extent={{80,-31},{100,-9}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput T_sp if  not saisieTableau
    "Setpoint temperature [K]" annotation (Placement(transformation(
        extent={{20,20},{-20,-20}},
        rotation=-90,
        origin={84,-94}), iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-80,0})));
equation
  connect(PID.y,prescribedHeatFlow. Q_flow) annotation (Line(
      points={{23,-20},{10,-20},{10,-28},{0,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T,PID. u_m) annotation (Line(
      points={{60,0},{60,4},{34,4},{34,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.port,T_room)  annotation (Line(
      points={{80,0},{98,0},{98,-90},{-90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gain.y,integrator. u) annotation (Line(
      points={{12,-52.6},{11,-52.6},{11,-59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y,kWh_th)  annotation (Line(
      points={{11,-70.5},{11,-93},{12,-93}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port,T_room)  annotation (Line(
      points={{-20,-28},{-68,-28},{-68,-90},{-90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID.y, gain.u) annotation (Line(
      points={{23,-20},{12,-20},{12,-38.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, Pth) annotation (Line(
      points={{23,-20},{10,-20},{10,-36},{-6,-36},{-6,-58}},
      color={0,0,127},
      smooth=Smooth.None));
 if saisieTableau then
   connect(combiTimeTable1.y[1],PID.u_s);
 else
    connect(T_sp, PID.u_s);
 end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                         graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-18,-98},{22,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,40},{14,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{14,0},{60,0}},  color={0,0,255}),
        Line(points={{-88,0},{-10,0}}, color={0,0,255}),
        Polygon(
          points={{-10,40},{-10,80},{-8,86},{-4,88},{2,90},{8,88},{12,86},{14,
              80},{14,40},{-10,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-10,40},{-10,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{14,40},{14,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-38,-20},{-10,-20}}, color={0,0,0}),
        Line(points={{-38,20},{-10,20}}, color={0,0,0}),
        Line(points={{-38,60},{-10,60}}, color={0,0,0}),
        Text(
          extent={{128,-20},{28,-120}},
          lineColor={0,0,0},
          textString="°K"),
        Text(
          extent={{-52,184},{70,62}},
          lineColor={0,0,255},
          textString="Heating or cooling"),
        Line(points={{60,20},{80,20}},color={0,0,255}),
        Line(points={{60,-20},{80,-20}},
                                      color={0,0,255}),
        Line(points={{60,-20},{60,20}},
                                      color={0,0,255})}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model assumes a PID control for intake of calories (heating) or frigories (cooling). The temperature setpoints are stored in a scenario text file.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The text file or the setpoint temperatures table should contain in the first column the time in seconds, and in the second column the setpoint temperature in Kelvin.</p>
<p>An example of a setpoint temperature scenario is available : <a href=\"modelica://BuildSysPro/Resources/Donnees/Scenarios/ConsigneChauffageRT2012_Kelvin.txt\">ConsigneChauffageRT2012_Kelvin.txt</a>.</p>
<p>Two use cases :</p>
<ul><li>Ideal operation: the nominal power must be largely oversized to calculate cooling or heating <u>needs</u>, otherwise there is no guarantee that the installed power is sufficient to reach temperature setpoints.</li>
<li>Real operation: the nominal power is the sizing power, which shows whether the dimensioning can meet the targeted setpoint temperatures.</li></ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p><b>Warnings !</b> Setpoint temperatures in the text file, in the table or connected to the port T_sp depending on the cases, must be in Kelvin.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 10/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Modification en 10/2013 par A.Lindsay : les consignes de température ne doivent plus être renseignées en degrés Celsius mais en degrés Kelvin !!! Ajout de la possibilité de calculer les besoins de froid et non pas que les besoins de chaud</p>
<p>04/2014 A.  Lindsay : modification du gain avant intégration pour bien obtenir des kWh !</p>
</html>"));
end PIDPrescribedSingleMode;
