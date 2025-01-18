################################################################################
#
# rockchip-mali
#
################################################################################

# Full sha1 is 721653b5b3b525a4f80d15aa7e2f9df7b7e60427, but we use the
# "mirrors" repository, which names the top-level directory "mirrors-VERSION"
# while the original was the "libmali" repository which named the top-level
# directory "libmali-VERSION". Hence the content changes, and thus the hash
# changes.
# To avoid conflict with the old tarball on s.b.o. used by older versions of
# Buildroot, we can't use the same filename for the generated archive, so we
# drop the last char in the commit hash.


#ROCKCHIP_MALI_VERSION = ab3d91e3df2ef1c487c2d8f69daea1729668e428
#ROCKCHIP_MALI_SITE = $(call github,JeffyCN,mirrors,$(ROCKCHIP_MALI_VERSION))
#ROCKCHIP_MALI_LICENSE = Proprietary


ROCKCHIP_MALI_VERSION = 92183c8482e6173fa510f228e62b1c73c99be87d
ROCKCHIP_MALI_SITE = $(call github,JeffyCN,mirrors,$(ROCKCHIP_MALI_VERSION))
ROCKCHIP_MALI_LICENSE = Proprietary

ROCKCHIP_MALI_LICENSE_FILES = END_USER_LICENCE_AGREEMENT.txt
ROCKCHIP_MALI_INSTALL_STAGING = YES
ROCKCHIP_MALI_DEPENDENCIES = host-patchelf libdrm

ifeq ($(BR2_PACKAGE_PX3SE),y)
ROCKCHIP_MALI_GPU = utgard-400
ROCKCHIP_MALI_VER = r7p0
ROCKCHIP_MALI_SUBVER = r3p0
else ifneq ($(BR2_PACKAGE_RK312X)$(BR2_PACKAGE_RK3128H)$(BR2_PACKAGE_RK3036)$(BR2_PACKAGE_RK3032),)
ROCKCHIP_MALI_GPU = utgard-400
ROCKCHIP_MALI_VER = r7p0
ROCKCHIP_MALI_SUBVER = r1p1
else ifeq ($(BR2_PACKAGE_RK3328),y)
ROCKCHIP_MALI_GPU = utgard-450
ROCKCHIP_MALI_VER = r7p0
else ifeq ($(BR2_PACKAGE_RK3288),y)
ROCKCHIP_MALI_GPU = midgard-t76x
ROCKCHIP_MALI_VER = r18p0
ROCKCHIP_MALI_SUBVER = all
else ifneq ($(BR2_PACKAGE_RK3399)$(BR2_PACKAGE_RK3399PRO),)
ROCKCHIP_MALI_GPU = midgard-t86x
ROCKCHIP_MALI_VER = r18p0
else ifneq ($(BR2_PACKAGE_RK3326)$(BR2_PACKAGE_PX30),)
ROCKCHIP_MALI_GPU = bifrost-g31
ROCKCHIP_MALI_VER = g2p0
else ifeq ($(BR2_PACKAGE_RK356X),y)
ROCKCHIP_MALI_GPU = bifrost-g52
ROCKCHIP_MALI_VER = g2p0
else ifeq ($(BR2_PACKAGE_RK3588),y)
ROCKCHIP_MALI_GPU = valhall-g610
ROCKCHIP_MALI_VER = g6p0
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_HAS_EGL),y)
ROCKCHIP_MALI_PROVIDES += libegl
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_HAS_GBM),y)
ROCKCHIP_MALI_PROVIDES += libgbm
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_HAS_GLES),y)
ROCKCHIP_MALI_PROVIDES += libgles
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_HAS_OPENCL),y)
ROCKCHIP_MALI_PROVIDES += libopencl
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_ONLY_CL),y)
ROCKCHIP_MALI_PLATFORM = only-cl
else ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_DUMMY),y)
ROCKCHIP_MALI_PLATFORM = dummy
else ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_WAYLAND),y)
ROCKCHIP_MALI_PLATFORM = wayland
ROCKCHIP_MALI_DEPENDENCIES += wayland
else ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_X11),y)
ROCKCHIP_MALI_PLATFORM = x11
ROCKCHIP_MALI_DEPENDENCIES += libxcb xlib_libX11
else ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_GBM),y)
ROCKCHIP_MALI_PLATFORM = gbm
endif

ROCKCHIP_MALI_CONF_OPTS += \
	-Dwith-overlay=true -Dopencl-icd=false -Dkhr-header=true \
	-Dplatform=$(ROCKCHIP_MALI_PLATFORM) -Dgpu=$(ROCKCHIP_MALI_GPU) \
	-Dversion=$(ROCKCHIP_MALI_VER)

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_WITHOUT_CL),y)
ROCKCHIP_MALI_SUBVER += without-cl
endif

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_WITH_DUMMY)|$(BR2_PACKAGE_ROCKCHIP_MALI_DUMMY),y|)
ROCKCHIP_MALI_SUBVER += dummy
endif

ROCKCHIP_MALI_CONF_OPTS += \
	-Dsubversion=$(subst $(eval) $(eval),-,$(ROCKCHIP_MALI_SUBVER))

ifeq ($(BR2_PACKAGE_ROCKCHIP_MALI_OPTIMIZE_s),y)
ROCKCHIP_MALI_CONF_OPTS += -Doptimize-level=Os
endif

$(eval $(meson-package))
