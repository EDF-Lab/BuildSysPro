within BuildSysPro.BoundaryConditions.Scenarios;
block StepFunctionMat "Step function for data reading"

  Modelica.Blocks.Interfaces.RealInput u
    "Input homogeneous to the first column values of table 1"                               annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[size(columns2,1)]
    "Corresponding values"            annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));

  Modelica.Blocks.Tables.CombiTable1Ds Table1(columns={2},
    tableOnFile=tableOnFile1,
    table=table1,
    tableName=tableName1,
    fileName=fileName1)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Tables.CombiTable1Ds Table2(
    tableOnFile=tableOnFile2,
    table=table2,
    tableName=tableName2,
    fileName=fileName2,
    columns=columns2)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  BuildSysPro.Utilities.Math.IntegerExpression PartieEntiere(y=integer(
        PartieEntiere.u))
    annotation (Placement(transformation(extent={{-6,-20},{34,20}})));
  parameter Boolean tableOnFile1=false
    "true, if table is defined on file or in function usertab"
          annotation(Dialog(group="table1 data definition"));

  parameter Real table1[:,:]=fill(0.0,0,2)
    "table matrix (grid = first column; e.g., table=[0,2])"
      annotation(Dialog(group="table1 data definition", enable = not tableOnFile1));
  parameter String tableName1="NoName"
    "table name on file or in function usertab (see docu)"
          annotation(Dialog(group="table1 data definition", enable = tableOnFile1));

  parameter String fileName1="NoName" "file where matrix is stored"
  annotation(Dialog(group="table1 data definition", enable = tableOnFile1,
                         __Dymola_loadSelector(filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));

  parameter Boolean tableOnFile2=false
    "true, if table is defined on file or in function usertab"
          annotation(Dialog(group="table2 data definition"));

  parameter Real table2[:,:]=fill(0.0,0,2)
    "table matrix (grid = first column; e.g., table=[0,2])"
            annotation(Dialog(group="table2 data definition", enable = not tableOnFile2));

  parameter String tableName2="NoName"
    "table name on file or in function usertab (see docu)"
          annotation(Dialog(group="table2 data definition", enable = tableOnFile2));

  parameter String fileName2="NoName" "file where matrix is stored"
        annotation(Dialog(group="table2 data definition", enable = tableOnFile2,
                         __Dymola_loadSelector(filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));

  parameter Integer columns2[:]=2:size(table2, 2)
    "columns of table to be interpolated"
          annotation(Dialog(group="table2 data definition", enable = tableOnFile2));

equation
  connect(Table1.y[1], PartieEntiere.u) annotation (Line(
      points={{-29,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PartieEntiere.y, Table2.u) annotation (Line(
      points={{36,0},{48,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Table2.y, y) annotation (Line(
      points={{71,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, Table1.u) annotation (Line(
      points={{-120,0},{-52,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-40,40},{-14,20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{-14,0}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,0},{-14,-20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-20},{-14,-40}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,60},{-14,40}},
          lineColor={0,0,255},
          textString="x"),
        Rectangle(
          extent={{-14,40},{12,20}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,20},{12,0}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,0},{12,-20}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,-20},{12,-40}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-14,60},{12,40}},
          lineColor={0,0,255},
          textString="y"),     Rectangle(extent={{-100,100},{100,-100}},
                                                                     lineColor={
              0,0,255}),                                    Line(
          points={{20,0},{40,0},{40,20},{60,20},{60,20},{60,40}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-100,-60},{100,-100}},
          lineColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p><i><b>One-dimension step function defined from file or table.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Via the parameter columns, it can be defined which columns are involved in the calculation. 
For example, if columns = {2,4}, then the model requires one input and 2 outputs. 
The first output is the step function corresponding to the column 2 of the matrix. 
The second output is the step function corresponding to the column 4 of the matrix.</p>
<p>Consider a starting matrix <code>table [i, j]</code> with n rows and m columns where 
the first column is ordered and represents the dependent variable and other columns represent the independent variables.
This table is split into two tables: a first table <code>table1 [i, j]</code> 
with n rows and two columns and a second table <code>table2 [i, j]</code> n rows and m columns.</p>
<p>The first column of table 1 is equal to the first column of the original table.</p>
<p>The second column of table 1 is made up of the natural numbers from 1 to m.</p>
<p>The first column of Table 2 is equal to the second column of table 1.</p>
<p>Columns 2 to m of table 2 are identical to the ones in the original table.</p>

<p><u><b>Example:</b></u></p>
<p>Considering the following matrix:</p>
<pre>   table = [0,  0,  5;
            1,  1,  10;
            2,  4,  7;
            4, 16,  2]</pre>
<p>split into the two following matrixes:</p>
<pre>   table1 = [0,  1;        table2 = [1,  0,  5;
             1,  2;                  2,  1,  10;
             2,  3;                  3,  4,  7;
             4,  4]                  4, 16,  2]</pre>

<p>If, as input, u = 2.6 and columns={3}, the output y = 7 because 2.6 belongs to [2;4[ </p>  

<p>To obtain this, three steps:</p>
<ol>
<li> <code>Table 1</code> gives, by linear interpolation of the second column, <code>y1 = 3.3</code></li>
<li> As input of table 2, the integer part of <code>[y1] = 3</code> is taken </li>
<li> <code>Table 2</code> gives, by linear interpolation of its third column, <code>y2 = 7;</code></li>
</ol>
<p>Note also that:</p>
<ul>
<li>The interpolation is effcient because the search for a new interpolation starts from the last interval used for the previous interpolation</li>
<li>If the table has only one row, its values are returned regardless of the input signal value</li>
<li>If the value of the input signal <code>u</code> is outside the range defined by the first column of the table, for example, u&GT; Table [size (Table, 1), 1] or u &LT;table [1, 1], the corresponding value is determined by linear extrapolation from the first or last two points of the table</li>
<li>The first column must be strictly monotonic</li>
</ul>
<p>A table can be defined as follows:</p>
<ol>
<li>By explicit entry of parameter &QUOT;table&QUOT;, and other parameters must be set as follows:</li>
<pre>   tableName = &QUOT;NoName&QUOT; or with blanks,
   fileName  = &QUOT;NoName&QUOT; or with blanks.</pre>
   <li>By reading a file &QUOT;fileName&QUOT; where the matrix is stored with the name specified in the parameter &QUOT;tableName&QUOT;. Both ASCII and binary formats are possible. See details and additional information in the <a href=\"Modelica.Blocks.Tables.CombiTable1Ds\">Modelica.Blocks.Tables.CombiTable1Ds</a> documentation</li>
</ol>


<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 07/2012 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end StepFunctionMat;
