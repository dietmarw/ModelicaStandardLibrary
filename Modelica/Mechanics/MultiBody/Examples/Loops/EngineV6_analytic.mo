model EngineV6_analytic 
  "V6 engine with 6 cylinders, 6 planar loops, 1 degree-of-freedom and analytic handling of kinematic loops" 
  
  import Cv = Modelica.SIunits.Conversions;
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Example;
  parameter Boolean animation=true "= true, if animation shall be enabled";
  output Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm 
    engineSpeed_rpm=
         Modelica.SIunits.Conversions.to_rpm(load.w) "Engine speed";
  output Modelica.SIunits.Torque engineTorque = filter.u 
    "Torque generated by engine";
  output Modelica.SIunits.Torque filteredEngineTorque = filter.y 
    "Filtered torque generated by engine";
  
  inner Modelica.Mechanics.MultiBody.World world(animateWorld=false,
      animateGravity =                                                              false) 
    annotation (extent=[-80,-20; -60,0]);
  Utilities.EngineV6_analytic engine(redeclare model Cylinder = 
        Modelica.Mechanics.MultiBody.Examples.Loops.Utilities.Cylinder_analytic_CAD)
    annotation (extent=[-40,0; 0,40]);
  Modelica.Mechanics.Rotational.Inertia load(phi(
      start=0,
      fixed=true,
      stateSelect=StateSelect.always), w(
      start=10,
      fixed=true,
      stateSelect=StateSelect.always)) annotation (extent=[40, 10; 60, 30]);
  Rotational.QuadraticSpeedDependentTorque load2(tau_nominal=-100, w_nominal=
        200) annotation (extent=[90,10; 70,30]);
  Rotational.Sensors.TorqueSensor torqueSensor
    annotation (extent=[12,10; 32,30]);
  Blocks.Continuous.CriticalDamping filter(
    n=2,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y(redeclare type SignalType = Modelica.SIunits.Torque),
    f=5) annotation (extent=[30,-20; 50,0]);
equation 
  
  annotation (
    Diagram,
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[2, 2],
      component=[20, 20]),
    Documentation(info="<HTML>
<p>
This is a similar model as the example \"EngineV6\". However, the cylinders
have been built up with component Modelica.Mechanics.MultiBody.Joints.Assemblies.JointRRR that
solves the non-linear system of equations in an aggregation of 3 revolution
joints <b>analytically</b> and only one body is used that holds the total
mass of the crank shaft:
</p>
<p align=\"center\">
<IMG SRC=\"../Images/MultiBody/Examples/Loops/EngineV6_CAD_small.png\">
</p>
<p>
This model is about 20 times faster as the EngineV6 example and <b>no</b> linear or
non-linear system of equations occur. In contrast, the \"EngineV6\" example
leads to 6 systems of nonlinear equations (every system has dimension = 5, with 
Evaluate=false and dimension=1 with Evaluate=true) and a linear system of equations 
of about 40. This shows the power of the analytic loop handling.
</p>

<p>
Simulate for 5 s, and plot the variables <b>engineSpeed_rpm</b>,
<b>engineTorque</b>, and <b>filteredEngineTorque</b>. Note, the result file has
a size of about 50 Mbyte (for 5000 output intervalls).
</p>
</HTML>
"), 
    experiment(StopTime=5, NumberOfIntervals=5000), 
    experimentSetupOutput);
  connect(world.frame_b, engine.frame_a) 
    annotation (points=[-60,-10; -20,-10; -20,-0.2],
                                                 style(
      color=10,
      rgbcolor={95,95,95},
      thickness=2));
  connect(load2.flange, load.flange_b)
    annotation (points=[70,20; 60,20], style(color=0, rgbcolor={0,0,0}));
  connect(torqueSensor.flange_a, engine.flange_b)
    annotation (points=[12,20; 2,20], style(color=0, rgbcolor={0,0,0}));
  connect(torqueSensor.flange_b, load.flange_a)
    annotation (points=[32,20; 40,20], style(color=0, rgbcolor={0,0,0}));
  connect(torqueSensor.tau, filter.u) annotation (points=[14,9; 14,-10; 28,-10], 
      style(color=74, rgbcolor={0,0,127}));
end EngineV6_analytic;
