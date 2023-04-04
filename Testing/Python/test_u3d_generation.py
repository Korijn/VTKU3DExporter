from pathlib import Path

import vtk
from vtk.util.keys import StringKey
from vtk.vtkCommonCore import vtkInformationIterator
from vtk import vtkU3DExporter


STL_PATH = Path(__file__).parent / "test.stl"


def write_u3d(file_path, actors):
    render_window = vtk.vtkRenderWindow()
    render_window.OffScreenRenderingOn()
    renderer = vtk.vtkRenderer()
    render_window.AddRenderer(renderer)

    for actor in actors:
        renderer.AddActor(actor)

    renderer.ResetCamera()

    u3d_exporter = vtkU3DExporter.vtkU3DExporter()
    u3d_exporter.SetFileName(file_path)
    u3d_exporter.SetInput(render_window)
    u3d_exporter.Write()


def create_actor_from_stl(path):
    assert path.exists(), f"STL file {path} does not exist"
    reader = vtk.vtkSTLReader()
    reader.SetFileName(path)

    mapper = vtk.vtkPolyDataMapper()
    mapper.SetInputConnection(reader.GetOutputPort())

    actor = vtk.vtkActor()
    actor.SetMapper(mapper)
    return actor


def set_name_for_actor(name, actor):
    """
    Sets the name in the PropertyKeys of a vtkActor
    """
    key = StringKey.MakeKey("MeshName", "root")
    i = vtk.vtkInformation()
    i.Set(key, name)
    actor.SetPropertyKeys(i)


def get_name_for_actor(actor, keyName="MeshName"):
    """
    Returns the name from the PropertyKeys of a vtkActor
    """
    information = actor.GetPropertyKeys()
    if information is None:
        return None

    iterator = vtkInformationIterator()
    iterator.SetInformation(information)
    iterator.InitTraversal()
    while not iterator.IsDoneWithTraversal():
        key = iterator.GetCurrentKey()
        if key.GetName() == keyName:
            return information.Get(key)
        iterator.GoToNextItem()
    return None


def test_u3d_generation(tmp_path):
    # Create cube
    cube = vtk.vtkCubeSource()

    # Mapper
    cubeMapper = vtk.vtkPolyDataMapper()
    cubeMapper.SetInputData(cube.GetOutput())

    # Actor
    cubeActor = vtk.vtkActor()
    cubeActor.SetMapper(cubeMapper)
    assert get_name_for_actor(cubeActor) is None

    stlActor = create_actor_from_stl(STL_PATH)
    set_name_for_actor("a9p", stlActor)
    assert get_name_for_actor(stlActor) == "a9p"

    # Construct file paths
    filename = "test_report"
    file_path = tmp_path / filename
    u3d_path = file_path.with_suffix(".u3d")
    log_file_path = file_path.with_suffix(".u3d.DebugInfo.txt")

    # Write the u3d file to the file path
    write_u3d(file_path, [cubeActor, stlActor])

    # Check that we have successfully created a U3D file
    assert u3d_path.exists(), "Failed to create the U3D file"

    # Check that the mesh is in the logs
    log_content = log_file_path.open().read()
    assert " Mesh2\n" in log_content, "Mesh2 not found in U3D debug logs"
    