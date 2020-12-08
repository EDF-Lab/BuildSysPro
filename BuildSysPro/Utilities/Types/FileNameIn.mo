within BuildSysPro.Utilities.Types;
type FileNameIn =
              String
  "Type of file to load - open a window to browse this type of file"
                     annotation(Dialog(__Dymola_loadSelector(caption="Load the file")),
      Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
