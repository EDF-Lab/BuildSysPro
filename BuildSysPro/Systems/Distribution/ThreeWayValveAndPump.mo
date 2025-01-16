within BuildSysPro.Systems.Distribution;
model ThreeWayValveAndPump "Three ways valve with water pump"

  parameter Modelica.Units.SI.Power Pe_cons_WP=30;
  parameter Modelica.Units.SI.Time D=30
    "Delay time to switch from one way to other";
  parameter Modelica.Units.SI.MassFlowRate MFR=0.38 "Water mass flow rate";
parameter Real MFR_reduction=0.6
    "Percentage of water mass flow rate during compressor off function";
  parameter Modelica.Units.SI.MassFlowRate MFR_min=1e-3
    "Débit minimal du radiateur pour empecher l'arrêt de la simulation";
Real min_pos_V3V = 1e-3;

  Modelica.Units.SI.MassFlowRate m_flow;
  Modelica.Units.SI.Energy Ee_cons(start=0);
Real x_V3V;

  Modelica.Blocks.Interfaces.RealInput port_in_HP[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{-120,-4},{-100,16}}),
        iconTransformation(extent={{-120,-4},{-100,16}})));
  Modelica.Blocks.Interfaces.RealOutput port_out_HP[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{-100,-68},{-120,-48}}),
        iconTransformation(extent={{-100,-68},{-120,-48}})));
 input Modelica.Blocks.Interfaces.IntegerInput  mode
    annotation (Placement(transformation(extent={{-120,50},{-80,90}}),
        iconTransformation(extent={{-16,-16},{16,16}},
        rotation=270,
        origin={6,92})));

  Modelica.Blocks.Interfaces.RealInput port_in_DHW[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,110}),iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={76,86})));
  Modelica.Blocks.Interfaces.RealOutput port_out_DHW[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,110}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={48,86})));
  Modelica.Blocks.Interfaces.RealInput port_in_HC[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{120,-64},{100,-44}}),
        iconTransformation(extent={{120,-64},{100,-44}})));
  Modelica.Blocks.Interfaces.RealOutput port_out_HC[2] "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{100,0},{120,20}}),
        iconTransformation(extent={{100,0},{120,20}})));

// mode : 1 - HEATING CIRCUIT - COMPRESSOR ON  + ELECTRIC BACKUP OFF  - WP ON NOMINAL MASS FLOW RATE
// mode : 2 - DHW CIRCUIT     - COMPRESSOR ON  + ELECTRIC BACKUP OFF  - WP ON NOMINAL MASS FLOW RATE
// mode : 3 - HEATING CIRCUIT - COMPRESSOR ON  + ELECTRIC BACKUP ON   - WP ON NOMINAL MASS FLOW RATE
// mode : 4 - DHW CIRCUIT     - COMPRESSOR OFF + ELECTRIC BACKUP ON   - WP OFF NOMINAL MASS FLOW RATE
// mode : 5 - HEATING CIRCUIT - COMPRESSOR OFF + ELECTRIC BACKUP ON   - WP ON NOMINAL MASS FLOW RATE
// mode : 6 - HEATING CIRCUIT - COMPRESSOR OFF + ELECTRIC BACKUP ON   - WP ON NOMINAL MASS FLOW RATE
// mode : 7 - HEATING CIRCUIT - COMPRESSOR OFF + ELECTRIC BACKUP OFF  - WP ON REDUCED MASS FLOW RATE
// mode : 8 - DHW CIRCUIT     - COMPRESSOR OFF + ELECTRIC BACKUP OFF  - WP ON REDUCED MASS FLOW RATE
// mode : 9 - ALL System OFF
// Connexions 1:Temp / 2:m_flow

  Modelica.Blocks.Continuous.FirstOrder firstOrder_x_V3V(T=D/10, y_start=
        MFR_min)
    annotation (Placement(transformation(extent={{-16,10},{18,44}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder_m_flow(T=D/10, y_start=
        MFR_min)
    annotation (Placement(transformation(extent={{-16,-46},{18,-12}})));

  Modelica.Blocks.Interfaces.RealOutput Pe_cons annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-104}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-96})));


equation

  //DHW
if noEvent(mode == 2) then
  x_V3V = 1-min_pos_V3V;
  m_flow = MFR;

  //HEATING
elseif noEvent(mode == 1) or noEvent(mode == 3) or noEvent(mode ==5) or noEvent(mode ==6) then
  x_V3V = min_pos_V3V;
  m_flow = MFR;

  //HEATING
elseif noEvent(mode == 7) then
  x_V3V = min_pos_V3V;
  m_flow = MFR*MFR_reduction;

    //DHW
