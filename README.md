# development-bootstrap-macos

Executable notes for preparing a macOS machine for development.

The repository is intentionally conservative:

- `diagnose.sh` changes nothing.
- Each failed check points to one small script.
- Setup scripts avoid overwriting existing configuration.
- Read a script before running it; the script is also the documentation.

## First run

```bash
chmod +x diagnose.sh base/*.sh shell/*.sh ssh/*.sh optional/rancher-desktop/*.sh
./diagnose.sh
```

Then open and run only the scripts referenced by failed checks.

## Coverage

- macOS and CPU architecture
- Xcode Command Line Tools
- Homebrew
- Git and GitHub CLI
- Python, uv, Neovim, Visual Studio Code
- zsh and Homebrew shell initialization
- SSH key, agent configuration, GitHub key registration, authentication test
- Optional Rancher Desktop, Kubernetes CLI tools, and local-cluster verification

## Deliberate boundary

Git identity, Git defaults, repository initialization, and routine Git/GitHub repository operations live in `development-bootstrap-git`.
