within BuildSysPro.Systems.HVAC.Emission.Radiator.Components;
model BasedCharacteristicEquation1
  "Room temperature based on average between radiative and convective temperatures"
 import SI = Modelica.SIunits;
  extends
    BuildSysPro.Systems.HVAC.Emission.Radiator.Components.BasedCharacteristicEquation;

   // Variables
   SI.TemperatureDifference DTam
    "Arithmetic mean temperature difference for radiation and convection";

protected
 Real g0 "Internal variable returned by the f_pow function";
  Real g1
    "Internal variable (corresponding to the derivative) returned by the f_pow function";
equation
    DTam= T_HWR-(Conv.T+Rad.T)/2;
    (g0,g1)=BuildSysPro.Utilities.Math.f_Pow(abs(DTam),0.1,nNom-1);
    -Conv.Q_flow=(1-FracRad)*Km*DTam*g0;
    -Rad.Q_flow=FracRad*Km*DTam*g0;

  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Authors : Gilles PLESSIS, Hassan BOUIA EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end BasedCharacteristicEquation1;
