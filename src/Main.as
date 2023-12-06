/*
c 2023-11-22
m 2023-11-22
*/

enum ExitStyle {
    Button,
    Menu
}

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Style"]
ExitStyle S_Style = ExitStyle::Button;

[Setting category="General" name="Show/hide with game UI" description="only applies to button"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI" description="only applies to button"]
bool S_HideWithOP = false;

bool renderButton = false;
bool renderMenu = false;

void Main() {
    while (true) {
        renderButton = S_Style == ExitStyle::Button;
        renderMenu = S_Style == ExitStyle::Menu;
        yield();
    }
}

void RenderMenu() {
    if (UI::MenuItem(Icons::Times + " Exit Map", "", S_Enabled))
        S_Enabled = !S_Enabled;
}

void Render() {
    if (
        !S_Enabled ||
        renderMenu ||
        (S_HideWithGame && !UI::IsGameUIVisible()) ||
        (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    CTrackMania@ app = cast<CTrackMania@>(GetApp());

    CGameCtnChallenge@ map = cast<CGameCtnChallenge@>(app.RootMap);
    if (map is null)
        return;

    int flags = UI::WindowFlags::NoTitleBar |
                UI::WindowFlags::AlwaysAutoResize;

    UI::Begin("ExitMap", flags);
        if (UI::Button(Icons::Times + " Exit Map"))
            app.BackToMainMenu();
    UI::End();
}

void RenderMenuMain() {
    if (
        !S_Enabled ||
        renderButton
    )
        return;

    CTrackMania@ app = cast<CTrackMania@>(GetApp());

    CGameCtnChallenge@ map = cast<CGameCtnChallenge@>(app.RootMap);
    if (map is null)
        return;

    if (UI::BeginMenu(Icons::Times + " Exit Map")) {
        if (UI::MenuItem("Exit"))
            app.BackToMainMenu();
        UI::EndMenu();
    }
}