# vtk-u3dexporter

U3D is a format for 3D models that can be embedded into PDF.

## License

This project is distributed under the Apache license. Please see the [LICENSE][LICENSE] file for details.

[LICENSE]: https://github.com/ClinicalGraphics/VTKU3DExporter/blob/main/LICENSE

## Running the build locally on Windows

First time:

```pwsh
$env:CIBW_TEST_COMMAND = "pip install -r {package}/Testing/Python/requirements.txt && pytest {package}/Testing/Python && python {package}/test.py"
.venv/Scripts/cibuildwheel --only cp39-win_amd64
```

Subsequent builds require clearing the `_skbuild` and `wheelhouse` folders or they will fail:

```pwsh
Remove-Item -Recurse -Force ./_skbuild && Remove-Item -Recurse -Force ./wheelhouse && .venv/Scripts/cibuildwheel --only cp39-win_amd64
```