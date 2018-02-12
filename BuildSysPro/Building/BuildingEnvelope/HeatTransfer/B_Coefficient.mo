within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model B_Coefficient
  "Simple boundary conditions (linear combination of temperature) for unheated space"
parameter Real b=0.1 "Weighting coefficient";
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_ext
    annotation (Placement(transformation(extent={{-100,20},{-80,40}}),
        iconTransformation(extent={{-100,20},{-80,40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tponder
    annotation (Placement(transformation(extent={{40,-12},{60,8}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_int
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}}),
        iconTransformation(extent={{-100,-40},{-80,-20}})));

equation
  Tponder.T=b*port_ext.T+(1-b)*port_int.T;
  port_int.Q_flow=0;
  port_ext.Q_flow=-Tponder.Q_flow;

annotation (Documentation(info="<html>
<p>An unheated room can be considered as an additional area of the building.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>However, a study conducted in the EDF/ R&amp;D / ADEB Department showed that a wall (horizontal or vertical) in contact with an unheated room, could be treated as an outer wall with an additional layer of insulation and overlooking outside.</p>
<p>The thickness of this additional layer is calculated considering the equality between the real wall losses and those of the fictitious wall (ie with additional insulation).</p>
<p>The thermal coefficient of the wall obtained is used to model the influence of unheated room.</p>
<p>For this, the regulatory coefficient of temperature reduction <code>b</code> is introduced.<p>
<p><u><b>Bibliography</b></u></p>
<p>2005 French building regulation (RT2005) : Règles Th-U - Fascicule 1 : Coeffcient Ubât, Chapitre II : Coefficient Ubât p10, 11, 12</p>
<p><u><b>Instructions for use</b></u></p>
<p>The regulatory coefficient of temperature reduction <code>b</code> parameter is defined according to the type of the unheated room as follows: </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/coefficient_b2.bmp\"/></p>
<p>In the case where a more accurate calculation of the coefficient <code>b</code> is needed, the following method can be used</p>
<p>To define the coefficient <code>b</code>, default values are given in tables 2 to 5 according to the ratio between surfaces <code>Aiu/Aue</code> and the \"equivalent surface coefficient\" <code>Uv,ue</code>.</p>
<ul><li><code>Aiu</code> is the total surface of coponents separating the unheated room to the heated wall, in m&sup2;</li>
<li><code>Aue</code> is the total surface of components separating the unheated room to outdoor or to an other unheated room, in m&sup2;</li>
<li><code>Uv,ue</code> is the equivalent of a surface coefficient of the wall between the unheated room and outdoor or an other unheated room, in W/m&sup2;.K.<br>
It reprensents the unheated room losses by air renewal, adjusted to the wall surface unit:<br>
<code>Uv,ue</code> = 0.33<code>que</code> where <code>que</code> is the air flow per wall square meter, in m&sup3;/h/m&sup2;</li></ul>
<p>The table 1 shows which table needs to be used to find the right coefficient <code>b</code> :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/Coefficient_b.png\"/></p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Gilles PLESSIS, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 02/2011 : Fusion des deux anciens modèles afin de prendre en compte en plus de la condition en température une condition de flux. La précédente version (2010.12) induisait en effet des problèmes de bilan d'énergie lors du calcul de GV de certains bâtiments avec l'apparition de termes sources ou puits.</p>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                               graphics={
        Polygon(
          points={{-80,60},{-80,-60},{46,0},{-80,60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-82,-16},{-26,-40}},
          lineColor={255,255,255},
          textString="*(1-b)"),
        Text(
          extent={{-94,42},{-30,16}},
          lineColor={255,255,255},
          textString="*b"),
        Text(
          extent={{-32,12},{4,-10}},
          lineColor={255,255,255},
          textString="+")}),
              Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics), Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Polygon(
          points={{-80,60},{-80,-56},{48,0},{-80,60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid)}));
end B_Coefficient;
