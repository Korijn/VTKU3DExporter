from pathlib import Path
import tempfile

from test_u3d_generation import test_u3d_generation


if __name__ == "__main__":
    with tempfile.TemporaryDirectory() as tmpdirname:
        test_u3d_generation(Path(tmpdirname))

    print("Test passed")
