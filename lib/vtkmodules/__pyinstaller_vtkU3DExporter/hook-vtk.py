from pathlib import Path

from PyInstaller.utils.hooks import collect_all, collect_dynamic_libs


# if VTK would provide its own pyinstaller hook,
# we would want to package only the new files here
# to do so, flip this boolean flag to True
# until then, we have to package VTK in its entirety
# together with VTKU3DExporter's additional files
# to keep it that way, leave the flag at False
PACKAGE_VTKU3DEXPORTER_ONLY = False


if PACKAGE_VTKU3DEXPORTER_ONLY:
    hiddenimports = ["vtkmodules.vtkU3DExporter"]

    expected_binaries = {
        "IFXCore.dll",
        "IFXExporting.dll",
        "IFXImporting.dll",
        "IFXScheduling.dll",
        "vtkU3DExporter.dll",
    }
    found_binaries = collect_dynamic_libs("vtkmodules")
    binaries = []

    for src, dest in found_binaries:
        if Path(src).name in expected_binaries:
            binaries.append((src, dest))

    if set(Path(src).name for src, _ in binaries) != expected_binaries:
        raise Exception("failed to collect expected binaries for vtkU3DExporter")

else:
    datas, binaries, hiddenimports = collect_all('vtkmodules')
