within BuildSysPro.Building.BuildingEnvelope.Functions;
function U_Wall
  "U-value calculated from the wall composition (GenericWall record)"

  import SI = Modelica.SIunits;

  input BuildSysPro.Utilities.Records.GenericWall wall_record
    "Wall composition record";
  input SI.SurfaceCoefficientOfHeatTransfer hs_int = 7.69
    "Internal surface coefficient of heat transfer";
  input SI.SurfaceCoefficientOfHeatTransfer hs_ext = 25
    "External surface coefficient of heat transfer";

  output SI.SurfaceCoefficientOfHeatTransfer U_value
    "U_value of the wall";

protected
  SI.ThermalInsulance R_h_surf
    "Thermal resistance of the internal + external boundary layers";
  SI.ThermalInsulance R_without_h_surf
    "Thermal resistance without the bounrady layers";
  SI.ThermalInsulance R_total
    "Total thermal resistance of the wall";

algorithm

  R_without_h_surf :=0;
  for i in 1:wall_record.n loop
    R_without_h_surf := R_without_h_surf + wall_record.e[i]/wall_record.mat[i].lambda;
  end for;

  R_h_surf := 1/hs_int + 1/hs_ext;
  R_total := R_h_surf + R_without_h_surf;

  U_value := 1/R_total;

      annotation (Documentation(info="<html>
<p><i><b>Function for the calculation of a wall U_value</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function calculates the U-value of a wall from the record containing the wall composition and the surface heat transfer coefficients.</p>
<p><u><b>Instructions for use</b></u></p>
<p>The inputs of the model are:</p>
<ul>
<li>The wall composition constructed according to the <a href=\"modelica://BuildSysPro.Utilities.Records.GenericWall\">GenericWall</a> record of BuildSysPro</li>
<li>The surface heat transfer coefficients to be used on the interior and exterior surfaces</li>
</ul>
<p>The output of the function is the wall U-value.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p><p>Validated model - Mathias BOUQUEREL 07/2019</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2019<br>
Author : Mathias BOUQUEREL, EDF (2019)<br>
--------------------------------------------------------------</b></p>
</html>"));
end U_Wall;
