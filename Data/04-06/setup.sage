# Basic information on the Fano threefold
fano_threefold_rank = 4;
fano_threefold_family_no = 6;
fano_threefold_picard_lattice = matrix(ZZ, ((-2, 0, 1, 2),
                                            (0, -2, 0, 1),
                                            (1, 0, 2, 3),
                                            (2, 1, 3, 0)));

# The parameter ring
coefficient_vars = ('l',); 
parameter_ring = PolynomialRing(QQ, names = coefficient_vars);
parameter_ring.inject_variables();
parameter_ring._latex_names = ('\\lambda',);

# The Laurent polynomial ring
laurent_vars = ('x', 'y', 'z');
laurent_ring = LaurentPolynomialRing(parameter_ring, names = laurent_vars);
laurent_ring.inject_variables();

# The toric Landau--Ginzburg model of the Fano threefold
LG_model = x + y + z + y*z^-1 + x^-1*y + y^-1*z + z^-1 + y^-1 + x^-1;
LG_model_polytope_PALP_ID = 426;
LG_model_period_sequence_GRDB_ID = 81;
LG_model_period_sequence_PFO_degree = 6;

# The coordinate ring of the ambient space
coordinate_vars = ('X', 'Y', 'Z', 'T');   
coordinate_ring = PolynomialRing(parameter_ring, names = coordinate_vars);
coordinate_ring.inject_variables();

# The flattening of the coordinate ring
CR_flattening = FlatteningMorphism(coordinate_ring);
CR_flattened = CR_flattening.codomain();
CR_flattened._latex_names = parameter_ring._latex_names + coordinate_vars;

# The pencil equation of the toric Landau--Ginzburg model
LG_model_numerator = laurent_ring.fraction_field()(LG_model).numerator();
LG_model_denominator = laurent_ring.fraction_field()(LG_model).denominator();
LG_model_pencil_equation = \
    (LG_model_numerator - l*LG_model_denominator)(X, Y, Z).homogenize('T');
