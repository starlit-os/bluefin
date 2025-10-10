from typing import Annotated

import dagger
from dagger import DefaultPath, dag, function, object_type


@object_type
class Bluefin:
    source: Annotated[dagger.Directory, DefaultPath(".")]

    def _base_container(self) -> dagger.Container:
        """Internal helper to add common cache mounts."""
        return (
            dag.container().from_("ghcr.io/ublue-os/bluefin:stable-daily")
            .with_mounted_cache("/var/roothome", dag.cache_volume("var-roothome"))
            .with_mounted_cache("/var/cache", dag.cache_volume("var-cache"))
            .with_mounted_cache("/var/log", dag.cache_volume("var-log"))
            .with_mounted_cache("/var/tmp", dag.cache_volume("var-tmp"))
            .with_mounted_cache("/var/lib/dnf", dag.cache_volume("var-lib-dnf"))
        )

    @function
    def bluefin_container(self) -> dagger.Container:
        """Returns a container with the bluefin image"""    
        return (
            self._base_container()
            .with_directory("/", self.source.directory("system_files"))
            .with_exec(["mkdir", "-p", "/var/opt"])
            .with_exec(["dnf", "-y", "copr", "enable", "gvalkov/vicinae"])
            .with_exec(["dnf", "-y", "config-manager", "setopt", "rpmfusion*.enabled=1", "terra.enabled=1"])
            .with_exec([
                "dnf",
                "-y",
                "install",
                "coolercontrol",
			    "headsetcontrol",
			    "liquidctl",
                "lutris",
			    "openrgb",
			    "https://vencord.dev/download/vesktop/amd64/rpm",
			    "vicinae",
			    "warp-terminal"
            ])
            .with_exec(["dnf", "-y", "copr", "disable", "gvalkov/vicinae"])
            .with_exec(["dnf", "-y", "config-manager", "setopt", "rpmfusion*.enabled=0", "terra.enabled=0", "warpdotdev.enabled=0"])
            .with_exec(["rm", "/usr/bin/warp-terminal"])
            .with_exec(["ln", "-s", "/opt/warpdotdev/warp-terminal/warp", "/usr/bin/warp-terminal"])
            .with_exec(["mv", "/var/opt", "/usr/share/factory/var/opt"])
            .with_exec(["systemctl", "enable", "podman.socket", "podman-restart.service", "podman-auto-update.timer"])
            .with_exec(["bootc", "container", "lint"])
        )

