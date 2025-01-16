within BuildSysPro.Utilities.Analysis;
model DHWQueue "Domestic hot water drawing queue"

  parameter Modelica.Units.SI.Time MaxDelay=7200
    "Maximum time delay for a drawing waiting in the DHW queue";
  parameter Integer QueueSize = 5 "Maximum number of drawings in the DHW queue at any moment";
  Modelica.Blocks.Interfaces.RealInput ExpDrawingTemp
    "Temperature of expected planned and unplanned DHW drawings [temperature in °K if drawing, 0 if not]"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-128,46},{-100,74}})));
  Modelica.Blocks.Interfaces.RealOutput EffDrawingTemp
    "Temperature of effective DHW drawings after arbitration process [temperature in °K if drawing, 0 if not]"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,46},{128,74}})));
  Modelica.Blocks.Interfaces.RealInput WaterTankTemp
    "Water tank temperature [°K]"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealInput ExpDrawingRate
    "Drawing rate of expected planned and unplanned DHW drawings [rate in kg/s if drawing, 0 if not]"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-128,-74},{-100,-46}})));
  Modelica.Blocks.Interfaces.RealOutput EffDrawingRate
    "Drawing rate of effective DHW drawings after arbitration process [rate in kg/s if drawing, 0 if not]"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-74},{128,-46}})));

  final Integer NbTotal(start = 0, fixed = true) "Total number of drawings processed";
  final Integer NbNoDelay(start = 0, fixed = true) "Number of drawings processed instantly";
  final Integer NbWithin30Min(start = 0, fixed = true) "Number of drawings processed within 30 minutes";
  final Integer NbWithin60Min(start = 0, fixed = true) "Number of drawings processed within 60 minutes";
  final Integer NbMoreThan60Min(start = 0, fixed = true) "Number of drawings processed within more than 60 minutes";
  final Real PercNoDelay(start = 0, fixed = true) "Percentage of drawings processed instantly";
  final Real PercWithin30Min(start = 0, fixed = true) "Percentage of drawings processed within 30 minutes";
  final Real PercWithin60Min(start = 0, fixed = true) "Percentage of drawings processed within 60 minutes";
  final Real PercMoreThan60Min(start = 0, fixed = true) "Percentage of drawings processed within more than 60 minutes";

protected
  discrete Real LastExpRate(start=0.0) "Last value of expected drawing rate at any moment";
  discrete Real CurrentExpTemp(start=0.0) "Current value of expected temperature at any moment";
  discrete Real QueueTemp[QueueSize](each start = 0.0, each fixed = true) "Needed temperature of drawings in the queue";
  discrete Real QueueRate[QueueSize](each start = 0.0, each fixed = true) "Drawing rate of drawings in the queue";
  discrete Real QueueDuration[QueueSize](each start = 0.0, each fixed = true) "Expected duration of drawings in the queue";
  discrete Real QueueInOut[QueueSize](each start = 0.0, each fixed = true) "In/out time of drawings in the queue";
  discrete Integer QueueComplete[QueueSize](each start = 0, each fixed = true) "State of drawings in the queue";
  Integer n(start = 0, fixed = true) "Position in the queue of the next drawing to put";
  Integer m(start = 0, fixed = true) "Number of drawings in the queue at any moment";
  Integer p(start = 0, fixed = true) "Number of incomplete drawings in the queue at any moment";
  DetectChange        ExpChange(eps=0.01) "Block to detect a change in the expected drawing rate signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

