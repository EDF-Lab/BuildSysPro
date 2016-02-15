within BuildSysPro.BaseClasses.Media.OLD_THERMHYGAERO.AirConstants;
record CteAH
  parameter Real gamma=1.4 "Rapport Cp/Cv";
  parameter Real Cpa=1003.6
    "Capacité thermique massique de l'air à pression constante, à T=0°C [J/(kg.K)]";
  parameter Real Cva=Cpa/gamma
    "Capacité thermique massique de l'air à volume constant, à T=0°C [J/(kg.K)]";
  parameter Real ra=287 "Constante spécifique de l'air sec [J/(kg.K)]";
  parameter Real Cpv=1859.4
    "Capacité thermique massique de la vapeur d'eau à pression constante, à T=0°C [J/(kg.K)]";
  parameter Real Cvv=Cpv/gamma
    "Capacité thermique massique de la vapeur d'eau à volume constant, à T=0°C [J/(kg.K)]";
  parameter Real rv=462 "Constante spécifique de la vapeur d'eau [J/(kg.K)]";
  parameter Real Cpe=4185
    "Capacité thermique massique de l'eau à pression constante, à T=16°C [J/(kg.K)]";
  parameter Real Cl=4216
    "Capacité thermique massique de l'eau à pression constante, à T=100°C [J/(kg.K)]";
  // parameter Real Lv=2500776 "Chaleur latente de vaporisation à T=0°C [J/kg]";
  parameter Real Pref=101325 "Pression absolue de référence [Pa]";
  parameter Real TKref=273.15 "Température absolue de référence à 0°C [K]";
  parameter Real Lv0=AirFunctions.Lv(
      TKref,
      TKref,
      rv) "Chaleur latente de vaporisation à T=0°C [J/kg]";
  parameter Real lambda=0.026
    "Conductivité thermique air sec à 24°C [W/(m.K)]";
  parameter Real rav=ra/rv
    "Rapport des constantes spécifiques air sec/vapeur d'eau";
  parameter Real g=9.81 "Constante de la gravité [m/s²]";
  parameter Real rhoLiq=1000 "Masse volumique de l'eau [kg/m3]";
  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end CteAH;
