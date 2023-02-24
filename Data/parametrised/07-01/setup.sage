# Basic information on the Fano threefold
fano_threefold_rank = 7;
fano_threefold_family_no = 1;
fano_threefold_picard_lattice = matrix(ZZ, ((-2, 0, 0, 0, 0, -1, 0),
                                            (0, -2, 0, 0, 0, -1, 0),
                                            (0, 0, -2, 0, 0, -1, 0),
                                            (0, 0, 0, -2, 0, -1, 0),
                                            (0, 0, 0, 0, -2, -1, 0),
                                            (-1, -1, -1, -1, -1, 0, 3),
                                            (0, 0, 0, 0, 0, 3, 2)));

# The parameter ring
parameter_vars = tuple(['a_' + str(i + 1) for i in range(fano_threefold_rank)]);
coefficient_vars = ('l',); 
parameter_ring = PolynomialRing(QQ, names = parameter_vars + coefficient_vars);
parameter_ring._latex_names = parameter_vars + ('\\lambda',);
parameter_ring.inject_variables();
parameter_ideal = parameter_ring.ideal(parameter_vars);

# The Laurent polynomial ring
laurent_vars = ('x', 'y', 'z');
laurent_ring = LaurentPolynomialRing(parameter_ring, names = laurent_vars);
laurent_ring.inject_variables();

# The toric Landau--Ginzburg model of the Fano threefold
Prz_07_01_LG_model = x + (a_1*a_2*a_4*a_5 + 1)*y + \
    a_1*(a_1*a_3*a_6*(a_2 + a_5) + 1)*x^-1*y^-1 + \
    a_1*(a_1*a_2*a_3*a_5*a_6 + a_2 + a_5)*x^-1 + a_1*(a_3 + a_6)*y^-1 + \
    a_4*x*y + a_1*a_2*a_5*x^-1*y + a_1^2*a_3*a_6*x^-1*y^-2 + z + a_7*z^-1;
CP_07_01_LG_model = x^2*y^-1 + 3*x + 3*y + x^-1*y^2 + z + 2*x*y^-1 + \
    2*x^-1*y + z^-1 + y^-1 + x^-1;
Prz_07_01_to_CP_07_01 = matrix(ZZ, ((0, -1, 0),
                                    (-1, 1, 0),
                                    (0, 0, 1)));
LG_model = GL_action(Prz_07_01_LG_model, Prz_07_01_to_CP_07_01);
LG_model_polytope_PALP_ID = 506;
LG_model_period_sequence_GRDB_ID = 136;
LG_model_period_sequence_PFO_degree = 9;

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
