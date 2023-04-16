load("Library.sage")
load("Data/04-05/setup.sage")
load("Data/04-05/pencil.sage")
load("Data/04-05/resolution.sage")
load("Data/04-05/lattice.sage")

print("The pencil equation of the toric Landau--Ginzburg model:");
print(LG_model_pencil_equation);

print("\nIrreducible components of the member of the pencil over infinity:")
for I in pencil_infinity_member_components:
    print(I.gens());
    
print("\nIrreducible components of reducible members of the pencil " + \
      "(apart from the member over infinity):");
for I in pencil_reducible_members_components:
    print(I.gens());
    
print("\nIrredubible components of the base locus of the pencil:");
for I in pencil_base_locus_components:
    print(I.gens());
    
print("\nRelations matrix on the group A_S:"); 
print(pencil_equivalence_matrix());

print("\nIndexes of the selected integral generators of the group A_S:");
print(pencil_AS_integral_generators);
if not pencil_AS_integral_generators_are_extractable:
    print("Indexes of the selected rational generators of the group A_S:");
    print(pencil_AS_rational_generators);

if (pencil_AS_integral_generators_are_extractable):
    [A, B, C] = matrix_splitting(pencil_equivalence_matrix(), \
                                 pencil_AS_integral_generators);
else:
    [A, B, C] = matrix_splitting(pencil_equivalence_matrix(), \
                                 pencil_AS_rational_generators);
print("Decomposed elements: "); print(A);
print("Left hand side: "); print(B);
print("Right hand side: "); print(C);

print("\nIntersection matrix on the group A_S:");
print(pencil_AS_rational_intersection_matrix())

if not pencil_LG_lattice_galois_action_trivial:
    print("\nAuxiliary ramified covering of the projective line:");
    print('l = ' + str(pencil_generic_member_base_field_extension));

print("\nIntersection of the singular locus of a member of " + \
      "the pencil with the base locus\n" + 80 * "=");
pencil_general_member_singularities_report();
print("\nDescription of the singular locus of " + \
      "a general member of the pencil\n" + 67 * "=");
pencil_general_member_singularities_tangent_cone_report();

if not pencil_LG_lattice_galois_action_trivial:
    print("Galois orbits on the lattice L_lambda:");
    for l in pencil_LG_lattice_galois_orbits:
        if (len(l) > 1) : print(l);

if not pencil_LG_lattice_nondegenerate:
    print("\nIndexes of the selected integral basis of the lattice L_lambda:");
    print(pencil_LG_lattice_integral_basis);
    M = pencil_LG_lattice_intersection_matrix();
    [A, B, C] = matrix_splitting(M.right_kernel().matrix(), \
                                 pencil_LG_lattice_integral_basis);
    print("Decomposed elements:"); print(A);
    print("Left hand side:"); print(B);
    print("Right hand side:"); print(C);
    if not pencil_LG_lattice_galois_action_trivial:
        print("\nIndexes of the selected integral basis of the lattice L_S:");
        print(pencil_LS_lattice_integral_basis);
        M = pencil_LS_lattice_intersection_matrix();
        [A, B, C] = matrix_splitting(M.right_kernel().matrix(), \
                                     pencil_LS_lattice_integral_basis);
        print("Decomposed elements:"); print(A);
        print("Left hand side:"); print(B);
        print("Right hand side:"); print(C);

if not pencil_LG_lattice_galois_action_trivial:
    print("\nIntersection matrix on the lattice L_lambda:");
    print(pencil_LG_lattice_intersection_matrix());

    if not pencil_LG_lattice_nondegenerate:
        print("\nIntersection matrix on the lattice L_lambda (reduced form):");
        print(pencil_LS_lattice_intersection_matrix_reduced('general'));
        
print("\nIntersection matrix on the lattice L_S:");
print(pencil_LS_lattice_intersection_matrix());

if not pencil_LG_lattice_nondegenerate:
    print("\nIntersection matrix on the lattice L_S (reduced form):");
    print(pencil_LS_lattice_intersection_matrix_reduced('generic'));

print("\nOrthogonal complement to the lattice L_S:");
print(pencil_LS_lattice_orthogonal_complement());

print("\nSelected generators of the discriminant group of the lattice L_S:");
print(matrix(pencil_LS_lattice_disc_group_generators));
print("Selected generators of the discriminant group of " + \
      "its orthogonal complement:");
print(matrix(pencil_LS_lattice_orthogonal_complement_disc_group_generators));
DN_duality_report();
