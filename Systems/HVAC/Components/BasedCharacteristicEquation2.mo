within BuildSysPro.Systems.HVAC.Components;
model BasedCharacteristicEquation2
  "Distinction between radiative and convective temperatures for heat transfers"

  import SI = Modelica.SIunits;
  extends BuildSysPro.Systems.HVAC.Components.BasedCharacteristicEquation;

   // Variables
   SI.TemperatureDifference DTam_rad
    "Arithmetic mean temperature difference for radiation";
   SI.TemperatureDifference DTam_conv
    "Arithmetic mean temperature difference for convective heat transfers";

protected
 Real g0_rad "Internal variable returned by the f_pow function";
  Real g1_rad
    "Internal variable (corresponding to the derivative) returned by the f_pow function";

 Real g0_conv "Internal variable returned by the f_pow function";
  Real g1_conv
    "Internal variable (corresponding to the derivative) returned by the f_pow function";
equation
 // Radiative part
    DTam_rad= T_HWR-Rad.T;
    (g0_rad,g1_rad)=BuildSysPro.Utilities.Math.f_Pow(abs(DTam_rad),0.1,nNom-1);
    -Rad.Q_flow=FracRad*Km*DTam_rad*g0_rad;

// Convective part
   DTam_conv= T_HWR-Conv.T;
    (g0_conv,g1_conv)=BuildSysPro.Utilities.Math.f_Pow(abs(DTam_conv),0.1,nNom-1);
    -Conv.Q_flow=(1-FracRad)*Km*DTam_conv*g0_conv;

  annotation (Documentation(info="<html>


<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Authors : Gilles PLESSIS, Hassan BOUIA EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end BasedCharacteristicEquation2;