algorithm
  // When a change is detected in the expected drawing rate input signal
  when ExpChange.change == true then
    // If there is already an expected drawing in process, close this drawing
    if LastExpRate > 0 then
      // If this expected drawing to close is a delayed drawing waiting to be completed, complete this drawing
      if p > 0 then
        EffDrawingTemp := EffDrawingTemp;
        EffDrawingRate := EffDrawingRate;
        for i in 1:QueueSize loop
          if QueueInOut[i] > 0.01 and QueueComplete[i] == 0 then
            QueueDuration[i] := integer(time) - QueueInOut[i];
            QueueComplete[i] := 1;
            p := p - 1;
          end if;
        end for;
      // Else, close this undelayed expected drawing
      else
        EffDrawingTemp := max(if QueueComplete[i] == 2 then QueueTemp[i] else 0 for i in 1:QueueSize);
        EffDrawingRate := EffDrawingRate - LastExpRate;
      end if;
    end if;
    // If a new expected drawing is beginning
    if ExpDrawingRate > 0 then
      // If this new expected drawing can be processed instantly (needed temperature is available), process this drawing
      if WaterTankTemp >= ExpDrawingTemp or m == QueueSize then
        EffDrawingTemp := max(EffDrawingTemp,ExpDrawingTemp);
        EffDrawingRate := EffDrawingRate + ExpDrawingRate;
        NbTotal := NbTotal + 1;
        NbNoDelay := NbNoDelay + 1;
      // Else, delay this new expected drawing
      else
        EffDrawingTemp := EffDrawingTemp;
        EffDrawingRate := EffDrawingRate;
        n := if n == QueueSize then 1 else n + 1;
        m := m + 1;
        p := p + 1;
        QueueTemp := {if i <> n then QueueTemp[i] else ExpDrawingTemp for i in 1:QueueSize};
        QueueRate := {if i <> n then QueueRate[i] else ExpDrawingRate for i in 1:QueueSize};
        QueueInOut := {if i <> n then QueueInOut[i] else integer(time) for i in 1:QueueSize};
      end if;
    end if;
    CurrentExpTemp := ExpDrawingTemp;
  end when;
  // Update previous timestamp indicators
  when ExpChange.change == false then
    LastExpRate := ExpDrawingRate;
    CurrentExpTemp := ExpDrawingTemp;
  end when;
  // If there are delayed drawings waiting in the queue
  if m > 0 then
    // For each drawing in the queue
    for i in 1:QueueSize loop
      // If the delayed drawing is being processed
      if QueueComplete[i] == 2 then
        // If the total expected duration of the drawing is reached, then stop processing this drawing
        if QueueInOut[i] <= time then
          QueueComplete[i] := 0;
          EffDrawingTemp := max(if QueueComplete[i] == 2 then QueueTemp[i] else 0 for i in 1:QueueSize);
          EffDrawingTemp := max(EffDrawingTemp,CurrentExpTemp);
          EffDrawingRate := EffDrawingRate - QueueRate[i];
          QueueTemp[i] := 0;
          QueueRate[i] := 0;
          QueueDuration[i] := 0;
          QueueInOut[i] := 0;
          m := m - 1;
        end if;
      end if;
      // If the delayed drawing is complete (expected duration is known)
      if QueueComplete[i] == 1 then
        // If the needed temperature is available in the water tank or if the maximum delay time is reached for this drawing, then begin processing it
        if WaterTankTemp >= QueueTemp[i] or time >= (QueueInOut[i] + MaxDelay) then
          EffDrawingTemp := max(EffDrawingTemp,QueueTemp[i]);
          EffDrawingRate := EffDrawingRate + QueueRate[i];
          NbTotal := NbTotal + 1;
          if (time - QueueInOut[i]) <= 1800 then
            NbWithin30Min := NbWithin30Min +1;
          elseif (time - QueueInOut[i]) <= 3600 then
            NbWithin60Min := NbWithin60Min + 1;
          else
            NbMoreThan60Min := NbMoreThan60Min + 1;
          end if;
          QueueInOut[i] := integer(time) + QueueDuration[i];
          QueueComplete[i] := 2;
        end if;
      end if;
    end for;
  end if;
  // Key performance indicators calculation
  if NbTotal == 0 then
    PercNoDelay := 0;
    PercWithin30Min := 0;
    PercWithin60Min := 0;
    PercMoreThan60Min := 0;
  else
    PercNoDelay := NbNoDelay / NbTotal * 100;
    PercWithin30Min := NbWithin30Min / NbTotal * 100;
    PercWithin60Min := NbWithin60Min / NbTotal * 100;
    PercMoreThan60Min := NbMoreThan60Min / NbTotal * 100;
  end if;



