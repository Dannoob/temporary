# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/lighthouse-os/manifest.git -b raft -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/Dreadwyrm/local_manifests --depth 1 -b ginkgo-Lighthouse .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8 || repo sync -c -q --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

# build rom
. build/envsetup.sh
lunch lighthouse_ginkgo-userdebug
export TZ=Asia/Jakarta #put before last build command
mka lighthouse

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
