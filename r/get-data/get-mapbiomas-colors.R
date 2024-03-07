
"
                             category_es,                        category_en, value,   color
                       Formación boscosa,                   Forest formation,     1, #129912
                                  Bosque,                             Forest,     3, #006400
                        Bosque inundable,                     Flooded forest,     6, #76A5AF
            Formación natural no boscosa,       Natural non forest formation,    10, #BBFCAC
 Formación natural no forestal inundable,                            Wetland,    11, #45C2A5
          Formación campestre o herbazal,             Grassland / herbaceous,    12, #B8AF4F
      Otra formación natural no forestal, Other non-forest natural formation,    13, #F1C232
                       Área agropecuaria,                            Farming,    14, #FFFFB2
                                   Pasto,                            Pasture,    15, #FFD966
                             Agricultura,                        Agriculture,    18, #E974ED
                         Mosaico de usos,                     Mosaic of uses,    21, #FFEFC3
                     Área sin vegetación,                 Non-vegetated area,    22, #EA9999
                  Infraestructura urbana,               Urban infrastructure,    24, #AA0000
                                 Minería,                             Mining,    30, #FF0000
                Otra área sin vegetación,           Other non-vegetated area,    25, #FF8585
                                   Salar,                          Salt flat,    61, #F5D5D5
                          Cuerpo de agua,                         Water body,    26, #0000FF
                              Río o lago,                      River or lake,    33, #0000FF
                                 Glaciar,                            Glacier,    34, #4FD3FF
                            No observado,                       Not observed,    27, #D5D5E5
"   |>
    fread() ->
    dt


# Classifications for aggregation

dt[value %in% c(1,3,6), class_forest := "forest"]
dt[!(value %in% c(1,3,6)), class_forest := "nonforest"]

dt[value %in% c(1,3,6), class := "forest"]
dt[value %in% c(10,11,12,13), class := "natural-nonforest"]
dt[value %in% c(14,15,18,21,22,24,25,30), my_class := "nonnatural"]
dt[value %in% c(26,33), class := "water"]
dt[value %in% c(27,61,34), class := "other"]

dt |> fwrite(filenames$csv$mapbiomas_colors)
