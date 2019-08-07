within BuildSysPro.BaseClasses.Media.OLD_THERMHYGAERO.AirConstants;
record CteAH "Moist air constants"
  constant Real gamma=1.4 "Ratio Cp/Cv";
  constant Real Cpa=1003.6
    "Specific heat capacity of air at constant pressure, at T=0°C [J/(kg.K)]";
  constant Real Cva=Cpa/gamma
    "Specific heat capacity of air at constant volume, at T=0°C [J/(kg.K)]";
  constant Real ra=287 "Specific constant of dry air [J/(kg.K)]";
  constant Real Cpv=1859.4
    "Specific heat capacity of water vapour at constant pressure, at T=0°C [J/(kg.K)]";
  constant Real Cvv=Cpv/gamma
    "Specific heat capacity of water vapour at constant volume, at T=0°C [J/(kg.K)]";
  constant Real rv=462 "Specific constant of water vapour [J/(kg.K)]";
  constant Real Cpe=4185
    "Specific heat capacity of water vapour at constant pressure, at T=16°C [J/(kg.K)]";
  constant Real Cl=4216
    "Specific heat capacity of water vapour at constant pressure, at T=100°C [J/(kg.K)]";
  // constant Real Lv=2500776 "Latent heat of vaporization at T=0°C [J/kg]";
  constant Real Pref=101325 "Absolute pression of reference [Pa]";
  constant Real TKref=273.15 "Absolute temperature of reference at 0°C [K]";
  constant Real Lv0=AirFunctions.Lv(
      TKref,
      TKref,
      rv) "Latent heat of vaporization at T=0°C [J/kg]";
  constant Real lambda=0.026
    "Thermal conductivity of dry air at 24°C [W/(m.K)]";
  constant Real rav=ra/rv "Ratio of specific constants dry air/water vapour";
  constant Real g=9.81 "Gravitational constant [m/s²]";
  constant Real rhoLiq=1000 "Density of water [kg/m3]";
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
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 03/2017 : replacing parameters by constants to avoid bug in OpenModelica.</p>
</html>"));
end CteAH;
