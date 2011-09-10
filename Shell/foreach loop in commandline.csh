/clearlib/passport=>12 % lue adli.21<--- list all the elements in update adli.21
  /clearlib/pp_27/pvg/inc/private/dspLoggingCmn.h
  /clearlib/pp_27/pvg/vspApMgmt/tools/dspLogging/pdcDspLgDataUploader.cc
  /clearlib/pp_27/pvg/vspApMgmt/tools/dspLogging/pdcDspLgLogger.cc
…
/clearlib/passport=>13 % /clearlib/passport=>25 % foreach file (`lue adli.21`)
? cp $file ~/tempDir/
? end
/clearlib/passport=>14 % ls ~/tempDir   
Makefile*                            pdcDspLgCloseFileCommand.cc          pdcDspLgHelpCommand.cc*
dspLoggingCmn.h                      pdcDspLgCloseFileCommand.h           pdcDspLgLogger.cc*
pdcDspLgChange2MediaCapCommand.cc    pdcDspLgCommandInterface.cc*         pdcDspLgLogger.h
pdcDspLgChange2MediaCapCommand.h     pdcDspLgCommandMessageFactory.cc*    pdcDspLgStopCommand.cc*
pdcDspLgChange2pdcLoggerCommand.cc   pdcDspLgDataUploader.cc*
pdcDspLgChange2pdcLoggerCommand.h    pdcDspLgDataUploader.h
/clearlib/passport=>27 % foreach file (`lue adli.21`)
? sircc co -nc $file
? end
Created branch "dev_adli_10" from "/clearlib/pp_27/pvg/inc/private/dspLoggingCmn.h" version "/main/common_cdma/mg_msp/1".
Checked out "/clearlib/pp_27/pvg/inc/private/dspLoggingCmn.h" from version "/main/common_cdma/mg_msp/dev_adli_10/0".
Checked out "/clearlib/pp_27/pvg/vspApMgmt/tools/dspLogging/pdcDspLgDataUploader.cc" from version "/main/common_cdma/mg_msp/dev_adli_10/1".
Checked out "/clearlib/pp_27/pvg/vspApMgmt/tools/dspLogging/pdcDspLgLogger.cc" from version "/main/common_cdma/mg_msp/dev_adli_10/1".
Checked out "/clearlib/pp_27/pvg/inc/private/pdcDspLgLogger.h" from version "/main/common_cdma/mg_msp/dev_adli_10/1".
…
/clearlib/passport=>28 % lue adli.21 | xargs upd adli.23 addelem
Applying attributes to elements... (100.00%)     
Elements successfully added to update 'adli.23'.
/clearlib/passport=>29 % upd adli.23
Update ID:      adli.23
Update Status:  open (view: adli_20101109_MG20.4_CDN)
Branch Type:    mg_msp

Comment:
  <none>

Elements:
  [/clearlib/pp_27]/pvg/inc/private/dspLoggingCmn.h@@/main/common_cdma/mg_msp/dev_adli_10 (checked_out_on_branch)
  [/clearlib/pp_27]/pvg/vspApMgmt/tools/dspLogging/pdcDspLgDataUploader.cc@@/main/common_cdma/mg_msp/dev_adli_10 (checked_out_on_branch)
  [/clearlib/pp_27]/pvg/vspApMgmt/tools/dspLogging/pdcDspLgLogger.cc@@/main/common_cdma/mg_msp/dev_adli_10 (checked_out_on_branch)
…


