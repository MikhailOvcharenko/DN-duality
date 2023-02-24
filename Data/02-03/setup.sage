# Basic information on the Fano threefold
fano_threefold_rank = 2;
fano_threefold_family_no = 3;
fano_threefold_picard_lattice = matrix(ZZ, ((0, 2),
                                            (2, 4)));

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
LG_model = (x + y + 1)^4*(z + 1)*x^-1*y^-1*z^-1 + z + 1;
LG_model_polytope_PALP_ID = None;
LG_model_period_sequence_GRDB_ID = None;
LG_model_period_sequence_PFO_degree = 4;

# The coordinate ring of the ambient space
coordinate_vars = ('X', 'Y', 'Z', 'T');   
coordinate_ring = PolynomialRing(parameter_ring, names = coordinate_vars);
coordinate_ring.inject_variables();

# The flattening of the coordinate ring
CR_flattening = FlatteningMorphism(coordinate_ring);
CR_flattened = CR_flattening.codomain();
CR_flattened._latex_names = parameter_ring._latex_names + coordinate_vars;

# The pencil equation of the toric Landau--Ginzburg model
birational_transform = (-x*z, x + x*z - 1, -y*z^-1 - 1);
LG_model_transformed = \
    laurent_ring.fraction_field()(LG_model)(birational_transform);
LG_model_numerator = LG_model_transformed.numerator();
LG_model_denominator = LG_model_transformed.denominator();
LG_model_pencil_equation = \
    (LG_model_numerator - l*LG_model_denominator)(X, Y, Z).homogenize('T');
