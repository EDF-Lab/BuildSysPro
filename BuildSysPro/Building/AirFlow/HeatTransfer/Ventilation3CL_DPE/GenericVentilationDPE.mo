within BuildSysPro.Building.AirFlow.HeatTransfer.Ventilation3CL_DPE;
record GenericVentilationDPE "Residential ventilation"

parameter Real SmeaConv= 2.15
    "Conventional value of the sum of air inlet modules at 20 Pa per unit of living area m3/h-m2";
parameter Real QvarepConv= 0.78
    "Conventional extract airflow per unit living area m3/h-m2";

  annotation (Documentation(info="<html>
<p><i><b>Record used to enter the ventilation parameters for the regulatory calculation (3CL DPE)</b></i></p>
<p>Records allows to save the parameters needed to calculate the ventilation flow using 3CL-DPE method (order April 2013)</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Saved parameters :</p>
<p>Smea_conv : conventional value of the sum of air inlet modules at 20Pa per unit of living area (m3/h/m&sup2;)</p>
<p>QvarepConv : conventional extract air flow per unit of living space (m3/h/m&sup2;) (specific to the ventilation system) (spécifique au système de ventilation)</p>
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
end GenericVentilationDPE;
