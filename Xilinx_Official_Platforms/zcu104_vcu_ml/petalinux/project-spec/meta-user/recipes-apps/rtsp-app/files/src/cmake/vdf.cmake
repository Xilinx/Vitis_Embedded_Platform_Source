# Compiler defines/flags
set (VDF_CDEFS_PFM PLATFORM_ZCU102 CACHE INTERNAL "")
set (VDF_CDEFS_REL __FORTIFY_SOURCE=2 CACHE INTERNAL "")
set (VDF_CFLAGS -Wall -fstack-protector-strong CACHE INTERNAL "")
set (VDF_CFLAGS_DBG -O0 -ggdb3 CACHE INTERNAL "")
set (VDF_CFLAGS_REL -O3 CACHE INTERNAL "")
set (VDF_CFLAGS_RELDBG -O3 -ggdb3 CACHE INTERNAL "")

# Helper macro
macro (GetVarFromCmdlOrEnv var dflt)
	if (NOT DEFINED ${var})
		if (NOT DEFINED ENV{${var}})
			message (WARNING "'${var}' not specified using '${dflt}'")
			set (${var} ${dflt})
		else()
			set (${var} $ENV{${var}})
		endif()
	endif()
endmacro()
