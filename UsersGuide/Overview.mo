within BuildSysPro.UsersGuide;
class Overview "Overview of BuildSysPro Library"
  extends Modelica.Icons.Information;

 annotation (Documentation(info="<html>
<p>
The <code>BuildSysPro</code> library is a free open-source Modelica library for modeling building and energy systems.
</p>
<p>
BuildSysPro provides a set of elementary 0D/1D components to describe envelope components, energy equipments and devices, and control systems. It is mainly based on two branches of physics: pure thermal and thermofluid dynamics modelling. These classes are compliant with the <code>Thermal.HeatTransfer</code> and <code>Media</code> packages of the Modelica standard library to ensure a good level of interoperability with other Modelica libraries. These models are designed for static and dynamic modelling.
</p>
<p>The way of modelling building energy systems with BuildSysPro is similar to the approach commonly used by the building science community. On one hand, the building envelope is mainly considered as an energy consumer and on the other hand, the energy systems and equipments are considered as producers. the figure below shows the top-level structure of BuildSysPro:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_toplevel_structure.png\" border=\"1\"/> <br />
</p>

<ul>
<li>
The <code>User's Guide</code> package provides some basic information about BuildSysPro and license information.
</li>
<li>
The <code>Building</code> package is intended to describe the building envelope and air change, and provides components in a pure thermal or thermo-fluid approach. It also contains generic models of zones which can represent an entire building or a single room. 
</li>
<li>
The <code>Systems</code> package provides models for systems modelling and control, including HVAC, Domestic Hot Water (DHW) and Solar systems. The <code>Controls</code> package provides control and regulation components for HVAC systems or energy equipments. 
</li>
<li>
The <code>BoundaryConditions</code> package contains several models which offer the possibility of reading and pre-processing boundary conditions from files, such as weather data or normative indoor scenarios.
</li>
<li>
The <code>BuildingStock</code> package contains some reference buildings, including the Mozart house, which is a medium size detached house from a typological study of the French housing stock.
</li>
<li>
The <code>Utilities</code> package includes special Modelica types, records, package icons, functions, blocks and models. The records are used to set the parameters of various models in a hierarchical way (wall layers, walls, zones...). A <code>Math</code> sub-package contains, inter alia, some non linear solvers. A <code>Comfort</code> package includes some basic classes to describe human comfort in a room.
</li>
<li>
The <code>BaseClasses</code> package establishes the link with the Modelica standard library. It contains the same connectors as the <code>Modelica.HeatTransfer</code> and <code>Modelica.Media</code> packages. It also includes some other elementary models which are not of interest for end-users.<br />
</li>
</ul>
<p>
The interfaces of BuildSysPro are based on those from the Modelica standard library to ensure the compatibility of modelling. For instance, the connectors of the <code>HeatTransfer</code> class are based on two variables, a temperature as a potential and a heat flow rate as a flow. The upcoming <code>Fluid</code> class is compliant with the <code>Modelica.Media</code> class, that is to say a media model is described with the <code>Modelica.Media.Interfaces</code> and a connector similar to the <code>Media.Examples.Tests.Components.FluidPort</code>, which does not use stream connectors. Stream-compatible Annex 60 library components will be included in a forthcoming version of BuildSysPro.
</p>
<p>
A reference paper detailing BuildSysPro's composition and BESTEST validation is <a href=\"https://modelica.org/events/modelica2014/proceedings/html/submissions/ECP140961161_PlessisKaemmerlenLindsay.pdf\">available on the Modelica Conference website</a>.<br />
</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
end Overview;
