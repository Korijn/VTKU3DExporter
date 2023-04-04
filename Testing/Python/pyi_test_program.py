import os
from pathlib import Path
import sys
import tempfile

from vtk import vtkU3DExporter

from test_u3d_generation import test_u3d_generation


if __name__ == "__main__":
    # Workaround current limitation of IFXOSLoader.cpp. This is required
    # to ensure the IFXCore library can be loaded.
    os.environ["U3D_LIBDIR"] = os.path.dirname(vtkU3DExporter.__file__)

    with tempfile.TemporaryDirectory() as tmpdirname:
        test_u3d_generation(Path(tmpdirname), stl_path=Path(sys.argv[-1]))

    print("Test passed")
