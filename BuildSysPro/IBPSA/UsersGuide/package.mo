within BuildSysPro.IBPSA;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;










  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The Modelica <code>IBPSA</code> library is a free open-source library
with classes (models, functions, etc.) that
codify and demonstrate best practices for the implementation of models for
building and community energy and control systems.
</p>
<p>
The development of the IBPSA library is organized through the
<a href=\"https://BuildSysPro.IBPSA.github.io/project1\">IBPSA Project 1</a>
of the International Building Performance Simulation Association (IBPSA).
From 2012 to 2017, the development was organized through the
<a href=\"http://www.iea-annex60.org\">Annex 60 project</a>
of the Energy in Buildings and Communities Programme of the International Energy Agency (IEA EBC).
</p>
<p>
Many models are based on models from the package
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a> and use
the same ports to ensure compatibility with models from that library.
However, a design change is that models from the <code>IBPSA</code>
library do not require the use of
<a href=\"modelica://Modelica.Fluid.System\">Modelica.Fluid.System</a>
as applications in buildings often have multiple fluids with largely varying
flow rates, and therefore a global declaration is impractical.
</p>
<p>
The development page for this library is
<a href=\"https://github.com/ibpsa/modelica\">
https://github.com/ibpsa/modelica</a>.
We welcome contributions from different users to further advance this library,
whether it is through collaborative model development, through model use and testing
or through requirements definition or by providing feedback regarding the model applicability
to solve specific problems.
</p>
<p>
The library has the following <i>User's Guides</i>:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\"><a href=\"modelica://BuildSysPro.IBPSA.Fluid.UsersGuide\">Fluid</a>
   </td>
   <td valign=\"top\">Package for one-dimensional fluid in piping networks with heat exchangers, valves, etc.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://BuildSysPro.IBPSA.Fluid.Actuators.UsersGuide\">Fluid.Actuators</a>
   </td>
   <td valign=\"top\">Package with valves and air dampers.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://BuildSysPro.IBPSA.Fluid.Movers.UsersGuide\">Fluid.Movers</a>
   </td>
   <td valign=\"top\">Package with fans and pumps.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://BuildSysPro.IBPSA.Fluid.Sensors.UsersGuide\">Fluid.Sensors</a>
   </td>
   <td valign=\"top\">Package with sensors.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://BuildSysPro.IBPSA.Fluid.Interfaces.UsersGuide\">Fluid.Interfaces</a>
   </td>
   <td valign=\"top\">Base models that can be used by developers to implement new models.</td>
</tr>
</table>
</html>"));
end UsersGuide;
