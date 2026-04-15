# Claude Code in Docker

A portable Claude Code environment in Docker for Windows. Authenticate once on your host, then launch isolated containers per project with your credentials mounted in.

## What's in the box

| File | Purpose |
|------|---------|
| `Dockerfile` | Builds the image: Node 20 + Python 3 + git + Claude Code CLI |
| `cc.bat` | Starts a container for the current project directory (or reuses an existing one) |
| `ccstop.bat` | Stops and removes the container for the current project directory |
| `auth.bat` | One-time setup: installs Node.js if missing, then runs OAuth login |
| `.dockerignore` | Excludes `.bat` files from the Docker build context |

## Prerequisites

- [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) installed and running
- [Node.js](https://nodejs.org/) installed (for initial auth only -- `auth.bat` can install it for you)
- An Anthropic subscription (Pro, Max, Teams, or Enterprise)

## Setup (one-time)

### 1. Get the files

**Option A -- Clone with git:**

```
cd C:\claude-tools
git clone https://github.com/gimenopea/claude-code-docker.git
cd claude-code-docker
```

**Option B -- Download as ZIP:**

1. Go to the repo page on GitHub
2. Click the green **Code** button, then **Download ZIP**
3. Extract to `C:\claude-tools\claude-code-docker`

### 2. Authenticate

```
auth.bat
```

Or manually:

```
npx @anthropic-ai/claude-code
```

Complete the OAuth login in your browser. Credentials are saved to `%USERPROFILE%\.claude\`.

### 3. Build the image

```
docker build -t claude-code .
```

### 4. Add to PATH (optional but recommended)

Adding the repo folder to your system PATH lets you run `cc` and `ccstop` from any directory without typing the full path.

**Via GUI:**

1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Go to **Advanced** tab, click **Environment Variables**
3. Under **User variables**, select **Path**, click **Edit**
4. Click **New**, paste the full path to this repo (e.g. `C:\claude-tools\claude-code-docker`)
5. Click **OK** on all dialogs
6. **Restart any open terminals** -- existing windows won't pick up the change

**Via command line (run as Administrator):**

```
setx PATH "%PATH%;C:\claude-tools\claude-code-docker"
```

> **Note:** `setx` permanently writes to the registry but does NOT update the current terminal session. Open a new terminal after running it.

**Verify it worked** (in a new terminal):

```
where cc
```

Should print something like `C:\claude-tools\claude-code-docker\cc.bat`.

## Usage

### Start a session

From any project directory:

```
cc
```

(Or use the full path `C:\claude-tools\claude-code-docker\cc.bat` if you skipped the PATH step.)

This spins up a container named `claude-<folder>` (or reuses an existing one) and drops you into a bash shell. Then run:

```
claude
```

### Stop a session

From the same project directory:

```
ccstop
```

Your project files and credentials are unaffected -- they live on the host via volume mounts.

## How it works

```
HOST (Windows)                         CONTAINER (Linux)
─────────────────                      ──────────────────
%USERPROFILE%\.claude\       ──mount──>  /home/node/.claude/
%USERPROFILE%\.claude.json   ──mount──>  /home/node/.claude.json
C:\your\project\             ──mount──>  /workspace/
```

The container reads your host credentials via bind mounts. No tokens are baked into the image.

## Quick reference

| Command | When |
|---------|------|
| `auth.bat` | First time (installs Node + authenticates) |
| `docker build -t claude-code .` | First time / after Dockerfile changes |
| `cc.bat` | Start working |
| `ccstop.bat` | Done working |
| `claude` | Inside the container |

## Example walkthrough

Say you need to use Claude Code on a ticket branch `T2331_LEE`, which is a copy of the codebase on the `H:` drive.

**1. Open a terminal and navigate to the project:**

```
H:
cd H:\T2331_LEE
```

**2. Start the container:**

```
cc
```

This creates a container named `claude-T2331_LEE` with your project mounted at `/workspace`. You're dropped into a bash shell inside the container:

```
/workspace $
```

**3. Launch Claude Code:**

```
claude
```

Claude Code can now see and modify everything in `H:\T2331_LEE`. Any changes it makes inside `/workspace` are written directly to your `H:` drive -- no copying needed.

**4. When you're done, exit Claude Code and the container:**

```
exit   # exits Claude Code
exit   # exits the container bash shell
```

**5. Stop and clean up the container:**

```
ccstop
```

Your files on `H:\T2331_LEE` are untouched. Next time you run `cc` from that folder, a fresh container is created with the same mounts.

> **Tip:** You can have multiple containers running at once. If you open a second terminal and run `cc` from a different project folder (e.g. `H:\T2400_SMITH`), it gets its own container named `claude-T2400_SMITH` -- completely isolated from the first.

## License

MIT
