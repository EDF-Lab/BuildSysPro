within BuildSysPro;
package Building "Package with building envelope and air flow models"


annotation (Documentation(info="<html>
<p>
The <code>Building</code> package is intended to describe the building envelope and air change, and provides components in a pure thermal or thermo-fluid approach. It also contains generic models of zones which can represent an entire building or a single room. 
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_structure_building.png\" border=\"1\"/> <br />
</p>

<p>
One of the key elements of this package is the thermal wall model. It represents a 1D discrete multi-layer wall with several connectors for boundary conditions. A diagram view of this model can be seen on Figure 1. By convention, the right hand side corresponds to the inside whereas the left hand side can be both, inside or outside boundary conditions.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_building_1.png\" border=\"1\"/> <br />
Figure 1: Diagram of the wall model
</p>

<p align=\"left\">
The blue component in the middle is a <code>HomogeneousNLayersWall</code> model describing the conductive part of the wall. It is based on thermal conductors and capacitors connected in order to represent layers of homogenous material.
The causal connectors represented by yellow triangles are used to convey short wave radiations such as solar irradiance or transmitted solar radiation coming from the windows or the environment. They include either the cosine of the incidence angle, diffuse and direct flux or global flux.<br />
The heat ports connect the model to the surround-ing temperatures. Thanks to optional models and connections, convective heat transfers are considered with an h coefficient either fixed or controlled by wind speed. In the same way, the long wave radiative heat transfer is represented either with a fixed coefficient or with the Stefan–Boltzmann law using dry bulb and sky temperatures. The parameters of the wall model can be easily set thanks to various records. For instance, the parameters of the conductive part use a replaceable <code>WallType</code> record which contains the information described in Figure 2:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_building_2.png\" border=\"1\"/> <br />
Figure 2: <code>WallType</code> record
</p>
<p align=\"left\">
A typical one-zone thermal model would be essentially composed of walls, one air node and air renewal. Figure 3 presents this simple thermal zone using combined convective and radiative heat transfers (in this example, without taking into account the wind speed nor the sky temperature). Thus, depending on the assumptions considered, other types of thermal zones can be designed. For instance, instead of distributing the transmitted solar radiation onto the floor, other weighting methods can be used depending on the solar absorption coefficients and surface areas or view factors, as in the BESTEST calculations.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://BuildSysPro/Resources/Images/UsersGuide/BuildSysPro_building_3.png\" border=\"1\"/> <br />
Figure 3: Diagram of a simple thermal zone
</p>

  <p><b>-----------------------------------------------------------------------<br>
  Licensed by EDF under the Modelica License 2<br>
  Copyright &copy; EDF 2009 - 2016<br>
  This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2.<br>
  For license conditions (including the disclaimer of warranty) see <a href=\"modelica://BuildSysPro.UsersGuide.ModelicaLicense2\">BuildSysPro.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\">http://www.modelica.org/licenses/ModelicaLicense2</a>.<br>
  -----------------------------------------------------------------------</b></p>
</html>"));
end Building;
