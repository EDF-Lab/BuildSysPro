within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneCrawlSpaceComplete
  "Single zone model of glazed home on crawl space with inner walls inertia, air renewal and thermal bridges"
  extends
    BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazedInternalPartitions;

//Air renewal//
parameter Real TauxRA=0.3 "Air renewal rate in vol/h";
// Thermal bridges
parameter Real Rpth=1/6.423 "Equivalent resistance due to thermal bridges";

  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance thermalResistance(R=Rpth)
    annotation (Placement(transformation(extent={{-126,-92},{-106,-72}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        TauxRA*Vair, use_Qv_in=true) annotation (Placement(transformation(
        extent={{-5,10},{5,-10}},
        rotation=270,
        origin={-172,-91})));
  Modelica.Blocks.Sources.Constant TauxRenouvellementAir(k=TauxRA)
    "Air renewal rate in vol/h" annotation (Placement(
        transformation(extent={{-196,-96},{-186,-86}})));

equation
  connect(T_ext, thermalResistance.port_a) annotation (Line(
      points={{-182,-12},{-160,-12},{-160,-82},{-125,-82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResistance.port_b, T_int) annotation (Line(
      points={{-107,-82},{-6,-82},{-6,-96},{30,-96},{30,-48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, T_int) annotation (Line(
      points={{-172,-95.5},{-42,-95.5},{-42,-96},{30,-96},{30,-48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_a, T_ext) annotation (Line(
      points={{-172,-86.5},{-174,-86.5},{-174,-12},{-182,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauxRenouvellementAir.y, renouvellementAir.Qv_in) annotation (
     Line(
      points={{-185.5,-91},{-180.8,-91}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><b>Model of parallelepiped glazed zone on crawl space, in pure thermal modelling and integrating the internal inertia due to the inner walls, the thermal bridges and the air renewal.</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Parallelepiped single-zone building on crawl space with glazing model, to be connected to a boundary conditions model (left thermal port) and a left realOutput for solar fluxes. By default walls are oriented in the four cardinal points; the orientation modification is represented by the parameter beta. The right thermal port is connected to the inner volume (heat capacity). Floor and ceiling are subject to outside temperatures which are weighted by a coefficient b.</p>
<p>This model inherits from <a href=\"modelica://BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazedInternalPartitions\"><code>ZoneCrawlSpaceGlazedInternalPartitions</code></a> and superimposes on it the thermal bridges and the air renewal.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>This single zone building model is to be connected to a weather boundary conditions model on the left (outside temperature, sunlight-related data). The right thermal port is connected to the inner volume (heat capacity) and can, if desired, be connected to any model using a thermal port (internal heat gains...).</p>
<p>The walls parameterization is done via the parameter caracParoi, however it still can be done layer by layer without creating any type of wall.</p>
<ol>
<li>Click on the small arrow of caracParoi + Edit</li>
<li>Fill in the fields on the number of layers, their thickness, the mesh. The parameter positionIsolant is optional</li>
<li>For the mat parameter, click on the small arrow + Edit array, match the number of boxes in a column to the number of materials layer in the window that is displayed, then, in each box, right-click + Insert function call and browse the library to specify the path of the desired material (in <a href=\"modelica://BuildSysPro.Utilities.Data.Solids\"><code>Utilities.Data.Solids</code></a>)</li>
</ol>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>To consider walls radiation in long wavelength (LWR), exchange coefficients h must be <b>global exchange coefficients</b>. The inertia of the inner walls is integrated.<p>
<p>Glazings transmit solar fluxes to the floor.</p>
<p><u><b>Validations</b></u></p>
<p>Valided model - Vincent Magnaudeix 07/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Vincent MAGNAUDEIX, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"),                                                                    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,
            -100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {100,100}}), graphics));
end ZoneCrawlSpaceComplete;
