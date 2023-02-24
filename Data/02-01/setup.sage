# Basic information on the Fano threefold
fano_threefold_rank = 2;
fano_threefold_family_no = 1;
fano_threefold_picard_lattice = matrix(ZZ, ((0, 1),
                                            (1, 2)));

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
LG_model = (x + y + 1)^6*(z + 1)*x^-1*y^-2 + z^-1;
LG_model_polytope_PALP_ID = None;
LG_model_period_sequence_GRDB_ID = None;
LG_model_period_sequence_PFO_degree = 4;

# The coordinate ring of the ambient space
coordinate_vars = ('X', 'Y', 'A', 'B', 'C');   
coordinate_ring = PolynomialRing(parameter_ring, names = coordinate_vars);
coordinate_ring.inject_variables();

# The flattening of the coordinate ring
CR_flattening = FlatteningMorphism(coordinate_ring);
CR_flattened = CR_flattening.codomain();
CR_flattened._latex_names = parameter_ring._latex_names + coordinate_vars;

# The pencil equation of the toric Landau--Ginzburg model
frac_field = coordinate_ring.fraction_field();
birational_transform = (1, frac_field(B^-1) - frac_field(B^-2*C^-1) - 1, \
                        1, frac_field(B^-2*C^-1), -frac_field(Y^-1) - 1);
LG_model_transformed = frac_field(LG_model(Y, B, C))(birational_transform);
LG_model_pencil_equation_prep = \
    LG_model_transformed.numerator() - l*LG_model_transformed.denominator();
LG_model_pencil_equation = LG_model_pencil_equation_prep\
    (1, X^-1*Y, 1, A^-1*B, A^-1*C).numerator();
