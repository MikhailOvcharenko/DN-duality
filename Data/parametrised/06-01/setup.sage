# Basic information on the Fano threefold
fano_threefold_rank = 6;
fano_threefold_family_no = 1;
fano_threefold_picard_lattice = matrix(ZZ, ((-2, 0, 0, 0, -1, 0),
                                            (0, -2, 0, 0, -1, 0),
                                            (0, 0, -2, 0, -1, 0),
                                            (0, 0, 0, -2, -1, 0),
                                            (-1, -1, -1, -1, 0, 3),
                                            (0, 0, 0, 0, 3, 2)));

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

# Minkowski polynomials
minkowski_0357 = x + y + z + x*y^-1 + x^-1*y + z^-1 + 2*y^-1 + 2*x^-1 + \
    x^-1*y^-1;
minkowski_1353 = x + y + z + x^-1*y + y^-1*z + 2*y^-1 + 4*x^-1 + x^-2*y*z^-1 + \
    3*x^-1*y^-1 + 2*x^-2*z^-1 + x^-1*y^-2 + x^-2*y^-1*z^-1;
minkowski_1231 = x + y + z + x^-1*y + 2*y^-1 + 4*x^-1 + x^-2*y*z^-1 + \
    3*x^-1*y^-1 + 3*x^-2*z^-1 + x^-1*y^-2 + 3*x^-2*y^-1*z^-1 + x^-2*y^-2*z^-1;
minkowski_0284 = x + y + z + x^-1*y + z^-1 + 2*y^-1 + 3*x^-1 + 3*x^-1*y^-1 + \
    x^-1*y^-2;

# Construction of the birational automorphism of the algebraic torus
Prz_06_01_to_minkowski_0357 = matrix(ZZ, ((0, 1, 0),
                                          (-1, 0, 0),
                                          (0, 0, 1)));
minkowski_0357_to_1353 = (matrix(ZZ, ((-1, 0, 1),
                                      (0, 1, 0),
                                      (0, 1, -1))),
                          x*(a_4*y + 1)*(a_1*a_2*a_5 + y) + y^2,
                          matrix(ZZ, ((-1, 1, -1),
                                      (0, 1, 0),
                                      (-1, -1, 0))));
minkowski_1353_to_1231 = (matrix(ZZ, ((0, -1, 0),
                                      (1, 1, 0),
                                      (-1, 0, 1))),
                          (a_4*x*y + 1)*(a_1*a_2*a_5 + x*y),
                          matrix(ZZ, ((1, 1, 0),
                                      (-1, 0, 0),
                                      (-1, 0, -1))));
minkowski_1231_to_0284 = (matrix(ZZ, ((0, -1, 1),
                                      (1, 0, 0),
                                      (-1, 0, -1))),
                          x*y + 1,
                          matrix(ZZ, ((0, 1, 0),
                                      (-1, -1, -1),
                                      (0, -1, -1))));
minkowski_0284_to_CP_06_01 = diagonal_matrix(ZZ, (1, -1, 1));


# The toric Landau--Ginzburg model of the Fano threefold
Prz_06_01_LG_model = x + (a_1*a_2*a_4*a_5 + 1)*y + a_1*x^-1*y^-1 + \
    a_1*(a_2 + a_5)*x^-1 + a_1*a_3*y^-1 + a_4*x*y + a_1*a_2*a_5*x^-1*y + \
    z + a_6*z^-1;
CP_06_01_LG_model = x + 2*y + x^-1*y^2 + z + 3*x^-1*y + z^-1 + y^-1 + \
    3*x^-1 + x^-1*y^-1;
minkowski_0357_parametrised = \
    GL_action(Prz_06_01_LG_model, Prz_06_01_to_minkowski_0357);
minkowski_1353_parametrised = \
    mutation_evaluation(minkowski_0357_parametrised, minkowski_0357_to_1353);
minkowski_1231_parametrised = \
    mutation_evaluation(minkowski_1353_parametrised, minkowski_1353_to_1231); 
minkowski_0284_parametrised = \
    mutation_evaluation(minkowski_1231_parametrised, minkowski_1231_to_0284);
LG_model = GL_action(minkowski_0284_parametrised, minkowski_0284_to_CP_06_01);
LG_model_polytope_PALP_ID = 284;
LG_model_period_sequence_GRDB_ID = 107;
LG_model_period_sequence_PFO_degree = 8;

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
