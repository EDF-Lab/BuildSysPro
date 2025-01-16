within BuildSysPro.Systems.Controls;
model PrescribedFilteredTemperature

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port
                             annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0)));
  import      Modelica.Units.SI;
  SI.Temperature Tc;
  SI.Temperature TcFiltre(start=Tcons[1]);
  parameter SI.Time t[:] "Moments (t[n] is the period)";
  parameter SI.Temperature Tcons[size(t,1)] "Setpoint temperature";
  parameter Real Tau=0.1 "Filter time constant";
protected
  parameter Integer n=size(t,1) "Number of points";
  parameter SI.Time u[n+1]=cat(1,{0},t);
  parameter SI.Time dt[n]=(u[2:n+1]-u[1:n]);
  discrete SI.Time tNext(start=dt[1],fixed=true);
  Integer Ind(start=1,fixed=true);
equation
  when mod(time,t[n]) >= mod(pre(tNext),t[n]) then
    Ind=1+mod(pre(Ind),n);
    tNext=time+dt[Ind];
  end when;
  Tc = if time <= tNext - dt[Ind]/2 then  Tcons[pre(Ind)] else Tcons[Ind];
  //Tc = Tcons[Ind];
  Tau*der(TcFiltre)+TcFiltre=Tc; // Filter with a constant time Tau
  port.T =TcFiltre;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(extent={{-118,165},{122,105}}, textString="%name"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{0,0},{-100,-100}},
          lineColor={0,0,0},
          textString="°C"),
        Polygon(
          points={{52,-20},{52,20},{90,0},{52,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-145,-102},{135,-151}},
          lineColor={0,0,0},
          textString="T=%T"),
        Line(
          points={{-42,0},{66,0}},
          color={191,0,0},
          thickness=0.5)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model defines a fixed temperature T at its port in [degC], i.e., it defines a fixed temperature as a boundary condition.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 11/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hassan BOUIA, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Mathias Bouquerel 12/2016 : remplacement du port thermique Modelica par le port thermique BuildSysPro</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                    graphics));
end PrescribedFilteredTemperature;
