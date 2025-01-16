﻿within ;
package BuildSysPro "EDF's Modelica library for modelling buildings and energy systems"

  annotation (uses(Modelica(version="4.0.0")),
  version="3.6.0",
  versionDate="2023-12",
  conversion(from(version={"3.5.0"},script="Convert_3.5.0_to_3.6.0.mos")),
  Documentation(info="<html>
<p>
The <code>BuildSysPro</code> library is a free open-source Modelica library for modeling building and energy systems.
</p>
<p>This library is designed to be used in several contexts including building physics research, global performance evaluation, technology development and impact assessment. It is also a basis for urban and building stock simulation. <code>BuildSysPro</code> is intended for a relatively large audience ranging from R&D scientists to building services engineers.
</p>
<p>
BuildSysPro contains classes to describe the whole building and its energy systems including envelope components, HVAC systems and other energy conversion devices (DHW, thermal and photovoltaic panels…) and boundary conditions models. These classes are compliant with the <a href=\"modelica://Modelica.Thermal.HeatTransfer\"><code>Modelica.Thermal.HeatTransfer<code></a> and <a href=\"modelica://Modelica.Media\"><code>Modelica.Media<code></a> packages of the Modelica Standard Library to ensure a good level of interoperability with other Modelica libraries. The picture below is an illustration of a building envelope model, and of a whole building+systems model created with <code>BuildSysPro</code>:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_example.png\" border=\"1\"/>
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_assembly.png\" border=\"1\"/> <br />
</p>

<p><b>-----------------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of 3-clause BSD-license.<br>
For license conditions (including the disclaimer of warranty) see <a href=\"modelica://BuildSysPro.UsersGuide.License\">BuildSysPro.UsersGuide.License</a>.<br>
-----------------------------------------------------------------------</b></p>
</html>

",    revisions="<html>
<p>Gilles Plessis 07/2013 : Suppression des annotations &quot;operations&quot; pour export binary... pour BuildSysPro.moe.</p>
</html>"));
end BuildSysPro;
