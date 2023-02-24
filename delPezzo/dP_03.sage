## Parametrised toric LG model for
## the del Pezzo surface of degree 3

# Picard number of the del Pezzo surface
dP_rank = 7;

# The Laurent polynomial ring over the parameters ring
parameters_list = [];
for i in range(dP_rank) : parameters_list.append('a_' + str(i + 1));
parameters_ring = PolynomialRing(QQ, names = parameters_list);
parameters_ring.inject_variables();
laurent_ring.<x,y> = LaurentPolynomialRing(parameters_ring);
marking_ring.<s> = PolynomialRing(parameters_ring);

# The Newton polygon of the Gorenstein toric degeneration
polygon_reflexive_ID = 15;
polygon_transformation = matrix(ZZ, ((-1, 1),
                                     (1, 0)));
polygon_vertices_pre = ReflexivePolytope(2, polygon_reflexive_ID).vertices();
polygon = LatticePolytope([polygon_transformation * i \
                           for i in polygon_vertices_pre]);
polygon_vertices = set(polygon.vertices());

# The Newton polygon from the previous step
polygon_old_reflexive_ID = 13;
polygon_old_transformation = matrix(ZZ, ((1, 1),
                                         (1, 0)));
polygon_old_vertices_pre = \
    ReflexivePolytope(2, polygon_old_reflexive_ID).vertices();
polygon_old = LatticePolytope([polygon_old_transformation * i \
                               for i in polygon_old_vertices_pre]);
polygon_old_vertices = set(polygon_old.vertices());

# The Landau--Ginzburg model of the crepant resolution from the previous step
resolution_LG_model_old = a_4*x*y + x + y + a_1*a_2*a_5*x^-1*y + \
    a_1*a_3*y^-1 + a_1*a_2*x^-1 + a_1*x^-1*y^-1 + a_1^2*a_3*a_6*x^-1*y^-2;

# The coefficient corresponding to the left neighbour point
left_neighbour_indexes = (1, 1);
left_neighbour_monomial = laurent_ring.monomial(*left_neighbour_indexes);
left_neighbour_coefficient_pre = \
    resolution_LG_model_old.coefficient(left_neighbour_monomial);
left_neighbour_coefficient = \
    left_neighbour_coefficient_pre.constant_coefficient();

# The coefficient corresponding to the right neighbour point
right_neighbour_indexes = (1, 0);
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

# Facets of the Newton polygon containing non-boundary integral points
facets_integral_points = (((-1, -2), (-1, -1), (-1, 0), (-1, 1)),
                          ((-1, 1), (0, 1), (1, 1), (2, 1)),
                          ((2, 1), (1, 0), (0, -1), (-1, -2)));

# The Landau--Ginzburg model for the del Pezzo surface
LG_model = resolution_LG_model;

for points_list in facets_integral_points:
    # Construct the marking polynomial
    marking_polynomial = 1;

    for i in points_list:
        marking_index = points_list.index(i);
        marking_monomial = laurent_ring.monomial(*i);
        marking_coefficient_pre = \
            resolution_LG_model.coefficient(marking_monomial);
        marking_coefficient = marking_coefficient_pre.constant_coefficient();

        if (marking_index == 0):
            marking_polynomial *= marking_coefficient;
        else:
            previous_marking_monomial = \
                laurent_ring.monomial(*points_list[marking_index - 1]);
            previous_marking_coefficient_pre = \
                resolution_LG_model.coefficient(previous_marking_monomial);
            previous_marking_coefficient = \
                previous_marking_coefficient_pre.constant_coefficient();
            marking_polynomial *= \
                (1 + marking_coefficient / previous_marking_coefficient * s);

    # The coefficients list of the marking polynomial
    marking_list = \
        marking_ring(marking_polynomial).coefficients(sparse = False);
    
    # Construct the Landau--Ginzburg model for the del Pezzo surface
    for i in points_list:
        marking_index = points_list.index(i);
        marking_monomial = laurent_ring.monomial(*i);
        marking_coefficient_pre = \
            resolution_LG_model.coefficient(marking_monomial);
        marking_coefficient = marking_coefficient_pre.constant_coefficient();
        
        LG_model += (marking_list[marking_index] - marking_coefficient) * \
            marking_monomial;
