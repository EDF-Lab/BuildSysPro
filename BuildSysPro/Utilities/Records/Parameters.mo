within BuildSysPro.Utilities.Records;
record Parameters "Record of parameters"
parameter String name="";
parameter Real Value=1;
parameter Real min=-1e100;
parameter Real max=1e100;
parameter String description="";
// annotation for importing values from dsin//
annotation (Icon(graphics={              Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid), Line(
          points={{46,66},{0,0}},
          color={255,0,0},
          thickness=0.5)}), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end Parameters;
