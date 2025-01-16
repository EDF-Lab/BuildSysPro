within BuildSysPro.BoundaryConditions.Weather;
model Meteofile "Weather data reader"

parameter Integer TypeMeteo=3 annotation(choices(
choice=1 "Meteofrance",
choice=2 "Meteonorm",
choice=3 "Weather RT (french building regulation)",
choice=4 "User-defined weather file", radioButtons=true));

parameter Boolean Tempciel=true "Sky temperature in data file"                                          annotation(choices(
choice=true "Provided", choice=false "To be calculated"));

parameter Boolean HR=true "Relative humidity in data file" annotation(choices(
   choice=true "Provided in data file", choice=false "HR unknown"),
                      Dialog(enable=Tempciel==false));

  parameter String pth=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Meteos/RT2012/H1a.txt")
    "Path to the weather data file"
  annotation(Dialog(__Dymola_loadSelector(filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",
                             caption="Selecting the weather file")));

  parameter BuildSysPro.Utilities.Records.MeteoData DonneesPerso
    "Variables provided for User-defined data"
    annotation (Dialog(enable=TypeMeteo == 4));

parameter Modelica.Blocks.Types.Smoothness Interpolation=Modelica.Blocks.Types.Smoothness.ContinuousDerivative
    "Data interpolation method" annotation(Dialog(tab="Advanced parameters"));                           // we recommand to use  linearSegments option

  parameter Modelica.Units.SI.Time Tbouclage=31536000
    "Weather data looped beyond Tbouclage if the simulation stop time is superior"
    annotation (Dialog(tab="Advanced parameters"));

parameter Real delta_t=3600
    "Time interval for piecewise constant interpolation method"
    annotation (Dialog(tab="Advanced parameters"));

parameter Integer table_column_number=11
    "Number of column in data file (time not considered)"                                               annotation (Dialog(tab="Advanced parameters"));
