set enabled_p [parameter::get \
                    -parameter TechnoratiApiEnabledP \
                    -boolean \
                    -default 0]

set package_id [ad_conn package_id]

if { $enabled_p } {
    db_multirow links cache_select ""
}
