within BuildSysPro.Utilities.Records;
record Variables "Record of a variable"
parameter String name="";
parameter String unit="";
parameter String description="";
annotation (Dialog(label="Model variables",importDsin(button="Choisir les variables",
           fields(name=initialName,
unit=initialValue.unit))),Icon(graphics={           Line(points={{-100,-26},{-80,
              -6},{-60,20},{-20,74},{20,14},{50,-26},{80,-36},{100,-40}},color={255,
              0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,84},{-100,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,72},{6.94956e-015,-128}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-28,-60},
          rotation=90)}),
    Documentation(info="<html>
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
end Variables;
