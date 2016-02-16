within BuildSysPro.BoundaryConditions.Scenarios;
block StepFunctionMatPeriodic
  "Fonction en escalier périodique définie à partir de matrices : tables ou fichiers (H. BOUIA - 07/2012)"

  Modelica.Blocks.Interfaces.RealInput u
    "Entrée homogène aux valeurs de la première colonne de la table 1"                               annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[size(columns2,1)]
    "Valeurs correspondantes"             annotation (Placement(transformation(
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
        PartieEntiere.u + 1e-6))
    annotation (Placement(transformation(extent={{-6,-20},{34,20}})));
  parameter Real periode=20 "Période en unités de X";
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

      Table1.u=mod(u,periode);
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
<p><b>Fonction en escalier périodique</b> à <b>une</b> dimension définie à partir d'une <b>table</b>. Via le paramètre <b>columns</b>, on peut définir quelles colonnes sont concernées par le calcul. Par exemple, si columns={2,4}, alors le modèle nécessite une entrée et 2 sorties. La première sortie est la fonction en escalier correspondant à la colonne 2 de la matrice. La seconde sortie est la fonction en escalier correspondant à la colonne 4 de la matrice. </p>
<p>Considérons une matrice de départ &QUOT;table[i,j]&QUOT; à n ligne et m colonnes où <b>la première colonne est ordonnée</b> et représente la variable dépendante et les autres colonnes représentent les variables indépendantes. </p>
<p>On scinde cette table en deux tables : une première table &QUOT;table1[i,j]&QUOT; à n lignes et deux colonnes et une seconde table &QUOT;table2[i,j]&QUOT; à n lignes et m colonnes. </p>
<p>La première colonne de la table 1 est égale à la première colonne de la table d'origine.</p>
<p>La seconde colonne de la table 1 est constituée des entiers naturels de 1 à m.</p>
<p>La première colonne de la table 2 est égale à la seconde colonne de la table 1.</p>
<p>Les colonnes 2 à m de la table 2 sont identiques à leur homologue de la table d'origine. </p>
<p>Exemple:</p>
<pre><span style=\"font-family: Courier New,courier;\">   On considère la matrice de départ</span>
<span style=\"font-family: Courier New,courier;\">   table = [0,  0,  5;</span>
<span style=\"font-family: Courier New,courier;\">            1,  1,  10;</span>
<span style=\"font-family: Courier New,courier;\">            2,  4,  7;</span>
<span style=\"font-family: Courier New,courier;\">            4, 16,  2]</span>
<span style=\"font-family: Courier New,courier;\">        </span>
<span style=\"font-family: Courier New,courier;\">   scindée en les 2 matrices suivantes :</span>
<span style=\"font-family: Courier New,courier;\">   table1 = [0,  1;        table2 = [1,  0,  5;</span>
<span style=\"font-family: Courier New,courier;\">             1,  2;                  2,  1,  10;</span>
<span style=\"font-family: Courier New,courier;\">             2,  3;                  3,  4,  7;</span>
<span style=\"font-family: Courier New,courier;\">             4,  4]                  4, 16,  2]</span>

<span style=\"font-family: Courier New,courier;\">   Supposons que la période est égale à 5.</span>
<span style=\"font-family: Courier New,courier;\">   Si, en entrée u = 7.6 et columns={3}, la sortie y = 7 car 2.6 appartient à [2 ; 4[</span>
<span style=\"font-family: Courier New,courier;\">        Pour y arriver, 3 étapes :</span>
<span style=\"font-family: Courier New,courier;\">        - Etape 1 : la table 1 fournit, par interpolation linéaire de sa deuxième colonne y1 = 3.3;</span>
<span style=\"font-family: Courier New,courier;\">        - Etape 2 : En entrée de la table 2, on prend la partie entière de [y1] = 3;</span>
<span style=\"font-family: Courier New,courier;\">        - Etape 3 : la table 2 fournit, par interpolation linéaire de sa 3ème colonne y2 = 7;</span></pre>
<ul>
<li>L'interpolation est <b>efficace</b>, car la recherche d'une nouvelle interpolation démarre du dernier intervalle utilisé pour l'interpolation précédente.</li>
<li>Si la table n'a qu'une <b>seule ligne</b>, les valeurs de la tables sont retournées, independamment de la valeur du signel en entrée.</li>
<li>Si la valeur du signal entranr <b>u</b> est <b>à l'extérieur</b> de l'<b>intervalle</b> défini par à travers la première colonne de la table, par exemple,u &GT; table[size(table,1),1] or u &LT; table[1,1], la valeur correspondante est déterminée extrapolation linéaire à partir des 2 derniers ou premiers points de la table.</li>
<li>La première colonne doit être <b>strictement</b> monotone.</li>
</ul>
<p>Une table peut être définie comme suit : </p>
<ol>
<li>Explicitement par saisie du <b>paramètre</b> &QUOT;table&QUOT;, et les autres paramètres doivent être définis comme suit : </li>
<pre><span style=\"font-family: Courier New,courier;\">   tableName = &QUOT;NoName&QUOT; ou avec des blancs,</span>
<span style=\"font-family: Courier New,courier;\">   fileName  = &QUOT;NoName&QUOT; ou avec des blancs.</span></pre>
<li>Par <b>lecture</b> d'un <b>fichier</b> &QUOT;fileName&QUOT; où est stockée la matrice avec le nom indiqué dans le paramètre &QUOT;tableName&QUOT;. Les deux formats ASCII et binaire sont possibles. Voir détails et compléments dans la documentation du modèle <a href=\"Modelica.Blocks.Tables.CombiTable1Ds\">Modelica.Blocks.Tables.CombiTable1Ds</a> </li>
</ol>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Hassan Bouia 07/2012 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end StepFunctionMatPeriodic;
