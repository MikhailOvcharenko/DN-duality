## Parametrised toric LG model for
## the del Pezzo surface of degree 9

# Picard number of the del Pezzo surface
dP_rank = 1;

# The Laurent polynomial ring over the parameters ring
parameters_list = [];
for i in range(dP_rank) : parameters_list.append('a_' + str(i + 1));
parameters_ring = PolynomialRing(QQ, names = parameters_list);
parameters_ring.inject_variables();
laurent_ring.<x,y> = LaurentPolynomialRing(parameters_ring);

# The Newton polygon of the Gorenstein toric degeneration
polygon_reflexive_ID = 0;
polygon_transformation = identity_matrix(ZZ, 2);
polygon_vertices_pre = ReflexivePolytope(2, polygon_reflexive_ID).vertices();
polygon = LatticePolytope([polygon_transformation * i \
                           for i in polygon_vertices_pre])
polygon_vertices = set(polygon.vertices());

# The Landau--Ginzburg model for the crepant resolution of
# the Gorenstein toric degeneration of the del Pezzo surface
resolution_LG_model = x + y + a_1*x^-1*y^-1;

# The Landau--Ginzburg model for the del Pezzo surface
LG_model = resolution_LG_model;
