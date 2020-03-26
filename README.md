# ![BuildSysPro](https://raw.githubusercontent.com/EDF-TREE/BuildSysPro/master/BuildSysPro/Resources/Images/Logo-BuildSysPro.png)
*BuildSysPro open source* is [EDF](https://www.edf.fr/en/the-edf-group/who-we-are/activities/research-and-development)'s Modelica library for buildings, districts and energy systems modelling. This is BuildSysPro's official repository.

### Release updates
Current release is version 3.3.0.

This release provides :
- update of the IBPSA library to its 3.0.0 version
- adding a new function U_wall to calculate the U-value from the wall composition and surface heat transfer coefficients
- new record *h_surf_ISO6946* with a set of surface heat transfer coefficients from ISO6946
- new model based on PID for a flexible calculation of heating and/or cooling needs (PIDSingleOrDualMode)
- license change to 3-clause BSD-license
- other minor error corrections


EDF is part of [IBPSA Project 1](https://ibpsa.github.io/project1/), and the [IBPSA library](https://github.com/ibpsa/modelica-ibpsa) is now integrated to BuildSysPro open source 3.3.0.

BuildSysPro open source 3.3.0 is compatible with OpenModelica 1.9.3. When working with OpenModelica, specify your initial conditions carefully and use preferably Dassl, Euler or Runge-Kutta solvers.

### License
The BuildSysPro open source library is licensed by EDF under the [3-Clause BSD-License](https://opensource.org/licenses/BSD-3-Clause).

### Documentation
A set of [self-training documents](https://github.com/edf-enerbat/buildsyspro-doc) for the BuildSysPro open source library is available.

### References
1. Plessis G., Kaemmerlen A., Lindsay A. (2014) [BuildSysPro: a Modelica library for modelling buildings and energy systems](https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP140961161_PlessisKaemmerlenLindsay.pdf). Modelica Conference 2014.
2. Schumann M. (2015) [Vers une plate-forme de modélisation du bâtiment au quartier multiphysique avec Modelica et BuildSysPro](http://ibpsa.fr/jdownloads/Simurex/2015/Presentations/29_01_mathieuschumann.pdf) (*Towards a multiphysics modelling platform for buildings and districts with Modelica and BuildSysPro*), IBPSA France SIMUREX 2015 Conference.


