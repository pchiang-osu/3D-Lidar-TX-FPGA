
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name spi -dir "D:/SPI/spi/planAhead_run_2" -part xc6slx16csg324-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "spi_test.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {spi.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {clockpll.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {spi_test.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top spi_test $srcset
add_files [list {spi_test.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-2
