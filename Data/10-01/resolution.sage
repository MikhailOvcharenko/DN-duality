# The resolution tree of a general member of the pencil
pencil_general_member_singularities_resolution_00 = \
    LabelledOrderedTree([], label = ((0, 3), (0, m/(m - 1), 0, 0, 0)));

pencil_general_member_singularities_resolution_01 = \
    LabelledOrderedTree([], label = ((0, 3), (0, (m - 1)/m, 0, 0, 0)));

pencil_general_member_singularities_resolution = \
    LabelledOrderedTree([pencil_general_member_singularities_resolution_00,
                         pencil_general_member_singularities_resolution_01],
                        label = '\\lambda_{\\mathrm{general}}');
