within BuildSysPro.IBPSA.Media.Specialized.Air.PerfectGas;
function sublimationPressureIce =
    Modelica.Media.Air.MoistAir.sublimationPressureIce
  "Saturation curve valid for 223.16 <= T <= 273.16. Outside of these limits a (less accurate) result is returned"
annotation (
  Inline=true);