elseif noEvent(mode == 8) then
  x_V3V = 1-min_pos_V3V;
  m_flow = MFR*MFR_reduction;

    //HEATING
elseif noEvent(mode == 9) then
  x_V3V = min_pos_V3V;
  m_flow = MFR_min;

else
  x_V3V = min_pos_V3V;
  m_flow = MFR_min;

end if;

firstOrder_x_V3V.u  = x_V3V;
firstOrder_m_flow.u = m_flow;

port_in_HP[1]   = port_out_DHW[1];
port_in_HP[1]   = port_out_HC[1];

//Mass flow rate distribution
port_out_DHW[2] = firstOrder_m_flow.y*firstOrder_x_V3V.y;
port_out_HP[2]  = firstOrder_m_flow.y;

//Mass balance
port_out_HP[2] = port_out_DHW[2] + port_out_HC[2];

//Energy balance
port_out_HP[2]*port_out_HP[1] = port_in_DHW[2]*port_in_DHW[1] + port_in_HC[2]*port_in_HC[1];

Pe_cons = if noEvent(mode==7) or noEvent(mode==8) then Pe_cons_WP*MFR_reduction elseif noEvent(mode==9) then 0.0 else Pe_cons_WP;
der(Ee_cons)=noEvent(Pe_cons);

 annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                            Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                 graphics={
        Text(
          extent={{-136,-64},{-94,-88}},
          lineColor={0,0,255},
          textString="HP"),
        Text(
          extent={{92,98},{146,74}},
          lineColor={0,0,255},
          textString="DHW"),
        Text(
          extent={{84,-6},{136,-26}},
          lineColor={0,0,255},
          textString="HC"),
        Bitmap(extent={{-110,-98},{114,76}},
          imageSource=
              "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",
          fileName=
              "modelica://PAC_self_adaptive/Documentation/Images/distrib_circ.png")}),
              Diagram(graphics), Icon(graphics={Bitmap(extent={{-82,58},{80,
              -110}}, fileName=
              "modelica://PAC_hybride_20120510_FC/Images/Hydraulic Module.png")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model incorporates a 3 way valve and a water pump to distribute hot water coming from a source (boiler, heat pump,..) in two circuits (heating and domestic hot water, DHW).</p>
<p>The valve has only 2 positions : 100&#37; mass flow rate for heating or 100&#37; mass flow rate for DHW.</p>
<p>Several parameters are available for this model:</p>
<ul>
<li><code><span style=\"font-family: Courier New,courier;\">Pe_cons_WP (60W by default) : </code>electric power consumption of water pump;</li>
<li><code><span style=\"font-family: Courier New,courier;\">MFR (0.38 kg/s by default) : </code>nominal mass flow rate;</li>
<li><code><span style=\"font-family: Courier New,courier;\">MFR_reduction (0.6 by default) : </code>percentage of nominal mass flow rate used for modes when water is not heated (i.e. when water pump is running but the heat pump or the boiler are not in operation)</li>
<li><code><span style=\"font-family: Courier New,courier;\">MFR_min (1e-3 by default) : </code>minimal mass flow rate for each circuit (to avoid division by zero downstream the model)</li>
</ul>
<p><br>The input \"mode\" sets either DHW or HEATING and the mass flow rate (NOMINAL or REDUCED):</p>
<ul>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 1 - HEATING CIRCUIT - COMPRESSOR ON  - WP ON NOMINAL MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 2 - DHW CIRCUIT     - COMPRESSOR ON  - WP ON NOMINAL MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 3 - HEATING CIRCUIT - COMPRESSOR ON  + ELECTRIC DHW BACKUP ON   - WP ON NOMINAL MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 4 - DHW CIRCUIT     - COMPRESSOR OFF + ELECTRIC DHW BACKUP ON   - WP OFF NOMINAL MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 5 - HEATING CIRCUIT - COMPRESSOR OFF + ELECTRIC HEATING AND DHW BACKUPS ON   - WP ON NOMINAL MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 6 - HEATING CIRCUIT - COMPRESSOR OFF + ELECTRIC DHW BACKUP ON   - WP ON NOMINAL MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 7 - HEATING CIRCUIT - COMPRESSOR OFF + ELECTRIC DHW BACKUP OFF  - WP ON REDUCED MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 8 - DHW CIRCUIT     - COMPRESSOR OFF + ELECTRIC BACKUP OFF  - WP ON REDUCED MASS FLOW RATE</pre></li>
<li><pre><span style=\"font-family: Courier New,courier;\">mode : 9 - ALL System OFF</pre></li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alberto Tejeda 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Alberto TEJEDA, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
07/2018 - S. Froidurot : Récupération de Pe_cons en output du modèle, correction erreur dans la documentation
</html>"));
end ThreeWayValveAndPump;
