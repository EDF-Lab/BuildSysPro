within BuildSysPro.IBPSA.Fluid.Types;
type InputType = enumeration(
    Constant "Use parameter to set stage",
    Stages "Use integer input to select stage",
    Continuous "Use continuous, real input") "Input options for movers"
  annotation (Documentation(info="<html>
<p>
This type allows defining which type of input should be used for movers.
This can either be
</p>
<ol>
<li>
a constant set point declared by a parameter,
</li>
<li>
a series of possible set points that can be switched using an integer input, or
</li>
<li>
a continuously variable set point.
</li>
</ol>
</html>",
        revisions="<html>
<ul>
<li>
April 2, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
