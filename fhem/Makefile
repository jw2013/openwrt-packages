include $(TOPDIR)/rules.mk

FHEM_RELEASE=6.4
FHEM_SVN_COMMIT:=29803

PKG_NAME:=fhem
PKG_VERSION:=$(FHEM_RELEASE)
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://fhem.de/
PKG_HASH:=0062f618a579b6dbf9b3dc2c24fb2357e88761ec97b46001b84440c09c0cb117

PKG_MAINTAINER:=Jens Wagner <jens@wagner2013.de>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=docs/copyright

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

PKG_VERSION:=$(FHEM_RELEASE).$(FHEM_SVN_COMMIT)

define Package/fhem-template
  SECTION:=fhem
  CATEGORY:=FHEM
  URL:=https://fhem.de/
  PKGARCH:=all
endef

define Package/fhem-bin
  $(call Package/fhem-template)
  TITLE:=FHEM client for house automation
  DEPENDS:=+perl +perlbase-essential +perlbase-storable +perlbase-io +perlbase-time +perlbase-scalar +perlbase-posix +perlbase-file +perlbase-list +perlbase-encode
endef

define Package/fhem-bin/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fhem.pl $(1)/usr/bin/fhem
endef

define Package/fhem-service
  $(call Package/fhem-template)
  TITLE:=FHEM server for house automation
  DEPENDS:=+fhem-bin
  USERID:=fhem:fhem
endef

define Package/fhem-service/conffiles
/etc/config/fhem/fhem.cfg
/etc/config/fhem/uniqueID
endef

define Package/fhem-service/install
	$(INSTALL_DIR) $(1)/usr/share/fhem/FHEM
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config/fhem/mod.cfg.d
	$(INSTALL_BIN) ./files/fhem.sh $(1)/etc/init.d/fhem
	$(CP) ./files/fhem.cfg $(1)/etc/config/fhem/
	$(CP) ./files/uniqueID $(1)/etc/config/fhem/

	# FhemUtils is used as a cache directory, and for uniqueID
	$(LN) -s /var/cache/fhem $(1)/usr/share/fhem/FHEM/FhemUtils

	# fhem.pl always requires RTypes.pm despite being empty
	$(CP) $(PKG_BUILD_DIR)/FHEM/RTypes.pm $(1)/usr/share/fhem/FHEM/

	# fhem.pl requires DevIo.pm for defs with DeviceName
	$(CP) $(PKG_BUILD_DIR)/FHEM/DevIo.pm $(1)/usr/share/fhem/FHEM/

	# DevIo.pm uses HttpUtils.pm
	$(CP) $(PKG_BUILD_DIR)/FHEM/HttpUtils.pm $(1)/usr/share/fhem/FHEM/

	# fhem.pl requires TimeSeries.pm for .ts readings
	$(CP) $(PKG_BUILD_DIR)/FHEM/TimeSeries.pm $(1)/usr/share/fhem/FHEM/

	# fhem.pl calls some subs from TcpServerUtils.pm directly
	$(CP) $(PKG_BUILD_DIR)/FHEM/TcpServerUtils.pm $(1)/usr/share/fhem/FHEM/

	# not required to run fhem.pl, but used by many mods, and very small
	$(CP) $(PKG_BUILD_DIR)/FHEM/SetExtensions.pm $(1)/usr/share/fhem/FHEM/
	$(CP) $(PKG_BUILD_DIR)/FHEM/GPUtils.pm $(1)/usr/share/fhem/FHEM/
	$(CP) $(PKG_BUILD_DIR)/FHEM/Blocking.pm $(1)/usr/share/fhem/FHEM/

	# AttrTemplate.pm is used by by SetExtensions.pm
	$(CP) $(PKG_BUILD_DIR)/FHEM/AttrTemplate.pm $(1)/usr/share/fhem/FHEM/

	# This module is autoloaded
	$(CP) $(PKG_BUILD_DIR)/FHEM/99_Utils.pm $(1)/usr/share/fhem/FHEM/
endef

define Package/fhem-service/postinst
  #!/bin/sh
  chown fhem:fhem /etc/config/fhem/fhem.cfg
  chown fhem:fhem /etc/config/fhem/uniqueID
  chmod 0600 /etc/config/fhem/uniqueID
endef

define Package/fhem-template-mod
  $(call Package/fhem-template)
  SUBMENU:=Modules
  DEPENDS:=fhem-service
endef

define Package/fhem-template-lib
  $(call Package/fhem-template)
  SUBMENU:=Libraries
  DEPENDS:=fhem-service
endef

define Package/fhem-template-theme
  $(call Package/fhem-template)
  SUBMENU:=Themes
  DEPENDS:=fhem-service
endef

define DefineFHEMModule
  $(eval $@_PKG = $(1))
  $(eval $@_ORDER = $(2))
  $(eval $@_MOD = $(3))
  $(eval $@_TITLE = $(4))
  $(eval $@_DEP = $(5))
  $(eval $@_FILES = $(6))
