# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AddrWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BufDepth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DataWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HideStrb" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IdWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NumBanks" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OutFifoDepth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UserWidth" -parent ${Page_0}


}

proc update_PARAM_VALUE.AddrWidth { PARAM_VALUE.AddrWidth } {
	# Procedure called to update AddrWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AddrWidth { PARAM_VALUE.AddrWidth } {
	# Procedure called to validate AddrWidth
	return true
}

proc update_PARAM_VALUE.BufDepth { PARAM_VALUE.BufDepth } {
	# Procedure called to update BufDepth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BufDepth { PARAM_VALUE.BufDepth } {
	# Procedure called to validate BufDepth
	return true
}

proc update_PARAM_VALUE.DataWidth { PARAM_VALUE.DataWidth } {
	# Procedure called to update DataWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DataWidth { PARAM_VALUE.DataWidth } {
	# Procedure called to validate DataWidth
	return true
}

proc update_PARAM_VALUE.HideStrb { PARAM_VALUE.HideStrb } {
	# Procedure called to update HideStrb when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HideStrb { PARAM_VALUE.HideStrb } {
	# Procedure called to validate HideStrb
	return true
}

proc update_PARAM_VALUE.IdWidth { PARAM_VALUE.IdWidth } {
	# Procedure called to update IdWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IdWidth { PARAM_VALUE.IdWidth } {
	# Procedure called to validate IdWidth
	return true
}

proc update_PARAM_VALUE.NumBanks { PARAM_VALUE.NumBanks } {
	# Procedure called to update NumBanks when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NumBanks { PARAM_VALUE.NumBanks } {
	# Procedure called to validate NumBanks
	return true
}

proc update_PARAM_VALUE.OutFifoDepth { PARAM_VALUE.OutFifoDepth } {
	# Procedure called to update OutFifoDepth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OutFifoDepth { PARAM_VALUE.OutFifoDepth } {
	# Procedure called to validate OutFifoDepth
	return true
}

proc update_PARAM_VALUE.UserWidth { PARAM_VALUE.UserWidth } {
	# Procedure called to update UserWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UserWidth { PARAM_VALUE.UserWidth } {
	# Procedure called to validate UserWidth
	return true
}


proc update_MODELPARAM_VALUE.AddrWidth { MODELPARAM_VALUE.AddrWidth PARAM_VALUE.AddrWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AddrWidth}] ${MODELPARAM_VALUE.AddrWidth}
}

proc update_MODELPARAM_VALUE.DataWidth { MODELPARAM_VALUE.DataWidth PARAM_VALUE.DataWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DataWidth}] ${MODELPARAM_VALUE.DataWidth}
}

proc update_MODELPARAM_VALUE.UserWidth { MODELPARAM_VALUE.UserWidth PARAM_VALUE.UserWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UserWidth}] ${MODELPARAM_VALUE.UserWidth}
}

proc update_MODELPARAM_VALUE.IdWidth { MODELPARAM_VALUE.IdWidth PARAM_VALUE.IdWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IdWidth}] ${MODELPARAM_VALUE.IdWidth}
}

proc update_MODELPARAM_VALUE.NumBanks { MODELPARAM_VALUE.NumBanks PARAM_VALUE.NumBanks } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NumBanks}] ${MODELPARAM_VALUE.NumBanks}
}

proc update_MODELPARAM_VALUE.BufDepth { MODELPARAM_VALUE.BufDepth PARAM_VALUE.BufDepth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BufDepth}] ${MODELPARAM_VALUE.BufDepth}
}

proc update_MODELPARAM_VALUE.HideStrb { MODELPARAM_VALUE.HideStrb PARAM_VALUE.HideStrb } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HideStrb}] ${MODELPARAM_VALUE.HideStrb}
}

proc update_MODELPARAM_VALUE.OutFifoDepth { MODELPARAM_VALUE.OutFifoDepth PARAM_VALUE.OutFifoDepth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OutFifoDepth}] ${MODELPARAM_VALUE.OutFifoDepth}
}

