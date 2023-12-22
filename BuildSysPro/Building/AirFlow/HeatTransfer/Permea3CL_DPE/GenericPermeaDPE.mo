within BuildSysPro.Building.AirFlow.HeatTransfer.Permea3CL_DPE;
record GenericPermeaDPE "Residential permeability"

  parameter Real I4Pa=0.4 "Air permeability under 4 Pa";

  annotation (Documentation(info="<html>
<p><i><b>Record used to enter the ventilation parameters for the regulatory calculation (3CL DPE)</b></i></p>
<p>Records allows to save the parameters needed to calculate the ventilation flow using 3CL-DPE method (order April 2013)</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Saved parameters :</p>
<p>I4Pa : conventional value of permeability at 4Pa(m3/h)</p>
<p><u><b>Bibliography</b></u></p>
<p>Annexe 1 - Méthode 3CL-DPE v1.3</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated records - Delphine Bousarout 03/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Delphine Bousarout, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end GenericPermeaDPE;