parameter Integer option[:]=fill(1, table_column_number)
    "Integer = 0 for a column if it is necessary to apply a step function on it, >0 otherwise."
    annotation (Dialog(tab="Advanced parameters"));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_dry "Dry air temperature" annotation (
      Placement(transformation(extent={{80,48},{100,68}}, rotation=0),
        iconTransformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Interfaces.RealOutput G[10]
    "Output data {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle , Solar elevation angle}"
    annotation (Placement(transformation(extent={{82,-52},{118,-16}},
          rotation=0), iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={90,-20})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedTemperature prescribedTseche
    annotation (Placement(transformation(extent={{26,48},{46,68}}, rotation=0)));
  BuildSysPro.BoundaryConditions.Weather.CombiTable1Ds_ForStepMeteo
    combiTimeTable(
    tableOnFile=true,
    tableName="data",
    columns={2,3,4,5,6,7,8,9,10,11,12},
    smoothness=Interpolation,
    delta_t=delta_t,
    option=option,
    fileName=pth)  annotation (Placement(transformation(extent={{-58,20},{-38,
            40}}, rotation=0)));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedTemperature prescribedTrosee
    annotation (Placement(transformation(extent={{26,18},{46,38}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_dew
    "Dew point temperature" annotation (Placement(transformation(extent={{80,18},
            {100,38}}, rotation=0), iconTransformation(extent={{80,50},{100,70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_sky
    "Sky temperature" annotation (Placement(transformation(extent={{80,-14},
            {100,6}}, rotation=0), iconTransformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Interfaces.RealOutput V[2]
    "Wind speed (m/s) and  direction (from 0° - North, 90° - East, 180° - South, 270 ° - West)"
    annotation (Placement(transformation(extent={{82,-82},{118,-46}},
          rotation=0), iconTransformation(extent={{80,-60},{100,-40}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinTseche
    annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvinTrosee
    annotation (Placement(transformation(extent={{-8,18},{12,38}})));
  Modelica.Blocks.Interfaces.RealOutput Hygro[3]
    "T [K], total pressure [Pa], relative humidity [0;1]"
    annotation (Placement(transformation(extent={{82,-110},{118,-74}},
          rotation=0), iconTransformation(extent={{80,-90},{100,-70}})));
protected
parameter Boolean ChoixEst=if TypeMeteo==4 then DonneesPerso.Est else true;
  Real ps;
  Real DIFH;
  Real DIRN;
  Real DIRH;
  Real GLOH;
  Real T_ciel;
  Real t0;
  Real CosDir[3];
  Real h0;
  Real d0;
  Real CoupleFlux;
  Real FluxMeteo[2];
  Real latitude;
  Real longitude;
  Real AzHaut[2];

public
  Modelica.Blocks.Sources.RealExpression Temps(y=mod(time, Tbouclage))
    annotation (Placement(transformation(extent={{-100,20},{-68,40}})));
  Modelica.Blocks.Tables.CombiTable1Ds   combiTimeTable1(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    columns={10},
    fileName=pth)    annotation (Placement(transformation(extent={{-58,-10},{
            -38,10}},      rotation=0)));
equation
  // Irradiance reading, latitude and longitude
  // The longitude must be given in such a way that East>0 and West<0 with absolute values <180 °

  when initial() then
    latitude=combiTimeTable.y[10];
    longitude =
      BuildSysPro.BoundaryConditions.Weather.Functions.ConvertLongitude(Est=
      ChoixEst, LongIn=combiTimeTable.y[11]);
    h0 = if (TypeMeteo==4) then DonneesPerso.h0 else (if (TypeMeteo==1) then 0 else -1);
    d0 = if TypeMeteo==4 then DonneesPerso.d0 else 1;
    CoupleFlux= if TypeMeteo==4 then DonneesPerso.CoupleFlux else 2;
    t0=86400*(d0-1)+3600*h0;
  end when;

  //combiTimeTable.u=mod(time,31536000);

  FluxMeteo[1]=combiTimeTable.y[1];
  FluxMeteo[2]=combiTimeTable.y[2];

// Wind connector
 connect(combiTimeTable.y[8], V[1]) annotation (Line(
      points={{-37,30},{-30,30},{-30,-68.5},{100,-68.5}},
      color={0,0,127},
      smooth=Smooth.None));

// Temperature Connectors
  connect(prescribedTseche.port, T_dry) annotation (Line(
      points={{46,58},{90,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTrosee.port, T_dew) annotation (Line(
      points={{46,28},{90,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(combiTimeTable.y[3], toKelvinTseche.Celsius)
                                                 annotation (Line(
      points={{-37,30},{-26,30},{-26,58},{-12,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTimeTable.y[4], toKelvinTrosee.Celsius)
                                                  annotation (Line(
      points={{-37,30},{-34,30},{-34,28},{-10,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvinTseche.Kelvin, prescribedTseche.T)
                                                    annotation (Line(
      points={{11,58},{26,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvinTrosee.Kelvin, prescribedTrosee.T)  annotation (Line(
      points={{13,28},{26,28}},
      color={0,0,127},
      smooth=Smooth.None));

  // Connector for humid air

  ps = BuildSysPro.BoundaryConditions.Weather.Functions.CalculPs(Hygro[1]);

  Hygro[1]=combiTimeTable.y[3]+273.15;
  Hygro[2]=combiTimeTable.y[6];
  Hygro[3]=combiTimeTable.y[7];

  // Tciel computation

  if Tempciel==false then
    if HR==true then
      T_ciel=Functions.CalculTsky_withRH(
        t=time,
        G=G,
        T_seche=T_dry.T,
        Pvap=Hygro[3]*ps);
    else
      T_ciel=Functions.CalculTsky_withoutRH(
        t=time,
        G=G,
        T_seche=T_dry.T);
    end if;
  else
    T_ciel=combiTimeTable.y[5]+273.15;
  end if;

  T_sky.T=T_ciel;

  //Calculation of sun's direction cosines

  (CosDir,AzHaut[1],AzHaut[2]) =
    BuildSysPro.BoundaryConditions.Solar.Utilities.CosDirSunVectorHeightAz(
    t0=t0,
    t=time,
    latitude=latitude,
    longitude=longitude);

  // Calculation of flux DIFH, DIRN, DIRH, GLOH

  if CoupleFlux<1.5 then
    GLOH = FluxMeteo[1];
    DIFH = FluxMeteo[2];
    DIRH=GLOH-DIFH;
    DIRN=if noEvent(CosDir[1]>0.01) then min(0.7^(1/CosDir[1])*1367.,DIRH/CosDir[1]) else 0;
  elseif CoupleFlux<2.5 then
    DIRN = FluxMeteo[1];
    DIFH = FluxMeteo[2];
    DIRH=if CosDir[1]>0 then DIRN*CosDir[1] else 0;
    GLOH=DIRH+DIFH;
  elseif CoupleFlux<3.5 then
    DIFH = FluxMeteo[1];
    DIRH = FluxMeteo[2];
    GLOH=DIRH+DIFH;
    DIRN=if noEvent(CosDir[1]>0.01) then min(0.7^(1/CosDir[1])*1367.,DIRH/CosDir[1]) else 0;
  elseif CoupleFlux<4.5 then
    GLOH = FluxMeteo[1];
    DIRH = FluxMeteo[2];
    DIRN=if noEvent(CosDir[1]>0.01) then min(0.7^(1/CosDir[1])*1367.,DIRH/CosDir[1]) else 0;
    DIFH=GLOH-DIRH;
  else // CoupleFlux==5
    GLOH = FluxMeteo[1];
    DIRN = FluxMeteo[2];
    DIRH=if CosDir[1]>0 then DIRN*CosDir[1] else 0;
    DIFH=GLOH-DIRH;
  end if;

  //G[1:10]={DIFH,DIRN,DIRH,GLOH, t0, CosDir[1],CosDir[2],CosDir[3], latitude, longitude};
  G[1:10]={DIFH,DIRN,DIRH,GLOH, t0, CosDir[1],CosDir[2],CosDir[3], AzHaut[1],AzHaut[2]};

  if option[9]==0 then
    connect(combiTimeTable.y[9],V[2]);
  else
    connect(combiTimeTable1.y[1],V[2]);
  end if;
  connect(Temps.y, combiTimeTable.u) annotation (Line(
      points={{-66.4,30},{-60,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temps.y, combiTimeTable1.u) annotation (Line(
      points={{-66.4,30},{-64,30},{-64,0},{-60,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Ellipse(
          extent={{-48,50},{2,16}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-50,62},{-36,46}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-30,66},{-24,46}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-62,46},{-46,38}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-60,24},{-44,30}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Polygon(
          points={{-52,0},{-30,38},{14,36},{48,28},{60,0},{-52,0}},
          lineColor={85,170,255},
          lineThickness=1,
          smooth=Smooth.Bezier,
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,64},{-16,44}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{8,52},{-10,42}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Text(
          extent={{-56,-16},{50,-44}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><i><b>Weather data reader providing meteorological boundary conditions</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model reads weather data files. The files are contained in the directory <u>file://BuildSysPro\\Resources\\Donnees\\Meteos</u>.</p>
<p>The data format must be compliant with specifications described below (see table).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model reads a data file containing the following columns:</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Time [s] </p></td>
<td><p>Solar irradiance 1 [W/m&sup2;]</p><p>Direct normal (defaut)</p></td>
<td><p>Solar irradiance 2 [W/m&sup2;]</p><p>Diffuse horizontal (defaut)</p></td>
<td><p>T_dry [&deg;C]</p><p>Dry bulb temperature </p></td>
<td><p>T_dew [&deg;C]</p><p>Dew point temperature</p></td>
<td><p>T_sky [&deg;C]</p><p>Sky temperature</p></td>
<td><p>Patm [Pa]</p><p>Atmospheric pressure</p></td>
<td><p>HR (between 0 and 1)</p><p>Relative humidity</p></td>
<td><p>VitVent [m/s]</p><p>Wind speed</p></td>
<td><p>DirVent [&deg;]</p><p>Wind direction</p></td>
<td><p>Latitude [&deg;]</p></td>
<td><p>Longitude [&deg;]</p></td>
</tr>
</table></p>
<p>By default weather file can be given either in universal time (UTC - h0 = 0) or in local time (TL - h0 = Time zone). The scenarios should be consistent with the time given in the weather file - there is no change to summer time.</p>
<p>The weather data are repeated periodically. By default, a one year period is used (see advanced parameter <b>Tbouclage</b>). So that one can start simulations on heating season: for example, from October 1 (start time 23587200s) to May 1 (stop time 41904000s). The advanced parameter <b>Tbouclage</b> allows to loop from a longer period so that a data file larger than a year can be used.</p>
<p><b>Default settings - link to the content of the folder <u>file://BuildSysPro\\Resources\\Donnees\\Meteos</b></u> </p>
<ol>
<li>Irradiation data are DIRN and DIFH</li>
<li>The beginning of the files is at 0:00 on January 1</li>
<li>The longitude is given in &deg; East (positive at East, negative at West)</li>
<li>The pressure (in Pa) is an absolute pressure, and is assumed to be a wet air total pressure (used as such in humidity calculation functions)</li>
<li>The relative humidity is between 0 and 1</li>
<li>For the wind direction, the World Weather Organization assumes that a wind coming from the north is coded 360&deg;, the wind rose is graduated clockwise (an east wind will be coded 90&deg;) - check in all weather files -</li>
</ol>
<h4>Available files and their differences from default values are:</h4>
<ol>
<li><b>Meteofrance</b>: Solar fluxes averaged over [t-dt/2;t+dt/2]. Data in Universel Time (UTC).</li>
<li><b>Meteonorm</b>: Solar fluxes measured over the last hour and assigned to the middle of the hour to better match the sun's path. Data in legal time UTC+1 in France, during winter time.</li>
<li><b>RT Weather Files</b>: Solar fluxes measured over the last hour and assigned to the middle of the hour to better match the sun's path. Data in legal time UTC+1 in France, during winter time.</p>
<li><b>Personal Weather Files</b> (user-defined weather data): It is recommended to assign solar fluxes in the same way, i.e., to the middle of the hourly time step (not necessary if the time step is small).</p>
<p>For <strong>personal weather data</strong>, the following guidelines apply:</p><ul><li><strong>Time column in the weather file</strong> (first column): By convention, 0 should correspond to 00:00:00 on the first day of the measured data: if the data, for example, starts at 3:00 PM (with no data before 3:00 PM), fill all values up to 54,000s (3:00 PM) with 0, and start the simulation from 3:00 PM. Thus, the value 1800 in the time column corresponds to 00:30 AM on the first day of the weather data.</li></ul>
<p>There are 3 time systems:</p><ol>
<li><strong>Universal Time (UTC)</strong>, given by the Greenwich Meridian (GMT),</li>
<li><strong>Legal Time (LT)</strong>, the country’s local time,</li><li><strong>True Solar Time (TST)</strong>, given by a sundial.</li>
</ol><p>It is important to know the time system used for measuring experimental data.</p>
<p>The time system must be consistent between the weather data and scenarios (for example, all in universal time or all in legal time, but not a mix of both). In the absence of an automated conversion tool, it is recommended to use the local legal time for the location in question to avoid having to adjust the scenarios.</p>
<p><strong>Legal Time (LT)</strong> takes into account the country's time zone (Fh) (e.g., +1 in France and -8 in Los Angeles), possibly corrected by a daylight-saving correction term (=1). Without correction (=0), the time defaults to winter time. The formula for converting legal time from universal time is:<br><strong>LT = UTC + (Fh + correction)</strong></p><p><strong>True Solar Time (TST)</strong> involves the Equation of Time (ET) (a function of the day of the year) and the location's longitude, expressed in decimal degrees (counted &gt;0 east of GMT and &lt;0 west). The formula for converting true solar time from universal time is:<br><strong>TST = UTC - ET + (longitude/15)</strong></p>
<p>Sunrise and sunset times are calculated based on true solar time. For example, on July 1st:</p>
<ul><li>Sunrise in Brest: 6:19 AM</li><li>Sunrise in Strasbourg: 5:29 AM</li><li>Sunset in Brest: 10:24 PM</li><li>Sunset in Strasbourg: 9:36 PM</li></ul>
<p>To ensure the coherence of solar flux results for the given location, check that the solar fluxes (G[1] to G[4]) are within the time interval when the sun's elevation (G[10]) is &gt;0.<br>If necessary, verify sunrise and sunset times at <a rel=\"noopener\" target=\"_new\" href=\"https://calendriersolaire.com\"><span>https</span><span>://calendriersolaire</span><span>.com</span></a> and adjust the time zone, correction term, and longitude accordingly.</p>
<p><strong>Example setup for personal weather data</strong>:<br>If data starts on May 11 at 3:30 PM in legal time in Los Angeles (longitude -118°15'), select UTC-8, correction = 0 (winter time), and d0 (day of the year) = 131 for a non-leap year.</p><p><strong>Note</strong>:</p>
<ul><li>The model does not handle the transition from winter time to daylight saving time (last Sunday in March) or vice versa (last Sunday in October). The correction term must be properly set before starting the simulation.</li>
<li>To correctly visualize weather data in Dymola, the restitution time step must be a divisor of the first time step in the weather file. For example, if the data starts at 1800s, use a restitution time step of 1800s (instead of 3600s). The result variables will be correctly calculated regardless (no impact on the restitution time step).</li></ul>
<p>This model returns as outputs: </p>
<ul>
<li><ul>
<li><b>G[10]</b> vector containing information for solar irradiance computation:</li>
<li><ul>
<li>(1) Horizontal diffuse flux </li>
<li>(2) Normal direct flux </li>
<li>(3) Horizontal direct flux </li>
<li>(4) Horizontal global flux </li>
<li>(5) Time in UTC at time t = 0 (start of the simulation) </li>
<li>(6-7-8) Sun&apos;s direction cosines (6-sinH, 7-cosW, 8-cosS) </li>
<li>(9) Solar azimuth angle </li>
<li>(10) Solar elevation angle</li>
</ul></li>
<li><b>V[2]</b> vector containing information about wind</li>
<li><ol>
<li>Wind speed</li>
<li>Wind direction (origin)</li>
</ol></li>
<li><b>Hygro[3]</b> for hygro-thermal modelling</li>
<li><ol>
<li>Dry air temperature [K]</li>
<li>Total pressure supposed to be wet (=Patm) [Pa]</li>
<li>Relative humidity [0;1] </li>
</ol></li>
</ol></li>
</ol>
<li><strong>Advanced Parameters</strong>: we recommend to change the default interpolation method to <span style=\"font-family: Courier New;\">Smoothness.Linear.Segments</span> instead of <span style=\"font-family: Courier New;\">Smoothness.ContinuousDerivative</span> (continuous derivative looks nicer but could result in negative solar fluxes).</li>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The irradiation couple read by the weather reader is set via the choice of CoupleFlux. By default, the model reads the couple FDIRN / FDIFH</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aur&eacute;lie Kaemmerlen 2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Aur&eacute;lie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p></html>",
    revisions="<html>
<p>Aur&eacute;lie Kaemmerlen 02/2011 : Inversion of components 1 and 2 of the <b>G</b> vector to maintain the same order of solar fluxes between the input weather file and the <b>G</b>  vector output from the Weather Reader – No impact on file format, but models using the modified <b>G</b> vector are affected accordingly. </p>
<p>Aur&eacute;lie Kaemmerlen 05/2011 : The <b>G</b> vector has been extended with 3 additional parameters: MoyFlux, dt, and CoupleFlux, enabling greater reusability of this Weather Reader.</p>
<p>Gilles Plessis 02/2012: Modification of the pth parameter type (<i>String</i> changed to <i>Filename</i>) allowing the use of a window to access the data file.</p>
<p>Aur&eacute;lie Kaemmerlen 03/2012 : Change of the default value of Est (=false for Meteonorm which is the default file)</p>
<p>Aur&eacute;lie Kaemmerlen 06/2012 :</p>
<ul>
<li>Deactivation of the dt parameter entry when the average is a standard average.</li>
<li>Added documentation to clarify the model's usage.</li>
<li>Automation of weather file selection based on the data available by default in the documentation (default is personal weather).</li>
<li>Addition of the Hygro port enabling connection to aerodynamics models.</li>
<li>Modification of the table interpolation type: instead of linear interpolation, the data is interpolated in such a way that their derivative remains continuous.</li>
</ul>
<p>Hassan Bouia 03/2013 : Simplification of solar calculations and modification of the G vector.</p>
<p>Denis Covalet 04/2013 : Clarification on the Hygro vector, pressure variable, and correction of HR information (between 0 and 1, not in %).</p>
<p>Aur&eacute;lie Kaemmerlen 09/2013 : Added options for choosing the weather data interpolation type, loop time for the weather file, and modulo for wind direction which was out of bounds [0-360] with continuous interpolation.</p>
<p>Amy Lindsay 01/2014 : Removed the modulo on wind direction that caused resolution problems in some cases (data continuity issues), and enforced linear interpolation for wind direction to resolve this.</p>
<p>Amy Lindsay 03/2014 : Added two booleans to:<ol><li>Specify if the sky temperature is already provided in the weather text file or if it needs to be calculated.</li><li>If it needs to be calculated, specify whether the relative humidity is known or not (the correlation estimating the sky temperature depends on the available input data).</li></ol></p>
<p>Amy Lindsay 04/2014 : Added documentation to remind the importance of angle conventions, which differ for wind direction and wall orientation!</p>
<p>Amy Lindsay 11/2014 : <b>Major change for Meteonorm and regulatory weather files</b>: to better match the position of the sun at each moment, the hourly-averaged fluxes are assigned to the middle of the time step (half-hour). </p>
<p>Hassan Bouia, Amy Lindsay 12/2014 : Added the option to use step functions.</p>
<p>Gilles Plessis 09/2015 : Used the <span style=\"font-family: Courier New;\">Modelica.Utilities.Files.loadResource</span> function for file loading, improving compatibility with the Modelica standard.</p>
<p>Beno&icirc;t Charrier 01/2016 : Added the advanced parameter <code>table_column_number</code> to avoid cross-declaration of variables and ensure compatibility with OpenModelica.</p>
<p>Beno&icirc;t Charrier 01/2017 : Replaced vapor pressure with relative humidity as the third component of the <span style=\"font-family: Courier New;\">Hygro</span> vector to align with the input requirements of the <span style=\"font-family: Courier New;\">WithoutWindEffect</span> and <span style=\"font-family: Courier New;\">WithWindEffect</span> boundary condition models.</p>
<p>Beno&icirc;t Charrier 01/2018 : Added <span style=\"font-family: Courier New;\">noEvent</span> on some <span style=\"font-family: Courier New;\">CosDir[1]&gt;0</span> conditions to avoid division by zero errors. Changed <span style=\"font-family: Courier New;\">h0</span> value from <span style=\"font-family: Courier New;\">0</span> to <span style=\"font-family: Courier New;\">-1</span> in case of RT2012 meteo to fit with sun height.</p>
<p>Denis Covalet 10/2024 :</p>
<ul>
<li><strong>Personal Weather</strong>: Replaced the h0 parameter (weather hour offset for solar fluxes, a source of confusion) with time zone (Fh) and winter (0)/summer (1) correction, knowing that h0 = -(Fh + correction).</li>
<li><strong>Personal Weather</strong>: By default, longitude is now counted positively to the east and negatively to the west (Est = true). It was the opposite before (Est = false by default).</li>
<li>Added clarifications to the model documentation, particularly for personal weather data.</li>
</ul>
</html>"));
end Meteofile;
