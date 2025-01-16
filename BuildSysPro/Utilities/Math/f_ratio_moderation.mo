within BuildSysPro.Utilities.Math;
function f_ratio_moderation "Moderation ratio function"

  input Real x, a, b, c;
  output Real y;

algorithm

  if x <= a then // Text=x et Text_bas=a
    y:=0; // y = Mod_ext_man
  elseif x>a and x<= b then // b  = Text_haut
    y:=(x - a)/(b - a);
  elseif x>b then
   if x<=c then // c=Top_moy(h-1)-DText_int
     y:=1;
   else   //else // Attention : Discontinuité !!!
     y:=0;
   end if;
  end if;

  annotation (Documentation(info="<html>
<p><i><b> Moderation ratio</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
none
<p><u><b>Bibliography</b></u></p>
<p>Take note of the documentation: see « C_Bat_gestion/régulation de l'ouverture des baies» in \"\\BuildSysPro\\Resources\\Documentation\\Annexe-arrete-methode-de-calcul-TH-B-C-E-2012-CSTB.pdf\" and \"\\BuildSysPro\\ResourcesDocumentation\\Methodo pour ajout PM et ouverture de baie.pdf\" </p>
<p><u><b>Instructions for use</b></u></p>
<p>none.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia, 07/2024</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Hassan Bouia, Kods GRISSA NACIB EDF (2024)<br>
--------------------------------------------------------------</b></p>
</html>"));
end f_ratio_moderation;
