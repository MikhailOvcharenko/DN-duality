# The resolution tree of a general member of the pencil
pencil_general_member_singularities_resolution_00_00 = \
    LabelledOrderedTree([], label = (3, (0, 0, 0, 0)));

pencil_general_member_singularities_resolution_00 = \
    LabelledOrderedTree([pencil_general_member_singularities_resolution_00_00],
                        label = (2, (0, 0, 0, 0)));

pencil_general_member_singularities_resolution_01 = \
    LabelledOrderedTree([], label = (1, (0, 0, 0, 0)));

pencil_general_member_singularities_resolution_02_00 = \
    LabelledOrderedTree([], label = (3, (0, 0, 0, 0)));

pencil_general_member_singularities_resolution_02 = \
    LabelledOrderedTree([pencil_general_member_singularities_resolution_02_00],
                        label = (0, (0, 0, 0, 0)));

pencil_general_member_singularities_resolution = \
    LabelledOrderedTree([pencil_general_member_singularities_resolution_00,
                         pencil_general_member_singularities_resolution_01,
                         pencil_general_member_singularities_resolution_02],
                        label = '\\lambda_{\\mathrm{general}}');
