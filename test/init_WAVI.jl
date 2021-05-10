using WAVI 
function driver()
    #Grid and boundary conditions
    nx = 80
    ny = 10
    nσ = 4
    x0 = 0.0
    y0 = -40000.0
    dx = 8000.0
    dy = 8000.0
    h_mask=trues(nx,ny)
    u_iszero = falses(nx+1,ny); u_iszero[1,:].=true
    v_iszero=falses(nx,ny+1); v_iszero[:,1].=true; v_iszero[:,end].=true
    grid = Grid(nx = nx, 
                ny = ny,   
                nσ = nσ, 
                x0 = x0, 
                y0 = y0, 
                dx = dx, 
                dy = dy,
                h_mask = h_mask, 
                u_iszero = u_iszero, 
                v_iszero = v_iszero)

    #Timestepping Parameters
    n_iter0 = 0
    dt = 0.1
    end_time = 1000.
    chkpt_freq = 100.
    pchkpt_freq = 200.
    timestepping_params = TimesteppingParams(n_iter0 = n_iter0, 
                                            dt = dt, 
                                            end_time = end_time, 
                                            chkpt_freq = chkpt_freq, 
                                            pchkpt_freq = pchkpt_freq)

    #Bed 
    bed = WAVI.mismip_plus_bed #function definition

    #solver parameters
    maxiter_picard = 1
    solver_params = SolverParams(maxiter_picard = maxiter_picard)

    #Physical parameters
    default_thickness = 100.0 #set the initial condition this way
    accumulation_rate = 0.3
    params = Params(default_thickness = default_thickness, 
                    accumulation_rate = accumulation_rate)

    #outputting
    out_freq = 1.
    out_dict = Dict("h" => :(wavi.gh.h), "u" => :(wavi.gu.u))
    output = Output(out_freq = out_freq, out_dict = out_dict)
    
    #initialize the run 
    wavi = start(bed_elevation = bed, 
                params = params, 
                solver_params = solver_params,  
                timestepping_params = timestepping_params, 
                grid = grid);

    return wavi
end