ifndef Package/${$@_PKG}
define Package/${$@_PKG}
  $(call Package/fhem-template-mod)
  ifneq (,${$@_TITLE})
    TITLE:=${$@_TITLE}
  else
    TITLE:=FHEM Module ${$@_MOD}
  endif
  ifneq (${$@_DEP},)
    DEPENDS+=${$@_DEP}
  endif
endef
endif

  $(eval $@_CONFIG = ${$@_ORDER}_${$@_MOD}.cfg)
  ifeq (,$(wildcard files/${$@_CONFIG}))
    $(eval $@_CONFIG = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,${$@_CONFIG})))))))))))))))))))))))))))
  endif

ifneq (,$(wildcard files/${$@_CONFIG}))
ifndef Package/${$@_PKG}/postinst
define Package/${$@_PKG}/postinst
#!/bin/sh
chown fhem:fhem /etc/config/fhem/mod.cfg.d/${$@_CONFIG}
endef
endif
ifndef Package/${$@_PKG}/conffiles
define Package/${$@_PKG}/conffiles
/etc/config/fhem/mod.cfg.d/${$@_CONFIG}
endef
endif
ifndef Package/${$@_PKG}/install
define Package/${$@_PKG}/install
	$$(INSTALL_DIR) $$(1)/usr/share/fhem/FHEM
	$$(INSTALL_DIR) $$(1)/etc/config/fhem/mod.cfg.d
	$$(CP) ./files/${$@_CONFIG} $$(1)/etc/config/fhem/mod.cfg.d/
	cd $$(PKG_BUILD_DIR) && rsync --relative -rlHp --prune-empty-dirs FHEM/${$@_ORDER}_${$@_MOD}.pm ${$@_FILES} $$(1)/usr/share/fhem/
endef
endif
else
ifndef Package/${$@_PKG}/install
define Package/${$@_PKG}/install
	$$(INSTALL_DIR) $$(1)/usr/share/fhem/FHEM
	cd $$(PKG_BUILD_DIR) && rsync --relative -rlHp --prune-empty-dirs FHEM/${$@_ORDER}_${$@_MOD}.pm ${$@_FILES} $$(1)/usr/share/fhem/
endef
endif
endif

endef



define BuildFHEMModule
  $(eval $@_ORDER = $(1))
  $(eval $@_MOD = $(2))
  $(eval $@_TITLE = $(3))
  $(eval $@_DEP = $(4))
  $(eval $@_FILES = $(5))
  $(eval $@_PKG = fhem-mod-$(subst _,-,$(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,${$@_MOD}))))))))))))))))))))))))))))
  $(eval $(call DefineFHEMModule,${$@_PKG},${$@_ORDER},${$@_MOD},${$@_TITLE},${$@_DEP},${$@_FILES}))
  $(eval $(call BuildPackage,${$@_PKG}))
endef



define DefineFHEMLibrary
  $(eval $@_PKG = $(1))
  $(eval $@_TITLE = $(2))
  $(eval $@_DEP = $(3))
  $(eval $@_FILES = $(4))
ifndef Package/${$@_PKG}
define Package/${$@_PKG}
  $(call Package/fhem-template-lib)
  TITLE:=${$@_TITLE}
  ifneq (${$@_DEP},)
    DEPENDS+=${$@_DEP}
  endif
endef
endif

ifndef Package/${$@_PKG}/install
define Package/${$@_PKG}/install
	$$(INSTALL_DIR) $$(1)/usr/share/fhem
	cd $$(PKG_BUILD_DIR) && rsync --relative -rlHp --prune-empty-dirs ${$@_FILES} $$(1)/usr/share/fhem/
endef
endif
endef

define BuildFHEMLibrary
  $(eval $@_PKG = $(1))
  $(eval $@_TITLE = $(2))
  $(eval $@_DEP = $(3))
  $(eval $@_FILES = $(4))
  $(eval $(call DefineFHEMLibrary,${$@_PKG},${$@_TITLE},${$@_DEP},${$@_FILES}))
  $(eval $(call BuildPackage,${$@_PKG}))
endef


define DefineFHEMTheme
  $(eval $@_PKG = $(1))
  $(eval $@_TITLE = $(2))
  $(eval $@_DEP = $(3))
  $(eval $@_FILES = $(4))
ifndef Package/${$@_PKG}
define Package/${$@_PKG}
  $(call Package/fhem-template-theme)
  TITLE:=${$@_TITLE}
  ifneq (${$@_DEP},)
    DEPENDS+=${$@_DEP}
  endif
endef
endif
endef


define BuildFHEMTheme
  $(eval $@_PKG = $(1))
  $(eval $@_TITLE = $(2))
  $(eval $@_DEP = $(3))
  $(eval $@_FILES = $(4))
  $(eval $(call DefineFHEMTheme,${$@_PKG},${$@_TITLE},${$@_DEP},${$@_FILES}))
  $(eval $(call DefineFHEMLibrary,${$@_PKG},${$@_TITLE},${$@_DEP},${$@_FILES}))
  $(eval $(call BuildPackage,${$@_PKG}))
endef

$(eval $(call BuildPackage,fhem-bin))
$(eval $(call BuildPackage,fhem-service))

include modules.mk

