#
# Libraries:
# $(eval $(call BuildFHEMLibrary,{PKG-NAME},{TITLE},{DEPENDENCIES},{FILE1 FILE2 ...}))
#
# Themes:
# $(eval $(call BuildFHEMTheme,{PKG-NAME},{TITLE},{DEPENDENCIES},{FILE1 FILE2 ...}))
#
# Modules:
# $(eval $(call BuildFHEMModule,{ORDER-NR},{MODULE},{TITLE},{DEPENDENCIES},{FILE1 FILE2 ...}))
#

$(eval $(call BuildFHEMLibrary,fhem-color,FHEM::Color,,FHEM/Color.pm))
$(eval $(call BuildFHEMLibrary,fhem-lib-httpmod-utils,FHEM::HTTPMOD::Utils,,lib/FHEM/HTTPMOD/Utils.pm))
$(eval $(call BuildFHEMLibrary,fhem-lib-modbus-testutils,FHEM::Modbus::TestUtils,,lib/FHEM/Modbus/TestUtils.pm))

$(eval $(call BuildFHEMTheme,fhem-theme-pgm2-default,FHEMWEB Default Theme,,www/pgm2/style.css www/pgm2/defaultCommon.css www/pgm2/dashboard_style.css www/pgm2/svg_style.css www/pgm2/svg_defs.svg www/images/default/fhemicon.png))

$(eval $(call BuildFHEMTheme,fhem-theme-pgm2-dark,FHEMWEB Dark Theme,,www/pgm2/darkstyle.css www/pgm2/darkCommon.css www/pgm2/dashboard_darkstyle.css www/pgm2/darksvg_style.css www/pgm2/darksvg_defs.svg www/images/default/fhemicon_dark.png))

# From here? https://github.com/OpenAutomationProject/knx-uf-iconset
$(eval $(call BuildFHEMTheme,fhem-icons-base,FHEM Base Icons,,--files-from openwrt/icons-base.txt .))
$(eval $(call BuildFHEMTheme,fhem-icons-fhemsvg,FHEM SVG Icons,+fhem-icons-base,--exclude-from openwrt/icons-base.txt www/images/fhemSVG))
$(eval $(call BuildFHEMTheme,fhem-icons-openautomation,FHEM OpenAutomation Icons,+fhem-icons-base,--exclude-from openwrt/icons-base.txt www/images/openautomation))


$(eval $(call BuildFHEMModule,01,FHEMWEB,FHEMWEB Service,+perlbase-digest +fhem-theme-pgm2-default,www/pgm2/fhemweb.js www/pgm2/jquery.min.js www/pgm2/jquery-ui.min.js www/pgm2/jquery-ui.min.css www/images/default/favicon.ico))

$(eval $(call BuildFHEMModule,47,OBIS))
$(eval $(call BuildFHEMModule,90,at))
$(eval $(call BuildFHEMModule,91,notify))
$(eval $(call BuildFHEMModule,91,sequence))
$(eval $(call BuildFHEMModule,91,watchdog))
$(eval $(call BuildFHEMModule,92,FileLog))
$(eval $(call BuildFHEMModule,98,DOIF,,+fhem-color))
$(eval $(call BuildFHEMModule,98,JsonList2,FHEM Command jsonlist2))
$(eval $(call BuildFHEMModule,98,help,FHEM Command help,,docs/commandref_frame.html docs/commandref_frame_DE.html))
$(eval $(call BuildFHEMModule,98,Modbus,,+fhem-lib-httpmod-utils +perl-device-serialport,lib/FHEM/Modbus/modTemplate))
$(eval $(call BuildFHEMModule,98,ModbusAttr,,+fhem-mod-modbus))
$(eval $(call BuildFHEMModule,98,telnet,FHEM Telnet Service))


