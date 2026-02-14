enum ExitStyle {
    Button,
    Menu
}

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Style"]
ExitStyle S_Style = ExitStyle::Button;

[Setting category="General" name="Show/hide with game UI" if="S_Style Button"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI" if="S_Style Button"]
bool S_HideWithOP = false;

void Render() {
    if (false
        or !S_Enabled
        or S_Style == ExitStyle::Menu
        or GetMap() is null
        or (true
            and S_HideWithGame
            and !UI::IsGameUIVisible()
        )
        or (true
            and S_HideWithOP
            and !UI::IsOverlayShown()
        )
    ) {
        return;
    }

    const int flags = UI::GetDefaultWindowFlags()
        | UI::WindowFlags::NoTitleBar
        | UI::WindowFlags::AlwaysAutoResize
    ;

    if (UI::Begin("ExitMap", flags)) {
        if (UI::Button(Icons::Times + " Exit Map")) {
            Exit();
        }
    }

    UI::End();
}

void RenderMenu() {
    if (UI::MenuItem(Icons::Times + " Exit Map", "", S_Enabled)) {
        S_Enabled = !S_Enabled;
    }
}

void RenderMenuMain() {
    if (false
        or !S_Enabled
        or S_Style == ExitStyle::Button
        or GetMap() is null
    ) {
        return;
    }

    if (UI::BeginMenu(Icons::Times + " Exit Map")) {
        if (UI::MenuItem("Exit")) {
            Exit();
        }
        UI::EndMenu();
    }
}

void Exit() {
    auto App = cast<CTrackMania>(GetApp());

#if TMNEXT || MP4
    if (App.Network.PlaygroundClientScriptAPI.IsInGameMenuDisplayed) {
        App.Network.PlaygroundInterfaceScriptHandler.CloseInGameMenu(
            CGameScriptHandlerPlaygroundInterface::EInGameMenuResult::Quit
        );
    }
#endif

#if TMNEXT || MP4 || TURBO
    App.BackToMainMenu();
#elif FOREVER
    ;  // TODO
#endif
}

CGameCtnChallenge@ GetMap() {
#if TMNEXT || MP4
    return GetApp().RootMap;
#elif TURBO || FOREVER
    return GetApp().Challenge
#endif
}
