within BuildSysPro.IBPSA.Media.Specialized.Air.PerfectGas;
function HeatCapacityOfWater
    "Specific heat capacity of water (liquid only) which is constant"
    extends Modelica.Icons.Function;
    input Temperature T;
    output SpecificHeatCapacity cp_fl;
algorithm
    cp_fl := cpWatLiq;
  annotation (
    Inline=true);
end HeatCapacityOfWater;
