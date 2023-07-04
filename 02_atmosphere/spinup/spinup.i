#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            SIMULATION CONTROL         #
#.......................................#
time.stop_time                           = 3601.0             # Max (simulated) time to evolve [s]
time.max_step                            = -1          # Max number of time steps; -1 means termination set by timestamps
time.fixed_dt                            = 0.5        # Use this constant dt if > 0
time.cfl                                 = 0.95         # CFL factor

time.plot_interval                       = 1800       # Steps between plot files
time.checkpoint_interval                 = 1800       # Steps between checkpoint files
#ABL.bndry_file                           = bndry_file.native
#ABL.bndry_io_mode                        = 0          # 0 = write, 1 = read
#ABL.bndry_planes                         = ylo xlo
#ABL.bndry_output_start_time              = 3600.0
#ABL.bndry_var_names                      = velocity temperature tke

incflo.physics                           = ABL # Actuator
#io.restart_file                          = ../spinup/chk07200   
incflo.use_godunov                       = 1
incflo.godunov_type                      = weno_z                 
turbulence.model                         = OneEqKsgsM84  # For neutral ABL, use "Smagorinsky"
TKE.source_terms                         = KsgsM84Src
TKE.interpolation                        = PiecewiseConstant          
incflo.gravity                           = 0.  0. -9.81  # Gravitational force (3D)
incflo.density                           = 1.225          # Reference density; make sure this agrees with OpenFAST values
transport.viscosity                      = 1.0e-5
transport.laminar_prandtl                = 0.7
transport.turbulent_prandtl              = 0.3333

incflo.verbose                           =   0          # incflo_level

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            GEOMETRY & BCs             #
#.......................................#
geometry.prob_lo                         = 0.       0.     0.  # Lo corner coordinates
geometry.prob_hi                         = 2560.  2560.  1280.  # Hi corner coordinates
amr.n_cell                               = 128 128 64    # Grid cells at coarsest AMRlevel
amr.max_level                            = 0           # Max AMR level in hierarchy 
geometry.is_periodic                     = 1   1   0   # Periodicity x y z (0/1)
incflo.delp                              = 0.  0.  0.  # Prescribed (cyclic) pressure gradient

#xlo.type                                 = mass_inflow         
#xlo.density                              = 1.225               
#xlo.temperature                          = 290.0               
#xlo.tke                                  = 0.0
#xhi.type                                 = pressure_outflow    

#ylo.type                                 = mass_inflow         
#ylo.density                              = 1.225               
#ylo.temperature                          = 290.0               
#ylo.tke                                  = 0.0
#yhi.type                                 = pressure_outflow     

zlo.type                                 = wall_model
zhi.type                                 = slip_wall
zhi.temperature_type                     = fixed_gradient
zhi.temperature                          = 0.003

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#               PHYSICS                 #
#.......................................#
ICNS.source_terms                        = BoussinesqBuoyancy CoriolisForcing ABLForcing
##--------- Additions by calc_inflow_stats.py ---------#
#ABL.wall_shear_stress_type = "local"
#ABL.inflow_outflow_mode = true
#ABL.wf_velocity = XX XX
#ABL.wf_vmag = XX
#ABL.wf_theta = XX
#BodyForce.magnitude = XX XX XX
#BoussinesqBuoyancy.read_temperature_profile = true
#BoussinesqBuoyancy.tprofile_filename = avg_theta.dat
##-----------------------------------------------------#
incflo.velocity                          = 10.0 0.0 0.0
ABLForcing.abl_forcing_height            = 86.5
CoriolisForcing.latitude                 = 36.607322      # Southern Great Planes
CoriolisForcing.north_vector             = 0.0 1.0 0.0
CoriolisForcing.east_vector              = 1.0 0.0 0.0
BoussinesqBuoyancy.reference_temperature = 290.0
ABL.reference_temperature                = 290.0
ABL.temperature_heights                  = 0.0 600.0 700.0 1700.0    # Make sure the top height here goes above the domain height
ABL.temperature_values                   = 290.0 290.0 298.0 301.0
ABL.perturb_temperature                  = true
ABL.cutoff_height                        = 50.0
ABL.perturb_velocity                     = true
ABL.perturb_ref_height                   = 50.0
ABL.Uperiods                             = 4.0
ABL.Vperiods                             = 4.0
ABL.deltaU                               = 1.0
ABL.deltaV                               = 1.0
ABL.kappa                                = .40
ABL.surface_roughness_z0                 = 0.01  # meters
ABL.surface_temp_flux                    = 0.05  # Surface temperature flux [K-m/s]

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#          POST-Processing              #
#.......................................#
#io.output_hdf5_plotfile                  = true  # Uncomment these two lines if save to .hdf instead of plt#####/
#io.hdf5_compression                      = "ZFP_ACCURACY@0.001"

incflo.post_processing                   = sampling averaging

# --- Sampling parameters ---
sampling.output_frequency                = 900                 
sampling.fields                          = velocity temperature

#---- sample defs ----
sampling.labels                          = xy-domain yz-domain 

sampling.xy-domain.type                  = PlaneSampler        
sampling.xy-domain.num_points            = 256 256             
sampling.xy-domain.origin                = 0.0 0.0 86.5      
sampling.xy-domain.axis1                 = 2550.0 0.0 0.0      
sampling.xy-domain.axis2                 = 0.0 2550.0 0.0      
sampling.xy-domain.normal                = 0.0 0.0 1.0         
sampling.xy-domain.offsets               = -63.45 0.0 63.45  

sampling.xz-domain.type                  = PlaneSampler        
sampling.xz-domain.num_points            = 256 128              
sampling.xz-domain.origin                = 0.0 1280.0 0.0         
sampling.xz-domain.axis1                 = 2550.0 0.0 0.0      
sampling.xz-domain.axis2                 = 0.0 0.0 1270.0   

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#              AVERAGING                #
#.......................................#
#averaging.type                           = TimeAveraging
#averaging.labels                         = means stress

#averaging.averaging_window               = 600.0
#averaging.averaging_start_time           = 3600.0

#averaging.means.fields                   = velocity
#averaging.means.averaging_type           = ReAveraging

#averaging.stress.fields                  = velocity
#averaging.stress.averaging_type          = ReynoldsStress

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            MESH REFINEMENT            #
#.......................................#


#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#               TURBINES                #
#.......................................#