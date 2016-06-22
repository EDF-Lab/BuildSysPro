within BuildSysPro.BaseClasses.Media.OLD_THERMHYGAERO.AirConstants;
record CteAH "Moist air constants"
  parameter Real gamma=1.4 "Ratio Cp/Cv";
  parameter Real Cpa=1003.6
    "Specific heat capacity of air at constant pressure, at T=0°C [J/(kg.K)]";
  parameter Real Cva=Cpa/gamma
    "Specific heat capacity of air at constant volume, at T=0°C [J/(kg.K)]";
  parameter Real ra=287 "Specific constant of dry air [J/(kg.K)]";
  parameter Real Cpv=1859.4
    "Specific heat capacity of water vapour at constant pressure, at T=0°C [J/(kg.K)]";
  parameter Real Cvv=Cpv/gamma
    "Specific heat capacity of water vapour at constant volume, at T=0°C [J/(kg.K)]";
  parameter Real rv=462 "Specific constant of water vapour [J/(kg.K)]";
  parameter Real Cpe=4185
    "Specific heat capacity of water vapour at constant pressure, at T=16°C [J/(kg.K)]";
  parameter Real Cl=4216
    "Specific heat capacity of water vapour at constant pressure, at T=100°C [J/(kg.K)]";
  // parameter Real Lv=2500776 "Latent heat of vaporization at T=0°C [J/kg]";
  parameter Real Pref=101325 "Absolute pression of reference [Pa]";
  parameter Real TKref=273.15 "Absolute temperature of reference at 0°C [K]";
  parameter Real Lv0=AirFunctions.Lv(
      TKref,
      TKref,
      rv) "Latent heat of vaporization at T=0°C [J/kg]";
  parameter Real lambda=0.026
    "Thermal conductivity of dry air at 24°C [W/(m.K)]";
  parameter Real rav=ra/rv "Ratio of specific constants dry air/water vapour";
  parameter Real g=9.81 "Gravitational constant [m/s²]";
  parameter Real rhoLiq=1000 "Density of water [kg/m3]";
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end CteAH;
