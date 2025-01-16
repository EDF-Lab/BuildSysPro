within BuildSysPro.BuildingStock.Utilities.Records.HeatTransfer;
record h_surf_ISO6946 "Set of surface heat transfer coefficients from ISO 6946"

  import      Modelica.Units.SI;

  parameter SI.CoefficientOfHeatTransfer h_ext_wall = 25.0;
  parameter SI.CoefficientOfHeatTransfer h_ext_roof = 25.0;
  parameter SI.CoefficientOfHeatTransfer h_ext_raised_floor = 25.0;
  parameter SI.CoefficientOfHeatTransfer h_int_wall = 7.69;
  parameter SI.CoefficientOfHeatTransfer h_int_ceiling = 10.0;
  parameter SI.CoefficientOfHeatTransfer h_int_floor = 5.88;
  parameter SI.CoefficientOfHeatTransfer h_int_raised_floor = 5.88;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><i><b>Record used to store the surface heat transfer coefficients from ISO 6946</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>These coefficients can be used to calculate the total heat transfer occuring between a wall surface and the ambiant air, including both the convective and radiative effects.</p>
<p>The coefficient values are those specified in the ISO 6946 standard, which are also used in many national building energy regulations, including the French &quot;R&eacute;glementation Thermique&quot;.</p>
<p><u><b>Bibliography</b></u></p>
<ul>
<li>International Standard ISO 6946:2017 : Building components and building elements &mdash; Thermal resistance and thermal transmittance &mdash; Calculation methods</li>
<li>R&eacute;glementation Thermique 2012</li>
</ul>
<p><u><b>Instructions for use</b></u></p>
<p>Each coefficient is suited for a specific orientation, and for the indoor or outdoor surface of the wall, for instance respectively <span style=\"font-family: Courier New;\">hs_int</span> and <span style=\"font-family: Courier New;\">hs_ext</span> for the <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">Wall model</a> of BuildSysPro.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>These coefficients shall be used only if the radiative heat transfer is included in the surface heat transfer model. For instance, for the models like the <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall\">Wall model</a> or the <a href=\"modelica://BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window\">Window model</a> of BuildSysPro, these coefficients shall be used only if <span style=\"font-family: Courier New;\">GLOext=false</span>.</p>
<p>The coefficients are average values, suited to represent an average surface heat transfer, but they do not take into account the fact that the air displacement (wind speed), surface radiative properties and meteorological conditions (cloudiness) have an impact on the total surface heat transfer.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Mathias BOUQUEREL 05/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2019<br>
BuildSysPro version 3.7.0<br>
Author : Mathias BOUQUEREL, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));
end h_surf_ISO6946;
