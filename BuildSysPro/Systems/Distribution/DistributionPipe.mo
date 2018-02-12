within BuildSysPro.Systems.Distribution;
model DistributionPipe "Modelization of a hot/cold distribution system"

  import SI = Modelica.SIunits;

  parameter Integer Choix=1  annotation(Dialog(group="Choice of calculation method"), choices(choice=1
        "Characteristics of pipe known",    choice=2
        "Estimation by boiler power"));

  parameter SI.Length L=20
    "Exchange length of dstribution pipe (if L = 0 then simplified and global calculation of heat losses according to QfouNom"
                                                                                                       annotation(Dialog(enable=(Choix==1), group="Choice 1 : Characteristics of pipe known"));
  parameter SI.ThermalConductivity U=0.04
    "Linear exchange coefficient, defining the distribution pipe"                               annotation(Dialog(enable=(Choix==1), group="Choice 1 : Characteristics of pipe known"));
  parameter SI.SpecificHeatCapacity CpLiq=4190
    "Thermal capacity of heat transfer fluid" annotation(Dialog(enable=(Choix==1), group="Choice 1 : Characteristics of pipe known"));
  parameter Real Rpnre= 0.8 "Ratio of non recoverable thermal losses"
                                                     annotation(Dialog(enable=(Choix==2), group="Choice 2 : Estimation by boiler power"));
  parameter Modelica.SIunits.Power QfouNom=8000
    "Rated power supplied by the production system (boiler)" annotation(Dialog(enable=(Choix==2), group="Choice 2 : Estimation by boiler power"));
  parameter Real Cperte=0.025 "Default losses evaluated at 2.5% of QfouNom"
                                                  annotation(Dialog(enable=(Choix==2), group="Choice 2 : Estimation by boiler power"));

protected
  SI.MassFlowRate Debit; //Mass flow in the pipe
SI.Power Qper; //Lost heat

public
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1- the output fluid temperature (K), 2- the output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-10},{120,30}}),
        iconTransformation(extent={{80,-20},{100,0}})));
  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1- the input fluid temperature (K), 2- the input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-100,-20},{-80,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int
    "Heatport to connect to the thermal zone" annotation (Placement(
        transformation(extent={{-10,60},{10,80}}), iconTransformation(extent={{-10,
            60},{10,80}})));
// -----------------------------------------------------------------------------------
equation

// Conservation of flow : WaterIn[2]=WaterOut[2]
  Debit=WaterIn[2];

// Calculation of the distribution pipe losses
  if (L>0) then// CASE : KNOWN PIPE

  // Calculation of the output temperature
    if WaterIn[1] > T_int.T then
      WaterOut[1] = max(T_int.T, WaterIn[1] - (WaterIn[1] - T_int.T)*(1 - exp(-
        U*L/(Debit*CpLiq))));
    else
      WaterOut[1] = min(T_int.T, WaterIn[1] - (WaterIn[1] - T_int.T)*(1 - exp(-
        U*L/(Debit*CpLiq))));
    end if;
  // Calculation of losses
    Qper =Debit*CpLiq*(WaterIn[1] - WaterOut[1]);

  else // CASE : DEFAULT VALUES
  // Calculation of losses
    Qper = Cperte*QfouNom;

  // Calculation of the output temperature
    if (Debit>1e-4) then
      WaterOut[1] = WaterIn[1] - Qper/(Debit*CpLiq);
    else
      WaterOut[1] = T_int.T;
    end if;

end if;

// Calculation of the recoverable heat part
  T_int.Q_flow = -Qper*(1 - Rpnre);

  connect(WaterIn[2], WaterOut[2]) annotation (Line(
      points={{-100,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model takes into account the heat losses of the ditribution system, by two possible methods :</p>
<p>- if pipe characteristics are known, the calculation allows to construct the distribution system connecting radiators and pipe elements</p>
<p>- if not, heat losses can be estimated according to the boiler power</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Sila Filfli 06/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>",
    revisions="<html>
<p>Hubert Blervaque - Juin 2012 : MAJ de la documentation BuildSysPro</p>
</html>"), Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-70,0},{72,-20}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          lineThickness=1),
        Ellipse(
          extent={{62,0},{78,-20}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Ellipse(
          extent={{-78,0},{-62,-20}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}));
end DistributionPipe;
