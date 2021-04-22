puts "DTB generation started using XSCT"

set platform_name [lindex $argv 0]
puts "The platform name is \"$platform_name\""

set dt_repo_path [lindex $argv 1]
puts "dt_repo_path is \"$dt_repo_path\""

set xsa_path [lindex $argv 2]
puts "The xsa path is \"$xsa_path\""

set board [lindex $argv 3]
puts "board is\"$board\""

set core [lindex $argv 4]
puts "core is\"$core\""

set output_path [lindex $argv 5]
puts "The output path is \"$output_path\""


# Setting the workspace
#setws $output_path/Workspace
 
# Adding the device Tree Embedded Sw Repository to xsct
#repo -set $dt_repo_path
::hsi::utils::add_repo $dt_repo_path
 
# Create a $platform_name platform with OS as device_tree, and proc ps core 
platform create -name $platform_name -hw $xsa_path -proc $core -os device_tree -out $output_path/Workspace
 
# Set the bsp property periph_type_overrrides to include the BOARD detail.
library -name device_tree -option periph_type_overrides -value "{BOARD $board}"

#Set the default overlay dts name
library -name device_tree -option overlay_custom_dts -value "pl-final.dts"

#dont generate the pl dtsi
#library -name device_tree -option remove_pl -value "true"
 
# Regenerate the bsp to see the modified changes
bsp regenerate

# Generate the platform
platform generate
 
# exit xsct
exit
