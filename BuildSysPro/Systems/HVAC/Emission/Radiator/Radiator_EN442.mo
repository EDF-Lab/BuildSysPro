within BuildSysPro.Systems.HVAC.Emission.Radiator;
model Radiator_EN442 "Radiator model based on the EN442 standard"

  import SI = Modelica.SIunits;
  extends BuildSysPro.Systems.HVAC.Components.CharacteristicEquation;

  // Parameters

  /*parameter Integer Type=2 
    "Type de radiateur déterminant l'inertie (masse à sec et volume d'eau) par une corrélation sur la puissance nominale"
    annotation(Dialog(group="Technologies de radiateur"), choices(
                choice=1 "Radiateur en fonte (inertie forte)",
                choice=2 "Radiateur en aluminium (inertie intermédiaire)",
                choice=3 
        "Radiateur en panneau acier (inertie légèrement inférieure à l'aluminium)"));*/

    parameter Boolean useInertia=false "Steady state modelling of dynamics"
  annotation(dialog(group="Options",compact=true),choices(choice=false
        "Steady state",                                                               choice=true "Dynamic",
                                                                                  radioButtons=true));
    replaceable package Medium =
      Modelica.Media.Interfaces.PartialSimpleMedium                          annotation (choicesAllMatching=true);

  parameter SI.Mass MediumMass "Mass of water" annotation(dialog(tab="Dynamic"));
  parameter SI.Mass BodyMass "Radiator mass" annotation(dialog(tab="Dynamic"));
  parameter SI.SpecificHeatCapacity cpBody=500
    "Specific heat capacity of the radiator body (ex. 500J/kg/K for cast iron)"
                                                                                annotation(dialog(tab="Dynamic"));

    // Variables

SI.TemperatureDifference DTlm= (EntreeEau[1]- SortieEau[1])/Modelica.Math.log((EntreeEau[1]-(Conv.T+Rad.T)/2)/ (SortieEau[1]-(Conv.T+Rad.T)/2))
    "Logaritmic mean temperature difference, given for information, EN442 being based on arithmetic mean temperature difference";
inner SI.Temperature   T_HWR(start=273.15+60)
    "Temperature of the hot water radiator";

// Components

  Modelica.Blocks.Interfaces.RealInput EntreeEau[2](start={330,1})
    "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{-90,42},{-70,62}}),
        iconTransformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Interfaces.RealOutput SortieEau[2](start={330,1})
    "1:Temp / 2:m_flow"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}}),
        iconTransformation(extent={{80,-60},{100,-40}})));

