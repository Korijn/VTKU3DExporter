# vtk-u3dexporter

[![Build Wheels](https://github.com/ClinicalGraphics/VTKU3DExporter/actions/workflows/build_wheels.yml/badge.svg)](https://github.com/ClinicalGraphics/VTKU3DExporter/actions/workflows/build_wheels.yml)
[![PyPI Version](https://img.shields.io/pypi/v/vtk-u3dexporter.svg)](https://pypi.python.org/pypi/vtk-u3dexporter)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`vtk-u3dexporter` is a VTK module for exporting a VTK 3D scene to the U3D file format, which can be embedded into PDF files.

It is available as both C++ class and a Python package.

## Installation

You can install `vtk-u3dexporter` via pip:

```sh
pip install vtk-u3dexporter
```

## Usage

Here is a brief example of how to use `vtk-u3dexporter` to export a simple cube scene:

```python
import os
import vtk
from vtk import vtkU3DExporter

# Define the cube source
cube = vtk.vtkCubeSource()

# Define the cube mapper
cubeMapper = vtk.vtkPolyDataMapper()
cubeMapper.SetInputConnection(cube.GetOutputPort())

# Define the cube actor
cubeActor = vtk.vtkActor()
cubeActor.SetMapper(cubeMapper)

# Define the render window and renderer
renderWindow = vtk.vtkRenderWindow()
renderWindow.OffScreenRenderingOn()
renderer = vtk.vtkRenderer()
renderWindow.AddRenderer(renderer)

# Add the cube to the renderer
renderer.AddActor(cubeActor)

# Automatically reset the camera
renderer.ResetCamera()

# Define the output file name, which will have the ".u3d" extension appended automatically
filePath = "cube"

# Export to U3D
u3dExporter = vtkU3DExporter.vtkU3DExporter()
u3dExporter.SetFileName(filePath)
u3dExporter.SetInput(renderWindow)
u3dExporter.Write()

# Check that the file exists
assert os.path.exists(f"{filePath}.u3d")
```

In this example, we create a simple cube scene using VTK, add it to a renderer, and then export it to U3D format using `vtk-u3dexporter`. We then verify that the output file exists.

## License

`vtk-u3dexporter` is distributed under the Apache License 2.0. Please see the [LICENSE][LICENSE] file for details.

[LICENSE]: https://github.com/ClinicalGraphics/VTKU3DExporter/blob/main/LICENSE

## Resources

* [VTK website](https://docs.vtk.org)
* [U3D file format specification](https://www.ecma-international.org/publications-and-standards/standards/ecma-363/)
