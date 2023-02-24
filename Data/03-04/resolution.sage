# The resolution tree of a general member of the pencil
pencil_general_member_singularities_resolution_00 = \
    LabelledOrderedTree([], label = (2, 4*(0,)));

pencil_general_member_singularities_resolution_01 = \
    LabelledOrderedTree([], label = (1, 4*(0,)));

pencil_general_member_singularities_resolution_02 = \
    LabelledOrderedTree([], label = (0, 4*(0,)));

pencil_general_member_singularities_resolution_03_00_00 = \
    LabelledOrderedTree([], label = (0, (0, 0, 0, l + 4)));
pencil_general_member_singularities_resolution_03_00_01 = \
    LabelledOrderedTree([], label = (3, ((l + 4)^-1, 0, 0, 0)));

pencil_general_member_singularities_resolution_03_00 = LabelledOrderedTree\
    ([pencil_general_member_singularities_resolution_03_00_00,
      pencil_general_member_singularities_resolution_03_00_01],
     label = (3, (0, 0, 0, 0)));

pencil_general_member_singularities_resolution_03 = \
    LabelledOrderedTree([pencil_general_member_singularities_resolution_03_00],
                        label = (2, (0, 0, 0, -1)));

pencil_general_member_singularities_resolution_04 = \
    LabelledOrderedTree([], label = (1, (-1, 0, 0, 0)));

pencil_general_member_singularities_resolution_05 = \
    LabelledOrderedTree([], label = (3, (0, l + 4, -1, 0)));

pencil_general_member_singularities_resolution_06 = \
    LabelledOrderedTree([], label = (3, (l + 4, 0, -1, 0)));

pencil_general_member_singularities_resolution = \
    LabelledOrderedTree([pencil_general_member_singularities_resolution_00,
                         pencil_general_member_singularities_resolution_01,
                         pencil_general_member_singularities_resolution_02,
                         pencil_general_member_singularities_resolution_03,
                         pencil_general_member_singularities_resolution_04,
                         pencil_general_member_singularities_resolution_05,
                         pencil_general_member_singularities_resolution_06],
                        label = '\\lambda_{\\mathrm{general}}');
