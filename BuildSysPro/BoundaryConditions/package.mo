within BuildSysPro;
package BoundaryConditions "Package with boundary conditions models"


annotation (Documentation(info="<html>

<p>
The <code>BoundaryConditions</code> package contains several models which offer the possibility of reading and pre-processing boundary conditions from files, such as weather data or normative indoor scenarios.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_structure_boundaryconditions.png\" border=\"1\"/> <br />
</p>

<p>On the outdoor side, the weather data are applied with special treatment for solar data, and on the indoor side a temperature set point or other occupancy schedules are applied.</p>
<p>The weather data reader model requires a file that mainly contains the outdoor dry air temperature, the sky temperature, the relative humidity of the air, the wind data (speed and direction) and two solar radiations amongst diffuse horizontal, global horizontal, direct horizontal and direct normal. Inside the weather data reader model, the different missing fluxes are computed along with the position of the sun. </p>
<p>These weather solar data are then treated by models in the Solar package to obtain the incident direct and diffuse solar flux on the different surfaces, allowing a gain in computation time, especially for multizone modelling. Furthermore and as shown in the <code>Building</code> package, specific yellow interfaces are included in BuildSysPro in order to graphically differentiate the solar boundary conditions in the model diagrams.</p>
<p>The figure below shows an assembly of the weather data reader and a boundary conditions model for shaded windows. The model in the middle computes incident solar radiation on a window under a solar mask from weather data:</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_boundaryconditions_1.png\" border=\"1\"/> <br />
Example of the use of boundary conditions models – Shaded window
</p>

  <p><b>-----------------------------------------------------------------------<br>
  Licensed by EDF under the Modelica License 2<br>
  Copyright &copy; EDF 2009 - 2016<br>
  This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2.<br>
  For license conditions (including the disclaimer of warranty) see <a href=\"modelica://BuildSysPro.UsersGuide.ModelicaLicense2\">BuildSysPro.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\">http://www.modelica.org/licenses/ModelicaLicense2</a>.<br>
  -----------------------------------------------------------------------</b></p>
</html>"));
end BoundaryConditions;