equation
assert((EntreeEau[1]-Conv.T)/(SortieEau[1]-Conv.T)<3,"Arithmetic mean temperature difference assumption leads to a deviation exceeding 5% (compared to LMTD)");

  // Energy balance
  if not useInertia then
   0=EntreeEau[2]*Medium.cp_const*(EntreeEau[1]-SortieEau[1])-radEqua.Qtot;
   T_HWR= (EntreeEau[1]+SortieEau[1])/2;

  else
  (MediumMass*Medium.cp_const*SortieEau[1]+BodyMass*cpBody)*der(T_HWR)=EntreeEau[2]*Medium.cp_const*(EntreeEau[1]-SortieEau[1])-radEqua.Qtot;
  //   T_HWR= (EntreeEau[1]+SortieEau[1])/2; // Assure la cohérence de puissance entre le régime statique et dynamique
   T_HWR= SortieEau[1]; // Assure la continuité de la température de radiateur.
   //En revanche il faut intégrer une discrétisation sinon les conditions nominales ne fournissent pas
  end if;

   // Continuity equation
  EntreeEau[2]=SortieEau[2];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-80,54},{-74,48}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-74,60},{74,-60}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          radius=5),
        Polygon(
          points={{-60,50},{-64,44},{-64,-44},{-60,-50},{-56,-44},{-56,44},{-60,
              50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-40,50},{-44,44},{-44,-44},{-40,-50},{-36,-44},{-36,44},{-40,
              50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-20,50},{-24,44},{-24,-44},{-20,-50},{-16,-44},{-16,44},{-20,
              50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{0,50},{-4,44},{-4,-44},{0,-50},{4,-44},{4,44},{0,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{20,50},{16,44},{16,-44},{20,-50},{24,-44},{24,44},{20,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{40,50},{36,44},{36,-44},{40,-50},{44,-44},{44,44},{40,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{60,50},{56,44},{56,-44},{60,-50},{64,-44},{64,44},{60,50}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-74,16},{74,-10}},
          lineColor={0,0,255},
          textString="EN 442"),
        Line(
          points={{34,80},{36,82},{34,86},{34,88},{36,90},{36,92}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{30,80},{32,82},{30,86},{30,88},{32,90},{32,92}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{26,80},{28,82},{26,86},{26,88},{28,90},{28,92}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-24,92},{-24,80},{-22,84}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-28,80},{-28,92},{-26,90}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-32,92},{-32,80},{-30,84}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-36,80},{-36,92},{-38,90}},
          color={0,0,255},
          smooth=Smooth.None),
        Rectangle(
          extent={{74,-48},{80,-54}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><i><b><span style=\"font-family: MS Shell Dlg 2;\">Simple hot water radiator model for central heating system</span></b></i></p>
<p><u><b><span style=\"font-family: MS Shell Dlg 2;\">Hypothesis and equations</span></b></u></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">This model is based on the characteristic equation (Qflow=Km DT<sup>N</sup>) described in the EN442 standard.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Depending on the model </span><code>options</code><span style=\"font-family: MS Shell Dlg 2;\">, DT could be considered as followed:</span></p>
<ul>
<li>DT= T_HWR - Troom where Troom = Trad+Tconv/2 if <code>radEqua</code>=<code>BuildSysPro.BaseClasses.HeatTransfer.Components.BasedCharacteristicEquation1</code></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">or 2 characteristic equations could be considered for radiative and convective heat transfers respectively : DTrad= T_HWR - Trad and DTconv= T_HWR - Tconv if </span><code>radEqua=BuildSysPro.BaseClasses.HeatTransfer.Components.BasedCharacteristicEquation2</code></li>
</ul>
<p>Otherwise the model use<span style=\"font-family: MS Shell Dlg 2;\"> common equations for energy balance and continuity equation (no mass accumulation).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Depending on the option </span><code>useInertia</code><span style=\"font-family: MS Shell Dlg 2;\">, steady state or dynamic behaviour are computed. For dynamic computation, the energy balanced is calculated as :</span></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equation-dLvjxgIW.png\"/></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">This model does not considered a discretization along the fluid path.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model relies also on an arithmetic mean temperature difference (AMTD), different from the theorical logarithmic mean temperature difference (LMTD) and should be used when the following condition is fulfilled :</span></p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equation-XCBkvCZD.png\"/></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Otherwise using AMTD leads to a deviation exceeding 10&percnt;.</span></p>
<p><u><b><span style=\"font-family: MS Shell Dlg 2;\">Bibliography</span></b></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model was implemented following the EN442 standard and considering a single element.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Nilsson, P.E. and The Commtech Group, 2003. Achieving the Desired Indoor Climate: Energy Efficiency Aspects of System Design. Studentlitteratur AB.</span></p>
<p><br><u><b><span style=\"font-family: MS Shell Dlg 2;\">Instructions for use</span></b></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Connect the model to a distribution network through the </span><span style=\"font-family: David;\">EntreeEau </span>and <code>SortieEau </code><span style=\"font-family: MS Shell Dlg 2;\">connectors.</span></p>
<p>Connect also the model to a thermal ambiance through the <code>Conv </code>and <code>Rad </code>heatports respectively for convective heat transfers and long wave radiation.</p>
<p><u><b><span style=\"font-family: MS Shell Dlg 2;\">Known limits / Use precautions</span></b></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model is not discretized along the fluid path therefore in Dynamic mode, nominal operating conditions do not lead to the nominal heating power.</span></p>
<p><u><b><span style=\"font-family: MS Shell Dlg 2;\">Validations</span></b></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple validation based on operating point - Gilles PLESSIS 01/2016</span> </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end Radiator_EN442;
