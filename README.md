# ![BuildSysPro](https://raw.githubusercontent.com/EDF-TREE/BuildSysPro/master/BuildSysPro/Resources/Images/Logo-BuildSysPro.png)
*BuildSysPro open source* is [EDF](https://www.edf.fr/en/the-edf-group/who-we-are/activities/research-and-development)'s Modelica library for buildings, districts and energy systems modelling. This is BuildSysPro's official repository.

### Release updates
Current release is version 3.4.0.

This release provides :
- Correction of surface exchange coefficient on walls: standardization of all the record with values in agreement with ISO6946
- Correction of the number of layers in the wall data: discretisation using Martin’s method.
- Adding internal doors on the Mozart buildings (monozone and multizone).
- Adding internal doors on the Matisse apartment (monozone and multizone).
- other minor error corrections

EDF is part of [IBPSA Project 1](https://ibpsa.github.io/project1/), and the [IBPSA library](https://github.com/ibpsa/modelica-ibpsa) is now integrated to BuildSysPro open source 3.4.0.

BuildSysPro open source 3.4.0 is compatible with OpenModelica 1.9.3. When working with OpenModelica, specify your initial conditions carefully and use preferably Dassl, Euler or Runge-Kutta solvers.

### License
The BuildSysPro open source library is licensed by EDF under the [3-Clause BSD-License](https://opensource.org/licenses/BSD-3-Clause).

### Documentation
A set of [self-training documents](https://github.com/edf-enerbat/buildsyspro-doc) for the BuildSysPro open source library is available.

### References
1. Plessis G., Kaemmerlen A., Lindsay A. (2014) [BuildSysPro: a Modelica library for modelling buildings and energy systems](https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP140961161_PlessisKaemmerlenLindsay.pdf). Modelica Conference 2014.
2. Schumann M. (2015) [Vers une plate-forme de modélisation du bâtiment au quartier multiphysique avec Modelica et BuildSysPro](http://ibpsa.fr/jdownloads/Simurex/2015/Presentations/29_01_mathieuschumann.pdf) (*Towards a multiphysics modelling platform for buildings and districts with Modelica and BuildSysPro*), IBPSA France SIMUREX 2015 Conference.


