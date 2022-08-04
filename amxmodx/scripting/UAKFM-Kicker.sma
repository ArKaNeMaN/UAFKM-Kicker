#include <amxmodx>
#include <universal_afk_manager>
#include <reapi>

#pragma semicolon 1
#pragma compress 1

// uLang(const UserId, const sLangKey[]);
stock const __ULANG_TEMPLATE_STR[] = "%L";
#define uLang(%1) \
    fmt(__ULANG_TEMPLATE_STR, %1)
    
// sLang(const sLangKey[]);
stock const __SLANG_TEMPLATE_STR[] = "%l";
#define sLang(%1) \
    fmt(__SLANG_TEMPLATE_STR, %1)

new const KICK_REASON_LANG_KEY[] = "UAFKM_KICKER_REASON";

public stock const PluginName[] = "UAFKM: Kicker";
public stock const PluginVersion[] = "1.0.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "https://github.com/ArKaNeMaN/UAKFM-Kicker";
public stock const PluginDescription[] = "AFK kicker for Universal AFK Manager";

new Float:fKickDelay;

public plugin_init() {
    if (uafkm_get_amxx_version() < 1100) {
        register_plugin(PluginName, PluginVersion, PluginAuthor);
    }

    register_dictionary("UAFKM-Kicker.ini");

    bind_pcvar_float(
        create_cvar(
            .name = "UAFKM_Kicker_Delay", 
            .string = "10.0",
            .description = sLang("UAFKM_KICKER_CVAR_DELAY"),
            .has_min = true,
            .min_val = 0.0
        ), fKickDelay
    );

    AutoExecConfig(true, "Kicker", "Universal-AFK-Manager");
}

public player_start_afk_post(const UserId) {
    if (fKickDelay > 0.01) {
        set_task(fKickDelay, "@Task_Kick", UserId);
    } else {
        @Task_Kick(UserId);
    }
}

@Task_Kick(const UserId) {
    rh_drop_client(UserId, uLang(UserId, KICK_REASON_LANG_KEY));
}

public player_end_afk_post(const UserId) {
    remove_task(UserId);
}