equation
  connect(ExpDrawingRate, ExpChange.signal) annotation (Line(points={{-120,-60},
          {-62,-60},{-62,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,86},{32,86},{-12,-36},{82,-34},{38,86}},
          lineColor={28,108,200},
          smooth=Smooth.Bezier,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-64,-58},{-64,-58}},
          lineColor={28,108,200},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-92,-58},{-92,-58}},
          lineColor={95,95,95},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-72,6},{-28,6},{-36,-36},{-64,-36},{-72,6}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-72,-78},{-28,-78},{-36,-36},{-64,-36},{-72,-78}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-66,-20},{-34,-20},{-50,-34},{-66,-20}},
          smooth=Smooth.Bezier,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-74,-66},{-74,-78},{-26,-78},{-26,-66},{-74,-66}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,7},{-74,-5},{-26,-5},{-26,7},{-74,7}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,112},{102,142}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=300),
    Documentation(info="<html>
<p>This model performs a trial and error process to draw hot water when needed if tank temperature is sufficient or to postpone the drawing.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>For each drawing, the model compares the needed drawing temperature and the available tank temperature.</p>
<p>If the needed temperature is available in the tank, the drawing is processed, else the drawing is delayed, waiting the needed temperature to be available.</p>
<p>The parameter <code>MaxDelay</code> allows to define a maximum delay time in the DHW queue. For a delayed drawing, if the maximum delay time is reached, the drawing is processed, even if the needed temperature is not available in the tank.</p>
<p>The parameter <code>QueueSize</code> allows to define a size for the DHW queue. If the queue is full, all the drawings will be processed instantly even if the needed temperature is not available in the tank.</p>
<p><b>Pseudo code of the algorithm</b></p>
<p><code>If a change is detected in the input drawing rate scenario then<br>
&nbsp;&nbsp;&nbsp;If there is already an expected drawing being processed then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If this expected drawing being processed is a delayed drawing waiting to be completed (i.e. total duration is still not known) then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Complete this drawing (i.e. store its total duration), so that it is ready to be processed when the needed temperature is available<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Else<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Close this undelayed expected drawing<br>
&nbsp;&nbsp;&nbsp;If a new expected drawing is beginning then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If this new expected drawing can be processed instantlty (i.e. needed temperature is available) then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Start processing this drawing<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update key performance indicators<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Else<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delay this drawing and wait to know its total duration<br>
For each complete delayed drawing in the queue then<br>
&nbsp;&nbsp;&nbsp;If the needed temperature is available or if the maximum delay time is reached for this delayed drawing then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Start processing the delayed drawing<br>
&nbsp;&nbsp;&nbsp;Else if the delayed drawing is being processed and the needed time duration of the drawing is reached then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Stop processing the delayed drawing<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete the drawing from the queue<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Update key performance indicators</code></p>
<p><b>Key performance indicators calculation</b><p>
<p>For each drawing, a time comparison between expected drawing time and effective drawing time is made to increment one of these counters:
<ul><li>Number of drawings delivered instantly</li>
<li>Number of drawings processed within 30 minutes</li>
<li>Number of drawings processed within 60 minutes</li>
<li>Number of drawings processed within more than 60 minutes</li></ul></p>
<p>Then percentage indicators <code>PercNoDelay</code>, <code>PercWithin30Min</code>, <code>PercWithin60Min</code>, <code>PercMoreThan60Min</code> are calculated from the counters above.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The model is not able to deal with multiple drawings at the same time. When a new drawing is detected, the previous one is considered as closing.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 09/16</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end DHWQueue;
