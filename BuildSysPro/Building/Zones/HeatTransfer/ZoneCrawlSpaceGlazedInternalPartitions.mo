within BuildSysPro.Building.Zones.HeatTransfer;
model ZoneCrawlSpaceGlazedInternalPartitions
  "Model of parallelepiped zone on crawl space with glazings, in pure thermal modelling, and integrating the internal inertia due to the inner walls"
  extends ZoneCrawlSpaceGlazed;

//Inter-zones and intra-zones partition walls//
//Supporting walls
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracRef
    "Supporting walls characteristics" annotation (choicesAllMatching=
        true, Dialog(tab="Inner walls", group="Supporting walls"));

  parameter Modelica.Units.SI.Area SRef=1 "Supporting walls surfaces"
    annotation (Dialog(tab="Inner walls", group="Supporting walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hRef
    "Supporting walls convective heat transfer coefficient"
    annotation (Dialog(tab="Inner walls", group="Supporting walls"));

//Light partition walls
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracCleg
    "Light partition walls characteristics" annotation (
      choicesAllMatching=true, Dialog(tab="Inner walls", group=
          "Light partition walls"));
  parameter Modelica.Units.SI.Area SCleg=1 "Light partition walls surface"
    annotation (Dialog(tab="Inner walls", group="Light partition walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hCleg
    "Global exchange coefficient of light partition walls"
    annotation (Dialog(tab="Inner walls", group="Light partition walls"));

//Components
protected
  BuildingEnvelope.HeatTransfer.Wall Refends(
    InitType=InitType,
    Tp=Tp,
    caracParoi(
      n=caracRef.n,
      m=caracRef.m,
      e=caracRef.e,
      mat=caracRef.mat,
      positionIsolant=caracRef.positionIsolant),
    S=SRef,
    hs_ext=hRef,
    hs_int=hRef,
    ParoiInterne=true) "Inter-zones partition walls of supporting walls type"
    annotation (Placement(transformation(extent={{18,40},{38,60}})));
  BuildingEnvelope.HeatTransfer.Wall CloisonsLegeres(
    InitType=InitType,
    Tp=Tp,
    caracParoi(
      n=caracCleg.n,
      m=caracCleg.m,
      e=caracCleg.e,
      mat=caracCleg.mat,
      positionIsolant=caracCleg.positionIsolant),
    S=SCleg,
    hs_ext=hCleg,
    hs_int=hCleg,
    ParoiInterne=true) "Inter-zones light partition walls" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={58,50})));

equation
  connect(CloisonsLegeres.T_ext, noeudAir.port_a) annotation (Line(
      points={{67,47},{67,26.5},{28,26.5},{28,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(CloisonsLegeres.T_int, noeudAir.port_a) annotation (Line(
      points={{49,47},{49,26.5},{28,26.5},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Refends.T_int, noeudAir.port_a) annotation (Line(
      points={{37,47},{37,26.5},{28,26.5},{28,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Refends.T_ext, noeudAir.port_a) annotation (Line(
      points={{19,47},{19,27.5},{28,27.5},{28,6}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><b>Model of parallelepiped glazed zone on crawl space, in pure thermal modelling and integrating the internal inertia due to the inner walls.</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Parallelepiped single-zone building on crawl space with glazing model, to be connected to a boundary conditions model (left thermal port) and a left realOutput for solar fluxes. By default walls are oriented in the four cardinal points; the orientation modification is represented by the parameter beta. The right thermal port is connected to the inner volume (heat capacity). Floor and ceiling are subject to outside temperatures which are weighted by a coefficient b.</p>
<p>This model inherits from <a href=\"modelica://BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazed\"><code>ZoneCrawlSpaceGlazed</code></a> and superimposes on it internal partition walls of shear walls types (bearing walls) and light partition walls.</p>
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
<p>Validated model - Gilles Plessis 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2012 : Suppression du modifier <i>each </i>dans la définition des matériaux des parois. Le mot clé each n'a pas à être présent car les matériaux des parois sont définis en temps que vecteur.</p>
<p>Gilles Plessis 06/2012 : </p>
<p><ul>
<li>Intégration du changement de paramétrage des parois. Voir les révisions apportées au modèle de parois</li>
<li>Protection de composants pour éviter le grand nombre de variables dans la fenêtre des résultats.</li>
</ul></p>
<p>Gilles Plessis 03/2013 : Modification mineure sur la documentation.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {100,100}}), graphics));
end ZoneCrawlSpaceGlazedInternalPartitions;
