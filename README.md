# dyad-mobile

## Setup (Windows)

1. Have a working device/emulator on host.
2. Make sure WSL, Docker Desktop and VS Code is installed.
3. Launch VS Code.
4. Install WSL Remote Containers.
5. Run Command: 'Remote-Containers: Open Folder in Containers...'. (May take a while to download SDK's).
6. On host set device port to 5555 `adb tcpip 5555`. (Emulator)
7. On container terminal connect to host `adb connect host.docker.internal:5555` (Emulator) or `adb connect ip:port` (Debugging Device).
8. Navigate to Flutter project directory and run `flutter run`.
