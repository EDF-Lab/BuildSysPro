within BuildSysPro.UsersGuide;
class Overview "Overview of BuildSysPro Library"
  extends Modelica.Icons.Information;

 annotation (Documentation(info="<html>
<p>
The <code>BuildSysPro</code> library is a free open-source Modelica library for modeling building and energy systems.
</p>
<p>
<code>BuildSysPro</code> provides a set of elementary 0D/1D components to describe envelope components, energy equipments and devices, and control systems. It is mainly based on two branches of physics: pure thermal and thermofluid dynamics modelling. These classes are compliant with the <a href=\"modelica://Modelica.Thermal.HeatTransfer\"><code>Modelica.Thermal.HeatTransfer<code></a> and <a href=\"modelica://Modelica.Media\"><code>Modelica.Media<code></a> packages of the Modelica standard library to ensure a good level of interoperability with other Modelica libraries. These models are designed for static and dynamic modelling.
</p>
<p>The way of modelling building energy systems with <code>BuildSysPro</code> is similar to the approach commonly used by the building science community. An energy simulation is performed by assembling a building envelope, with energy systems, equipments and their controls, and boundary conditions for external and internal conditions. The meteorological conditions are part of the external conditions and occupancy or heating patterns are considered through the internal conditions. The figure below shows the top-level structure of <code>BuildSysPro</code>:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_toplevel_structure.png\" border=\"1\"/> <br />
</p>
BuildSysPro.UsersGuide
<ul>
<li>The <a href=\"modelica://BuildSysPro.UsersGuide\"><code>User's Guide package<code></a> package provides some basic information about <code>BuildSysPro</code> and license information.</li>
<li>The  <a href=\"modelica://BuildSysPro.Building\"><code>Building package<code></a> is intended to describe the building envelope and air change, and provides components in a pure thermal or thermo-fluid approach. It also contains generic models of zones which can represent an entire building or a single room.</li>
<li>The  <a href=\"modelica://BuildSysPro.Systems\"><code>Systems package<code></a> package provides models for systems modelling and control, including HVAC, Domestic Hot Water (DHW) and Solar systems. The <a href=\"modelica://BuildSysPro.Controls\"><code>Controls package<code></a>  package provides control and regulation components for HVAC systems or energy equipments.</li>
<li>The <a href=\"modelica://BuildSysPro.BoundaryConditions\"><code>BoundaryConditions package<code></a> package contains several models which offer the possibility of reading and pre-processing boundary conditions from files, such as weather data or normative indoor scenarios.</li>
<li>The <a href=\"modelica://BuildSysPro.BuildingStock\"><code>BuildingStock package<code></a> package contains some reference buildings, including the Mozart house, which is a medium size detached house from a typological study of the French housing stock.</li>
<li>The <a href=\"modelica://BuildSysPro.Utilities\"><code>Utilities package<code></a> package includes special Modelica types, records, package icons, functions, blocks and models. The records are used to set the parameters of various models in a hierarchical way (wall layers, walls, zones...). A <a href=\"modelica://BuildSysPro.Utilities.Math\"><code>Math sub-package<code></a> contains, inter alia, some non linear solvers. The <a href=\"modelica://BuildSysPro.Utilities.Analysis\"><code>Analysis sub-package<code></a> includes some basic classes for analysis, as for instance to describe human comfort in a room.</li>
<li>The <a href=\"modelica://BuildSysPro.BaseClasses\"><code>BaseClasses package<code></a> package establishes the link with the Modelica standard library. It contains the same connectors as the  <a href=\"modelica://Modelica.Thermal.HeatTransfer\"><code>Modelica.Thermal.HeatTransfer<code></a> and <a href=\"modelica://Modelica.Media\"><code>Modelica.Media<code></a> packages. It also includes some other elementary models which are not of interest for end-users.<br /></li>
</ul>
<p>Modelica.Fluid
The interfaces of BuildSysPro are based on those from the Modelica standard library to ensure the compatibility of modelling. For instance, the connectors of the <a href=\"modelica://Modelica.Thermal.HeatTransfer\"><code>Modelica.Thermal.HeatTransfer<code></a> class are based on two variables, a temperature as a potential and a heat flow rate as a flow. The upcoming <code>Fluid</code> class is compliant with the <a href=\"modelica://Modelica.Media\"><code>Modelica.Media<code></a> class, that is to say a media model is described with the <a href=\"modelica://Modelica.Media.Interfaces\"><code>Modelica.Media.Interfaces<code></a> and a connector similar to the <a href=\"modelica://Modelica.Media.Examples.Tests.Components.FluidPort\"><code>Modelica.Media.Examples.Tests.Components.FluidPort<code></a> , which does not use stream connectors. Stream-compatible Annex 60 library components will be included in a forthcoming version of BuildSysPro.
</p>
<p>A reference paper detailing BuildSysPro and BESTEST validation is available online :</p>
<a href=\"https://modelica.org/events/modelica2014/proceedings/html/submissions/ECP140961161_PlessisKaemmerlenLindsay.pdf\">G. Plessis, A. Kaemmerlen, A. Lindsay, 2014. BuildSysPro: a Modelica library for modelling buildings and energy systems. Proceedings of the Modelica conference 2014, Lund, Sweden, 2014.</a>
</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
end Overview;
