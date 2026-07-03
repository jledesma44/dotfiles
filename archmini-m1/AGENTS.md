# AGENTS.md

This file contains guidelines for agentic coding agents working in this repository.

## Repository Overview

This is a personal dotfiles repository containing the Dotbot tool and configuration. The main project is a Python-based dotfile management system with YAML configuration.

## Build, Test, and Lint Commands

### Python (dotbot)
The project uses Hatch for build and test management.

**Build:**
```bash
# Build the project
cd dotbot && hatch build

# Install in development mode
cd dotbot && pip install -e .
```

**Testing:**
```bash
# Run all tests
cd dotbot && hatch test

# Run single test file
cd dotbot && hatch run test:test_shell.py

# Run specific test
cd dotbot && hatch run test:test_shell.py::test_shell_command_success

# Run tests with coverage
cd dotbot && hatch run test:cov
```

**Linting and Type Checking:**
```bash
# Run ruff linting
cd dotbot && ruff check src tests

# Run type checking with mypy
cd dotbot && hatch run types:check

# Format code with ruff
cd dotbot && ruff format src tests
```

### PyYAML Submodule
For the embedded PyYAML library:

```bash
cd dotbot/lib/pyyaml
make test
make build
```

## Code Style Guidelines

### Python Style

**General:**
- Use Python 3.7+ syntax
- Follow PEP 8 formatting (enforced by ruff)
- Use strict type checking (mypy --strict)
- Maximum line length: 88 characters (ruff default)

**Imports:**
- Use isort-style grouping: stdlib → third-party → local imports
- Use absolute imports for dotbot modules: `from dotbot.config import ConfigReader`
- Avoid wildcard imports
- Import specific classes/functions, not entire modules when possible

**Type Annotations:**
- All functions must have type hints
- Use `typing` module for complex types: `Optional[str]`, `List[Dict[str, Any]]`
- Use `Any` sparingly; prefer specific types
- Return types are required for all functions
- Use `-> None` for functions that don't return values

**Naming Conventions:**
- Classes: `PascalCase` (e.g., `ConfigReader`, `LinkPlugin`)
- Functions and variables: `snake_case` (e.g., `handle_directive`, `config_data`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `DEFAULT_CONFIG_PATH`)
- Private members: prefix with underscore (e.g., `_internal_method`)
- File names: `snake_case.py`

**Error Handling:**
- Use specific exception classes: `ValueError`, `FileNotFoundError`, etc.
- Create custom exception classes for domain-specific errors
- Always include descriptive error messages
- Use `raise` with proper context, not bare `raise`
- Log errors before raising when appropriate

**Docstrings:**
- Use triple quotes for docstrings
- Follow Google-style docstring format
- Include parameter types in docstrings
- Brief one-line summary for simple functions

**Testing:**
- Use pytest for all tests
- Test files: `test_*.py` in `tests/` directory
- Use descriptive test names: `test_function_behavior_expected_result`
- Use fixtures for common setup
- Test both success and failure cases
- Use `pytest.raises` for exception testing

### Configuration Files

**YAML Configuration:**
- Use 2 spaces for indentation
- Use quotes for string values that contain special characters
- Boolean values: `true`/`false`
- List items with dash prefix
- Maintain consistent key ordering

## Project Structure

```
dotbot/
├── src/dotbot/           # Main source code
│   ├── plugins/          # Plugin implementations
│   ├── util/             # Utility functions
│   └── messenger/        # Logging/output handling
├── tests/                # Test files
├── lib/pyyaml/          # Bundled PyYAML
└── pyproject.toml       # Project configuration
```

## Development Workflow

1. Make changes in `src/dotbot/`
2. Add/update tests in `tests/`
3. Run linting: `ruff check src tests`
4. Run type checking: `hatch run types:check`
5. Run tests: `hatch test`
6. Build project: `hatch build`

## Plugin Development

When creating new plugins:

1. Inherit from `dotbot.plugin.Plugin`
2. Implement `can_handle()` and `handle()` methods
3. Set `supports_dry_run = True` if applicable
4. Add comprehensive tests
5. Follow naming pattern: `{PluginName}.py`

## Testing Guidelines

- Run tests before committing
- Test edge cases and error conditions
- Use parametrized tests for multiple scenarios
- Mock external dependencies
- Test both Python 3.7+ and PyPy if applicable

## Code Quality

This project enforces high code quality standards:
- 100% type coverage (strict mypy)
- Ruff linting with specific ignore rules
- Comprehensive test coverage
- No TODO/FIXME comments in production code
- Clear, maintainable code structure