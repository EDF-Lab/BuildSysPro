within BuildSysPro.Utilities.Types;
type FileNameIn =
              String
  "Type of file to load - open a window to browse this type of file"
                     annotation(Dialog(__Dymola_loadSelector(caption="Ouvrir le fichier suivant")),
      Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
