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
        or (S_HideWithGame && !UI::IsGameUIVisible())
        or (S_HideWithOP && !UI::IsOverlayShown())
#if TMNEXT || MP4
        or GetApp().RootMap is null
#elif TURBO
        or GetApp().Challenge is null
#endif
    ) {
        return;
    }

    if (UI::Begin("ExitMap", UI::WindowFlags::NoTitleBar | UI::WindowFlags::AlwaysAutoResize)) {
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
#if TMNEXT || MP4
        or GetApp().RootMap is null
#elif TURBO
        or GetApp().Challenge is null
#endif
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
        App.Network.PlaygroundInterfaceScriptHandler.CloseInGameMenu(CGameScriptHandlerPlaygroundInterface::EInGameMenuResult::Quit);
    }
#endif

    App.BackToMainMenu();
}
