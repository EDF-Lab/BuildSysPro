within BuildSysPro;
package IBPSA "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;





















annotation (
versionDate="2017-01-17",
dateModified = "2017-01-17",
preferredView="info",
Documentation(info="<html>
<p>
<img
align=\"right\"
alt=\"Logo of IBPSA\"
src=\"modelica://BuildSysPro/Resources/IBPSA/Images/IBPSA-logo-text.png\" border=\"1\"/>
The <code>IBPSA</code> library is a free library
that provides more than 300 classes (models, functions, etc.) for the development of
Modelica libraries for building and community energy and control systems.
The library is compatible with models from the Modelica Standard Library,
in particular with models from
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>
and
<a href=\"modelica://Modelica.Media\">Modelica.Media</a>.
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
The intent of the library is that it will be extended by
implementations of Modelica libraries that are targeted to end-users.
Major goals are
</p>
<ul>
<li>to codify best practice and to provide a solid foundation onto which
other libraries for building and community energy systems can be built, and
</li>
<li>
to avoid a fragmentation of libraries that serve similar purpose but
that cannot share models among each others, thereby duplicating efforts
for model development and validation.
</li>
</ul>
<p>
Hence, this library is typically not used directly by end-users,
but rather by developers of libraries that will be distributed to end-users.
Libraries that are using the <code>IBPSA</code> library as their core, or
that are working on using the <code>IBPSA</code> as their core, include, in
alphabetic order:
</p>
<ul>
<li>
The <code>AixLib</code> library from RWTH Aachen, Germany, available at
<a href=\"https://github.com/RWTH-EBC/AixLib\">https://github.com/RWTH-EBC/AixLib</a>
</li>
<li>
The <code>Buildings</code> library from Lawrence Berkeley National Laboratory, Berkeley, CA, available at
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica/</a>.
</li>
<li>
The <code>BuildingSystems</code> library from
Universit&auml;t der K&uuml;nste Berlin, Germany,
available at
<a href=\"http://www.modelica-buildingsystems.de/\">http://www.modelica-buildingsystems.de/</a>.
</li>
<li>
The <code>IDEAS</code> library from KU Leuven, Belgium, available at
<a href=\"https://github.com/open-ideas/IDEAS\">https://github.com/open-ideas/IDEAS</a>.
</li>
</ul>
<p>
The library also contains more than 300 example and validation models. For Dymola,
each of these example and validation models contains a script that simulates it and
plots certain variables of interest.
</p>
<p>
The web page for this library is
<a href=\"https://github.com/ibpsa/modelica\">https://github.com/ibpsa/modelica</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing and validation,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Bitmap(extent={{-90,-90},{90,90}},
        fileName="modelica://BuildSysPro/Resources/IBPSA/Images/IBPSA-logo.png")}));
end IBPSA;
