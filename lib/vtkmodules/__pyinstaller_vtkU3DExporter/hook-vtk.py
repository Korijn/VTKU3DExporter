import os

from PyInstaller.utils.hooks import collect_all


# if VTK would provide its own pyinstaller hook,
# it would most likely be identical to this one
# since all the core VTK files and all VTKU3DExporter
# files that need to be shipped are in the same
# vtkmodules folder.

# so we provide a switch to disable this hook, since
# otherwise pyinstaller may package the same files
# twice, bloating the distributable size for no
# good reason
DISABLE_VTKU3DEXPORTER_PYI_HOOK = os.environ.get("DISABLE_VTKU3DEXPORTER_PYI_HOOK", "0").strip() == "1"

if not DISABLE_VTKU3DEXPORTER_PYI_HOOK:
    datas, binaries, hiddenimports = collect_all('vtkmodules')
