# Python API Workflows

Back to [Aristotle docs home](README.md). See also [CLI workflows](CLI_WORKFLOWS.md).

## Setup

Install `aristotlelib` first:

```bash
uv tool install aristotlelib
```

Use a placeholder only:

```bash
export ARISTOTLE_API_KEY="<YOUR_ARISTOTLE_API_KEY>"
```

## Shared Async Skeleton

```python
import asyncio
import os

from aristotlelib import AristotleAPIError, Project


async def main() -> None:
    api_key = os.environ["ARISTOTLE_API_KEY"]
    print(f"Using Aristotle key from environment: {bool(api_key)}")


if __name__ == "__main__":
    asyncio.run(main())
```

## Prompt-Only Usage

```python
import asyncio
from aristotlelib import Project


async def main() -> None:
    project = await Project.create(
        prompt="Prove that there are infinitely many primes."
    )
    await project.wait_for_completion()
    solution = await project.get_solution()
    print(solution)


if __name__ == "__main__":
    asyncio.run(main())
```

## Create From Directory For Repo Validation

Use the repository root as project context:

```python
import asyncio
from aristotlelib import Project


async def main() -> None:
    project = await Project.create_from_directory(
        project_dir=".",
        prompt=(
            "Validate the Lean project in this repository. "
            "Do not widen the phase-1 import surface. "
            "Keep OnePostulate.lean free of OnePostulate.ClassificationDerivation. "
            "Check OnePostulate.lean, OnePostulate/ClassificationDerivation.lean, "
            "and OnePostulateFull.lean carefully."
        ),
    )
    await project.wait_for_completion()
    print(project.id)
    print(await project.get_solution())


if __name__ == "__main__":
    asyncio.run(main())
```

## Create From Directory For Paper Formalization

```python
import asyncio
from aristotlelib import Project


async def main() -> None:
    project = await Project.create_from_directory(
        project_dir=".",
        prompt=(
            "Formalize mathematics from paper/one-postulate.tex into Lean-oriented "
            "output without widening the phase-1 import surface."
        ),
    )
    await project.wait_for_completion()
    print(await project.get_solution())


if __name__ == "__main__":
    asyncio.run(main())
```

## Reopen An Existing Project

```python
import asyncio
from aristotlelib import Project


async def main() -> None:
    project = await Project.from_id("<PROJECT_ID>")
    await project.refresh()
    print(project)
    print(await project.get_input())


if __name__ == "__main__":
    asyncio.run(main())
```

## List Projects

```python
import asyncio
from aristotlelib import Project


async def main() -> None:
    projects = await Project.list_projects()
    for project in projects:
        print(project)


if __name__ == "__main__":
    asyncio.run(main())
```

## Wait, Refresh, And Fetch Results

```python
import asyncio
from aristotlelib import Project


async def main() -> None:
    project = await Project.from_id("<PROJECT_ID>")
    await project.refresh()
    await project.wait_for_completion()
    input_payload = await project.get_input()
    solution_payload = await project.get_solution()
    print(input_payload)
    print(solution_payload)


if __name__ == "__main__":
    asyncio.run(main())
```

## Cancel A Project

```python
import asyncio
from aristotlelib import Project


async def main() -> None:
    project = await Project.from_id("<PROJECT_ID>")
    await project.cancel()
    await project.refresh()
    print(project)


if __name__ == "__main__":
    asyncio.run(main())
```

## Error Handling

```python
import asyncio
from aristotlelib import AristotleAPIError, Project


async def main() -> None:
    try:
        project = await Project.create_from_directory(
            project_dir=".",
            prompt="Validate the Lean project in this repository."
        )
        await project.wait_for_completion()
        print(await project.get_solution())
    except AristotleAPIError as exc:
        print("Aristotle API request failed:")
        print(exc)


if __name__ == "__main__":
    asyncio.run(main())
```

## Repo-Specific Guidance

- Use `project_dir="."` from the repository root when validating local Lean outputs.
- Use a narrower prompt when dealing with `OnePostulate/ClassificationDerivation.lean` or `OnePostulateFull.lean`.
- Do not use the Python API to widen the phase-1 root:
  - do not import `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
  - keep deferred/full-paper work separate from phase-1 validation
- Aristotle can use Lean files, Markdown notes, and paper text from the project directory. It resolves imports automatically and skips build artifacts.

## See Also

- [CLI workflows](CLI_WORKFLOWS.md)
- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)

