## Parametrised toric LG model for
## the del Pezzo surface of degree 8

# Picard number of the del Pezzo surface
dP_rank = 2;

# The Laurent polynomial ring over the parameters ring
parameters_list = [];
for i in range(dP_rank) : parameters_list.append('a_' + str(i + 1));
parameters_ring = PolynomialRing(QQ, names = parameters_list);
parameters_ring.inject_variables();
laurent_ring.<x,y> = LaurentPolynomialRing(parameters_ring);

# The Newton polygon of the Gorenstein toric degeneration
polygon_reflexive_ID = 2;
polygon_transformation = diagonal_matrix(ZZ, (-1, 1));
polygon_vertices_pre = ReflexivePolytope(2, polygon_reflexive_ID).vertices();
polygon = LatticePolytope([polygon_transformation * i \
                           for i in polygon_vertices_pre]);
polygon_vertices = set(polygon.vertices());

# The Newton polygon from the previous step
polygon_old_reflexive_ID = 0;
polygon_old_transformation = identity_matrix(ZZ, 2);
polygon_old_vertices_pre = \
    ReflexivePolytope(2, polygon_old_reflexive_ID).vertices();
polygon_old = LatticePolytope([polygon_old_transformation * i \
                               for i in polygon_old_vertices_pre])
polygon_old_vertices = set(polygon_old.vertices());

# The Landau--Ginzburg model of the crepant resolution from the previous step
resolution_LG_model_old = x + y + a_1*x^-1*y^-1;

# The coefficient corresponding to the left neighbour point
left_neighbour_indexes = (-1, -1);
left_neighbour_monomial = laurent_ring.monomial(*left_neighbour_indexes);
left_neighbour_coefficient_pre = \
    resolution_LG_model_old.coefficient(left_neighbour_monomial);
left_neighbour_coefficient = \
    left_neighbour_coefficient_pre.constant_coefficient();

# The coefficient corresponding to the right neighbour point
right_neighbour_indexes = (0, 1);
right_neighbour_monomial = laurent_ring.monomial(*right_neighbour_indexes);
right_neighbour_coefficient_pre = \
    resolution_LG_model_old.coefficient(right_neighbour_monomial);
right_neighbour_coefficient = \
    right_neighbour_coefficient_pre.constant_coefficient();

# The monomial corresponding to the boundary point
boundary_difference = polygon_vertices.difference(polygon_old_vertices);
boundary_index = tuple(boundary_difference)[0];
boundary_monomial = laurent_ring.monomial(*boundary_index);

# The Landau--Ginzburg model for the crepant resolution of
# the Gorenstein toric degeneration of the del Pezzo surface
resolution_LG_model = resolution_LG_model_old + \
    parameters_ring.gens()[-1] * left_neighbour_coefficient * \
    right_neighbour_coefficient * boundary_monomial;

# The Landau--Ginzburg model for the del Pezzo surface
LG_model = resolution_LG_model;
