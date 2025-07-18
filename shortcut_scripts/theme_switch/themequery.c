// win_theme.c
#include <windows.h>
#include <stdio.h>

int main() {
    HKEY hKey;
    DWORD val, size = sizeof(DWORD);
    if (RegOpenKeyExA(HKEY_CURRENT_USER,
        "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
        0, KEY_READ, &hKey) == ERROR_SUCCESS) {

        if (RegQueryValueExA(hKey, "AppsUseLightTheme", NULL, NULL,
            (LPBYTE)&val, &size) == ERROR_SUCCESS) {

            printf(val ? "light\n" : "dark\n");
        } else {
            puts("unknown");
        }
        RegCloseKey(hKey);
    } else {
        puts("unknown");
    }
    return 0;
}

