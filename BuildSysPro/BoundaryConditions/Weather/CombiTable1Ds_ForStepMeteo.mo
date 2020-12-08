﻿within BuildSysPro.BoundaryConditions.Weather;
block CombiTable1Ds_ForStepMeteo
  "Table look-up in one dimension (matrix/file) with one input and n outputs"
  extends Modelica.Blocks.Interfaces.SIMO(final nout=size(columns, 1));
  parameter Boolean tableOnFile=false
    "= true, if table is defined on file or in function usertab"
    annotation (Dialog(group="Table data definition"));
  parameter Real table[:, :] = fill(0.0, 0, 2)
    "Table matrix (grid = first column; e.g., table=[0,2])"
    annotation (Dialog(group="Table data definition",enable=not tableOnFile));
  parameter String tableName="NoName"
    "Table name on file or in function usertab (see docu)"
    annotation (Dialog(group="Table data definition",enable=tableOnFile));
  parameter String fileName="NoName" "File where matrix is stored"
    annotation (Dialog(
      group="Table data definition",
      enable=tableOnFile,
      loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  parameter Boolean verboseRead=true
    "= true, if info message that file is loading is to be printed"
    annotation (Dialog(group="Table data definition",enable=tableOnFile));
  parameter Integer columns[:]=2:size(table, 2)
    "Columns of table to be interpolated"
    annotation (Dialog(group="Table data interpretation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation"
    annotation (Dialog(group="Table data interpretation"));

  parameter Real delta_t=3600 "Constant time step of the file in [s]";
  parameter Integer option[nout]=fill(1,nout)
    "=0 if piecewise constant function";
  Real u1=integer(u/delta_t)*delta_t+delta_t/2;

protected
  Modelica.Blocks.Types.ExternalCombiTable1D tableID=
      Modelica.Blocks.Types.ExternalCombiTable1D(
        if tableOnFile then tableName else "NoName",
        if tableOnFile and fileName <> "NoName" and not Modelica.Utilities.Strings.isEmpty(fileName) then fileName else "NoName",
        table,
        columns,
        smoothness) "External table object";
  parameter Real tableOnFileRead(fixed=false)
    "= 1, if table was successfully read from file";

  function readTableData "Read table data from ASCII text or MATLAB MAT-file"
    extends Modelica.Icons.Function;
    input Modelica.Blocks.Types.ExternalCombiTable1D tableID;
    input Boolean forceRead = false
      "= true: Force reading of table data; = false: Only read, if not yet read.";
    input Boolean verboseRead
      "= true: Print info message; = false: No info message";
    output Real readSuccess "Table read success";
    external"C" readSuccess = ModelicaStandardTables_CombiTable1D_read(tableID, forceRead, verboseRead)
      annotation (Library={"ModelicaStandardTables"});
  end readTableData;

  function getTableValue "Interpolate 1-dim. table defined by matrix"
    extends Modelica.Icons.Function;
    input Modelica.Blocks.Types.ExternalCombiTable1D tableID;
    input Integer icol;
    input Real u;
    input Real tableAvailable
      "Dummy input to ensure correct sorting of function calls";
    output Real y;
    external"C" y = ModelicaStandardTables_CombiTable1D_getValue(tableID, icol, u)
      annotation (Library={"ModelicaStandardTables"});
    annotation (derivative(noDerivative=tableAvailable) = getDerTableValue);
  end getTableValue;

  function getTableValueNoDer
    "Interpolate 1-dim. table defined by matrix (but do not provide a derivative function)"
    extends Modelica.Icons.Function;
    input Modelica.Blocks.Types.ExternalCombiTable1D tableID;
    input Integer icol;
    input Real u;
    input Real tableAvailable
      "Dummy input to ensure correct sorting of function calls";
    output Real y;
    external"C" y = ModelicaStandardTables_CombiTable1D_getValue(tableID, icol, u)
      annotation (Library={"ModelicaStandardTables"});
  end getTableValueNoDer;

  function getDerTableValue
    "Derivative of interpolated 1-dim. table defined by matrix"
    extends Modelica.Icons.Function;
    input Modelica.Blocks.Types.ExternalCombiTable1D tableID;
    input Integer icol;
    input Real u;
    input Real tableAvailable
      "Dummy input to ensure correct sorting of function calls";
    input Real der_u;
    output Real der_y;
    external"C" der_y = ModelicaStandardTables_CombiTable1D_getDerValue(tableID, icol, u, der_u)
      annotation (Library={"ModelicaStandardTables"});
  end getDerTableValue;

initial algorithm
  if tableOnFile then
    tableOnFileRead := readTableData(tableID, false, verboseRead);
  else
    tableOnFileRead := 1.;
  end if;
equation
  if tableOnFile then
    assert(tableName <> "NoName",
      "tableOnFile = true and no table name given");
  else
    assert(size(table, 1) > 0 and size(table, 2) > 0,
      "tableOnFile = false and parameter table is an empty matrix");
  end if;
  if smoothness == Modelica.Blocks.Types.Smoothness.ConstantSegments then
    for i in 1:nout loop
      y[i] = getTableValueNoDer(tableID, i, u, tableOnFileRead);
    end for;
  else
    for i in 1:nout loop
      //y[i] = getTableValue(tableID, i, u, tableOnFileRead);
      y[i] = getTableValue(tableID, i, if option[i]==0 then u1 else u, tableOnFileRead);
    end for;
  end if;
  annotation (
    Documentation(info="<html>
<p><i><b>Modification of CombiTable1Ds Modelica model in order to have a piecewise constant function adapted to meteorological data files</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p><b>Constant piecewise interpolation</b> in <b>one</b> dimension of a <b>table</b>. Via parameter <b>columns</b> it can be defined how many columns of the table are interpolated. If, e.g., icol={2,4}, it is assumed that one input and 2 output signals are present and that the first output interpolates via column 2 and the second output interpolates via column 4 of the table matrix. </p>
<p>Notes:</p>
<ul>
<li>The interpolation is <b>efficient</b>, because a search for a new interpolation starts at the interval used in the last call.</li>
<li>If the table has only <b>one row</b>, the table value is returned, independent of the value of the input signal.</li>
<li>If the input signal <b>u</b> is <b>outside</b> of the defined <b>interval</b>, i.e., u &gt; table[size(table,1),1] or u &lt; table[1,1], the corresponding value is also determined by linear interpolation through the last or first two points of the table.</li>
<li>The grid values (first column) have to be strictly increasing.</li>
</ul>

<p><u><b>Bibliography</b></u></p>
<p>Derived from the <a href=\"modelica://Modelica.Blocks.Tables.CombiTable1Ds\">Modelica.Blocks.Tables.CombiTable1Ds model </a>.</p>
<p><u><b>Instructions for use</b></u></p>

<p>The grid points and function values are stored in a matrix &quot;table[i,j]&quot;, where the first column &quot;table[:,1]&quot; contains the grid points and the other columns contain the data to be interpolated. Example: </p>
<pre>   table = [0,  0;
            1,  1;
            2,  4;
            4, 16]
   If, e.g., the input u = 1.0, the output y =  1.0,
       e.g., the input u = 1.5, the output y =  2.5,
       e.g., the input u = 2.0, the output y =  4.0,
       e.g., the input u =-1.0, the output y = -1.0 (i.e., extrapolation).</pre>

<p>The table matrix can be defined in the following ways: </p>
<ol>
<li>Explicitly supplied as <b>parameter matrix</b> &quot;table&quot;, and the other parameters have the following values: </li>
<pre>   tableName is &quot;NoName&quot; or has only blanks,
   fileName  is &quot;NoName&quot; or has only blanks.</pre>
<li> <b>Read</b> from a <b>file</b> &quot;fileName&quot; where the matrix is stored as &quot;tableName&quot;. Both ASCII and MAT-file format is possible. (The ASCII format is described below). The MAT-file format comes in four different versions: v4, v6, v7 and v7.3. The library supports at least v4, v6 and v7 whereas v7.3 is optional. It is most convenient to generate the MAT-file from FreeMat or MATLAB&reg; by command </li>
<pre>   save tables.mat tab1 tab2 tab3</pre>
<p>or Scilab by command </p>
<pre>   savematfile tables.mat tab1 tab2 tab3</pre>
<p>when the three tables tab1, tab2, tab3 should be used from the model.</p>
<p>Note, a fileName can be defined as URI by using the helper function <a href=\"modelica://Modelica.Utilities.Files.loadResource\">loadResource</a>.</p>
<li>Statically stored in function &quot;usertab&quot; in file &quot;usertab.c&quot;. The matrix is identified by &quot;tableName&quot;. Parameter fileName = &quot;NoName&quot; or has only blanks. Row-wise storage is always to be preferred as otherwise the table is reallocated and transposed. See the <a href=\"modelica://Modelica.Blocks.Tables\">Tables</a> package documentation for more details.</li>
</ol>

<p>When the constant &quot;NO_FILE_SYSTEM&quot; is defined, all file I/O related parts of the source code are removed by the C-preprocessor, such that no access to files takes place. </p>
<p>If tables are read from an ASCII-file, the file needs to have the following structure (&quot;-----&quot; is not part of the file content): </p>
<pre>-----------------------------------------------------
#1
double tab1(5,2)   # comment line
  0   0
  1   1
  2   4
  3   9
  4  16
double tab2(5,2)   # another comment line
  0   0
  2   2
  4   8
  6  18
  8  32
-----------------------------------------------------</pre>
<p>Note, that the first two characters in the file need to be &quot;#1&quot; (a line comment defining the version number of the file format). Afterwards, the corresponding matrix has to be declared with type (= &quot;double&quot; or &quot;float&quot;), name and actual dimensions. Finally, in successive rows of the file, the elements of the matrix have to be given. The elements have to be provided as a sequence of numbers in row-wise order (therefore a matrix row can span several lines in the file and need not start at the beginning of a line). Numbers have to be given according to C syntax (such as 2.3, -2, +2.e4). Number separators are spaces, tab ( ), comma (,), or semicolon (;). Several matrices may be defined one after another. Line comments start with the hash symbol (#) and can appear everywhere. Other characters, like trailing non comments, are not allowed in the file. </p>
<p>MATLAB is a registered trademark of The MathWorks, Inc. </p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.4.0<br>
Author : Hassan BOUIA, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>12/2014 H. Bouia, A. Lindsay : modification du modèle CombiTable1Ds de Modelica afin que la fonction en escaliers corresponde bien à ce qu'on attend en sortie d'un fichier météo</p>
</html>"),
    Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}},
      initialScale=0.1),
      graphics={
    Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
    Line(points={{0.0,40.0},{0.0,-40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,20.0},{-30.0,40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,0.0},{-30.0,20.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-20.0},{-30.0,0.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-40.0},{-30.0,-20.0}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Line(points={{-100,0},{-58,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-100,100},{100,64}},
          textString="1 dimensional linear table interpolation",
          lineColor={0,0,255}),
        Line(points={{-54,40},{-54,-40},{54,-40},{54,40},{28,40},{28,-40},{-28,
              -40},{-28,40},{-54,40},{-54,20},{54,20},{54,0},{-54,0},{-54,-20},
              {54,-20},{54,-40},{-54,-40},{-54,40},{54,40},{54,-40}}, color={
              0,0,0}),
        Line(points={{0,40},{0,-40}}, color={0,0,0}),
        Rectangle(
          extent={{-54,40},{-28,20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,20},{-28,0}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,0},{-28,-20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,-20},{-28,-40}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-52,56},{-34,44}},
          textString="u",
          lineColor={0,0,255}),
        Text(
          extent={{-22,54},{2,42}},
          textString="y[1]",
          lineColor={0,0,255}),
        Text(
          extent={{4,54},{28,42}},
          textString="y[2]",
          lineColor={0,0,255}),
        Text(
          extent={{0,-40},{32,-54}},
          textString="columns",
          lineColor={0,0,255})}));
end CombiTable1Ds_ForStepMeteo;
