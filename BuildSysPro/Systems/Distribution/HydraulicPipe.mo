within BuildSysPro.Systems.Distribution;
model HydraulicPipe "Modeling of a hot or cold water network"

  import      Modelica.Units.SI;

  parameter Boolean Choix = true  annotation(Dialog(group="Choix de la méthode de calcul"),
          choices(choice= true "Charactéristiques tuyauterie connues",
          choice = false "Estimation par puissance chaudière",
          radioButtons= true));
  parameter SI.Length L=20
    "Exchange length of dstribution pipe (if L = 0 then simplified and global calculation of heat losses according to QfouNom"
                                                                                                        annotation(Dialog(enable=Choix, group="Choix 1 : Charactéristiques tuyauterie connues"));
  parameter SI.ThermalConductivity U=0.04
    "Linear exchange coefficient, defining the distribution pipe"                                annotation(Dialog(enable=Choix, group="Choix 1 : Charactéristiques tuyauterie connues"));
  parameter SI.SpecificHeatCapacity CpLiq=4190
    "Thermal capacity of heat transfer fluid" annotation(Dialog(enable=Choix, group="Choix 1 : Charactéristiques tuyauterie connues"));
  parameter Real Rpnre= 0.8 "Ratio of non recoverable thermal losses"
                                                     annotation(Dialog(enable= not Choix, group="Choix 2 : Estimation par puissance chaudière"));
  parameter Modelica.Units.SI.Power QfouNom=8000
     "Rated power supplied by the production system (boiler)" annotation (Dialog(
        enable=not Choix, group="Choix 2 : Estimation par puissance chaudière"));
  parameter Real Cperte=0.025
    "Default losses evaluated at 2.5% of QfouNom"  annotation(Dialog(enable = not Choix,  group="Choix 2 : Estimation par puissance chaudière"));

protected
SI.MassFlowRate Debit; ///Mass flow in the pipe
SI.Power Qper; //Lost heat
public
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
       "Vector containing 1- the output fluid temperature (K), 2- the output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1- the input fluid temperature (K), 2- the input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int
   "Heatport to connect to the thermal zone" annotation (Placement(
        transformation(extent={{-10,40},{10,60}}), iconTransformation(extent={{
            -10,40},{10,60}})));
// -----------------------------------------------------------------------------------
equation

// Conservation of flow : WaterIn[2]=WaterOut[2]
  WaterIn[2] = WaterOut[2];
  Debit=abs(WaterIn[2]);

// Calculation of the distribution pipe losses
  if Choix then// CASE : KNOWN PIPE

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

  annotation (Documentation(info="<html>
<p><h4>Deparditive pipe(non-capacitive) of a hydraulic network</h4></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model is based on an addition of a hydraulic port on the basic model for the need of heated floor study.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Link <a href=\"modelica://BuildSysPro.Systems.Distribution.DistributionPipe\">DistributionPipe</a>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Sila Filfli /2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
    revisions="<html>
<p>Hubert Blervaque 06/2012 : MAJ de la documentation BuildSysPro.</p>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>"), Diagram(coordinateSystem(extent={{-100,-60},{100,60}},
          preserveAspectRatio=true),
                   graphics),
    Icon(coordinateSystem(extent={{-100,-60},{100,60}}, preserveAspectRatio=
           true),
         graphics={
        Rectangle(
          extent={{-70,10},{72,-10}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          lineThickness=1),
        Ellipse(
          extent={{62,10},{78,-10}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Ellipse(
          extent={{-78,10},{-62,-10}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1),
        Text(
          extent={{-20,10},{20,-10}},
          lineColor={255,255,255},
          textString="R")}));
end HydraulicPipe;
