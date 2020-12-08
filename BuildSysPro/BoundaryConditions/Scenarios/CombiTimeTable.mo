within BuildSysPro.BoundaryConditions.Scenarios;
model CombiTimeTable
  "Table look-up with respect to time and linear/perodic extrapolation methods (data from matrix/file)"

  parameter Boolean tableOnFile=false
    "= true, if table is defined on file or in function usertab"
    annotation(Dialog(group="table data definition"));
  parameter Real table[:, :] = fill(0.0,0,2)
    "Table matrix (time = first column; e.g. table=[0,2])"
       annotation(Dialog(group="table data definition", enable = not tableOnFile));
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
       annotation(Dialog(group="table data definition", enable = tableOnFile));
  parameter String fileName="NoName" "File where matrix is stored"
       annotation(Dialog(group="table data definition", enable = tableOnFile,
                         __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));
  parameter Integer columns[:]=2:size(table, 2)
    "Columns of table to be interpolated"
  annotation(Dialog(group="table data interpretation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
  annotation(Dialog(group="table data interpretation"));
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range"
  annotation(Dialog(group="table data interpretation"));
  parameter Real offset[:]={0} "Offsets of output signals"
  annotation(Dialog(group="table data interpretation"));
  parameter Modelica.SIunits.Time startTime=0
    "Output = offset for time < startTime"
  annotation(Dialog(group="table data interpretation"));
  extends Modelica.Blocks.Interfaces.MO(final nout=max([size(columns, 1); size(offset, 1)]));
  final parameter Real t_min(fixed=false)
    "Minimum abscissa value defined in table";
  final parameter Real t_max(fixed=false)
    "Maximum abscissa value defined in table";

protected
  final parameter Real p_offset[nout]=(if size(offset, 1) == 1 then ones(nout)
       *offset[1] else offset);

  Integer tableID;

  function tableTimeInit
    input String tableName;
    input String fileName;
    input Real table[ :, :];
    input Real startTime;
    input Modelica.Blocks.Types.Smoothness smoothness;
    input Modelica.Blocks.Types.Extrapolation extrapolation;
    output Integer tableID;
  external "C" tableID = ModelicaTables_CombiTimeTable_init(
                 tableName, fileName, table, size(table, 1), size(table, 2),
                 startTime, smoothness, extrapolation);
    annotation(Library="ModelicaExternalC");
  end tableTimeInit;

  function tableTimeIpo
    input Integer tableID;
    input Integer icol;
    input Real timeIn;
    output Real value;
  external "C" value=ModelicaTables_CombiTimeTable_interpolate(tableID, icol, timeIn);
    annotation(Library="ModelicaExternalC");
  end tableTimeIpo;

  function tableTimeTmin
    input Integer tableID;
    output Real Tmin "minimum time value in table";
  external "C" Tmin=ModelicaTables_CombiTimeTable_minimumTime(tableID);
    annotation(Library="ModelicaExternalC");
  end tableTimeTmin;

  function tableTimeTmax
    input Integer tableID;
    output Real Tmax "maximum time value in table";
  external "C" Tmax=ModelicaTables_CombiTimeTable_maximumTime(tableID);
    annotation(Library="ModelicaExternalC");
  end tableTimeTmax;

equation
  if tableOnFile then
    assert(tableName<>"NoName", "tableOnFile = true and no table name given");
  end if;
  if not tableOnFile then
    assert(size(table,1) > 0 and size(table,2) > 0, "tableOnFile = false and parameter table is an empty matrix");
  end if;
  for i in 1:nout loop
    y[i] = p_offset[i] + tableTimeIpo(tableID, columns[i], time);
  end for;
  when initial() then
    tableID=tableTimeInit((if not tableOnFile then "NoName" else tableName),
                          (if not tableOnFile then "NoName" else fileName), table,
                          startTime, smoothness, extrapolation);
  end when;
initial equation
    t_min=tableTimeTmin(tableID);
    t_max=tableTimeTmax(tableID);
  annotation (
    Documentation(info="<html>
<p>This block, derived from the Modelica Standard Library, can read scenarios on a file (see explanation below). The output is a real which may, for example, be connected to a boundary conditions model (prescribing temperature, flow, pressure...).</p>
<p>This block generates an output signal y[:] by <b>linear interpolation</b> in a table. The time points and function values are stored in a matrix <b>table[i,j]</b>, where the first column table[:,1] contains the time points and the other columns contain the data to be interpolated. </p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/CombiTimeTable.png\"/> </p>
<p>Via parameter <b>columns</b> it can be defined which columns of the table are interpolated. If, e.g., columns={2,4}, it is assumed that 2 output signals are present and that the first output is computed by interpolation of column 2 and the second output is computed by interpolation of column 4 of the table matrix. The table interpolation has the following properties: </p>
<ul>
<li>The time points need to be <b>monotonically increasing</b>. </li>
<li><b>Discontinuities</b> are allowed, by providing the same time point twice in the table. </li>
<li>Values <b>outside</b> of the table range, are computed by extrapolation according to the setting of parameter <b>extrapolation</b>: </li>
<pre><span style=\"font-family: Courier New,courier;\">  extrapolation = 0: hold the first or last value of the table,</span>
<span style=\"font-family: Courier New,courier;\">                     if outside of the range.</span>
<span style=\"font-family: Courier New,courier;\">                = 1: extrapolate through the last or first two</span>
<span style=\"font-family: Courier New,courier;\">                     points of the table.</span>
<span style=\"font-family: Courier New,courier;\">                = 2: periodically repeat the table data</span>
<span style=\"font-family: Courier New,courier;\">                     (periodical function).</span></pre>
<li>Via parameter <b>smoothness</b> it is defined how the data is interpolated: </li>
<pre><span style=\"font-family: Courier New,courier;\">  smoothness = 0: linear interpolation</span>
<span style=\"font-family: Courier New,courier;\">             = 1: smooth interpolation with Akima Splines such</span>
<span style=\"font-family: Courier New,courier;\">                  that der(y) is continuous.</span></pre>
<li>If the table has only <b>one row</b>, no interpolation is performed and the table values of this row are just returned.</li>
<li>Via parameters <b>startTime</b> and <b>offset</b> the curve defined by the table can be shifted both in time and in the ordinate value. The time instants stored in the table are therefore <b>relative</b> to <b>startTime</b>. If time &lt; startTime, no interpolation is performed and the offset is used as ordinate value for all outputs. </li>
<li>The table is implemented in a numerically sound way by generating <b>time events</b> at interval boundaries, in order to not integrate over a discontinuous or not differentiable points. </li>
<li>For special applications it is sometimes needed to know the minimum and maximum time instant defined in the table as a parameter. For this reason parameters <b>t_min</b> and <b>t_max</b> are provided and can be access from the outside of the table object. </li>
</ul>
<p>Example: </p>
<pre><span style=\"font-family: Courier New,courier;\">   table = [0  0</span>
<span style=\"font-family: Courier New,courier;\">            1  0</span>
<span style=\"font-family: Courier New,courier;\">            1  1</span>
<span style=\"font-family: Courier New,courier;\">            2  4</span>
<span style=\"font-family: Courier New,courier;\">            3  9</span>
<span style=\"font-family: Courier New,courier;\">            4 16]; extrapolation = 1 (default)</span>
<span style=\"font-family: Courier New,courier;\">If, e.g., time = 1.0, the output y =  0.0 (before event), 1.0 (after event)</span>
<span style=\"font-family: Courier New,courier;\">    e.g., time = 1.5, the output y =  2.5,</span>
<span style=\"font-family: Courier New,courier;\">    e.g., time = 2.0, the output y =  4.0,</span>
<span style=\"font-family: Courier New,courier;\">    e.g., time = 5.0, the output y = 23.0 (i.e. extrapolation via last 2 points).</span></pre>
<p>The table matrix can be defined in the following ways: </p>
<ol>
<li>Explicitly supplied as <b>parameter matrix</b> &quot;table&quot;, and the other parameters have the following values: </li>
<pre><span style=\"font-family: Courier New,courier;\">   tableName is &quot;NoName&quot; or has only blanks,</span>
<span style=\"font-family: Courier New,courier;\">   fileName  is &quot;NoName&quot; or has only blanks.</span></pre>
<li><b>Read</b> from a <b>file</b> &quot;fileName&quot; where the matrix is stored as &quot;tableName&quot;. Both ASCII and binary file format is possible. (the ASCII format is described below). It is most convenient to generate the binary file from Matlab (Matlab 4 storage format), e.g., by command </li>
<pre><span style=\"font-family: Courier New,courier;\">   save tables.mat tab1 tab2 tab3 -V4</span></pre>
<p>when the three tables tab1, tab2, tab3 should be used from the model.</p>
<li>Statically stored in function &quot;usertab&quot; in file &quot;usertab.c&quot;. The matrix is identified by &quot;tableName&quot;. Parameter fileName = &quot;NoName&quot; or has only blanks.</li>
</ol>
<p>Table definition methods (1) and (3) do <b>not</b> allocate dynamic memory, and do not access files, whereas method (2) does. Therefore (1) and (3) are suited for hardware-in-the-loop simulation (e.g. with dSpace hardware). When the constant &quot;NO_FILE&quot; is defined in &quot;usertab.c&quot;, all parts of the source code of method (2) are removed by the C-preprocessor, such that no dynamic memory allocation and no access to files takes place. </p>
<p>If tables are read from an ASCII-file, the file need to have the following structure (&quot;-----&quot; is not part of the file content): </p>
<pre><span style=\"font-family: Courier New,courier;\">-----------------------------------------------------</span>
<span style=\"font-family: Courier New,courier;\">#1</span>
<span style=\"font-family: Courier New,courier;\">double tab1(6,2)   # comment line</span>
<span style=\"font-family: Courier New,courier;\">  0   0</span>
<span style=\"font-family: Courier New,courier;\">  1   0</span>
<span style=\"font-family: Courier New,courier;\">  1   1</span>
<span style=\"font-family: Courier New,courier;\">  2   4</span>
<span style=\"font-family: Courier New,courier;\">  3   9</span>
<span style=\"font-family: Courier New,courier;\">  4  16</span>
<span style=\"font-family: Courier New,courier;\">double tab2(6,2)   # another comment line</span>
<span style=\"font-family: Courier New,courier;\">  0   0</span>
<span style=\"font-family: Courier New,courier;\">  2   0</span>
<span style=\"font-family: Courier New,courier;\">  2   2</span>
<span style=\"font-family: Courier New,courier;\">  4   8</span>
<span style=\"font-family: Courier New,courier;\">  6  18</span>
<span style=\"font-family: Courier New,courier;\">  8  32</span>
<span style=\"font-family: Courier New,courier;\">-----------------------------------------------------</span></pre>
<p>Note, that the first two characters in the file need to be &quot;#1&quot;. Afterwards, the corresponding matrix has to be declared with type, name and actual dimensions. Finally, in successive rows of the file, the elements of the matrix have to be given. Several matrices may be defined one after another. </p>

<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : EDF<br>
Initial model : <a href=\"Modelica.Blocks.Sources.CombiTimeTable\">CombiTimeTable</a>, Martin Otter, Copyright © Modelica Association and DLR.<br>
--------------------------------------------------------------</b></p>
</html>",
 revisions="<html>
<p><b>Release Notes:</b></p>
<ul>
<li><i>March 31, 2001</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Used CombiTableTime as a basis and added the
       arguments <b>extrapolation, columns, startTime</b>.
       This allows periodic function definitions. </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,70},{2,-50}},
          lineColor={255,255,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-48,-50},{-48,70},{52,70},{52,-50},{-48,-50},{-48,-20},
              {52,-20},{52,10},{-48,10},{-48,40},{52,40},{52,70},{2,70},{
              2,-51}}, color={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,90},{20,-30}},
          lineColor={255,255,255},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-20,-30},{-20,90},{80,90},{80,-30},{-20,-30},{-20,0},
              {80,0},{80,30},{-20,30},{-20,60},{80,60},{80,90},{20,90},{
              20,-30}}, color={0,0,0}),
        Text(
          extent={{-71,-42},{-32,-54}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="offset"),
        Polygon(
          points={{-31,-30},{-33,-40},{-28,-40},{-31,-30}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-31,-70},{-34,-60},{-29,-60},{-31,-70},{-31,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-31,-31},{-31,-70}}, color={95,95,95}),
        Line(points={{-20,-30},{-20,-70}}, color={95,95,95}),
        Text(
          extent={{-42,-74},{6,-84}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="startTime"),
        Line(points={{-20,-30},{-80,-30}}, color={95,95,95}),
        Text(
          extent={{-73,93},{-44,74}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(
          extent={{66,-81},{92,-92}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="time"),
        Text(
          extent={{-19,83},{20,68}},
          lineColor={0,0,0},
          textString="time"),
        Text(
          extent={{21,82},{50,68}},
          lineColor={0,0,0},
          textString="y[1]"),
        Line(points={{50,90},{50,-30}}, color={0,0,0}),
        Line(points={{80,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{34,-30},{71,-42}},
          textString="columns",
          lineColor={0,0,255}),
        Text(
          extent={{51,82},{80,68}},
          lineColor={0,0,0},
          textString="y[2]")}));
end CombiTimeTable;
