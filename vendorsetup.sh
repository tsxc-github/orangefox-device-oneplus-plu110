# SPDX-License-Identifier: Apache-2.0

# Source build/envsetup.sh with FOX_BUILD_DEVICE=plu110.
if [[ ${FOX_BUILD_DEVICE:-} == plu110 ]]; then
    export FOX_AB_DEVICE=1
    export FOX_VIRTUAL_AB_DEVICE=1
    export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=1
    export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1
    export OF_SCREEN_H=2772

    # Validate one recovery slot from fastboot before offering automated installation.
    export FOX_DISABLE_UPDATEZIP=1
    export OF_NO_REFLASH_CURRENT_ORANGEFOX=1
fi
