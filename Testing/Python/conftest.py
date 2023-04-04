import os

from vtk import vtkU3DExporter


# Workaround current limitation of IFXOSLoader.cpp. This is required
# to ensure the IFXCore library can be loaded.
os.environ["U3D_LIBDIR"] = os.path.dirname(vtkU3DExporter.__file__)
