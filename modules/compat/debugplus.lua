local success, dpAPI = pcall(require, "debugplus-api")

if success and dpAPI.isVersionCompatible(1) then
    AKYRS.DBGPLUS = dpAPI.registerID("aksh")
    AKYRS.DBGPLUS.addCommand{
        name = 'spawnv',
        shortDesc = "Spawn card in voucher slot",
        desc = "Spawn card in voucher slot. Supply the key as the argument.",
        exec = function (args, rawArgs, dp)
            local key = ""
            if #rawArgs == 0 then
                key = dp.hovered.config.center.key
            else
                key = rawArgs
            end
            local v = SMODS.add_voucher_to_shop(key)
            return "spawned " .. rawArgs
        end
    }
    AKYRS.DBGPLUS.addCommand{
        name = 'shop',
        shortDesc = "Set enablement of shops",
        desc = "Set enablement of shops. shop enable <key>, shop disable <key>, shop refreshsign",
        exec = function (args, rawArgs, dp)
            local sub, key = unpack(args)
            if sub == 'enable' then
                AKYRS.toggle_shop_availability(key, true)
                return "Enabled Shop " .. key
            end
            if sub == 'disable' then
                AKYRS.toggle_shop_availability(key, false)
                return "Disabled Shop " .. key
            end
            if sub == 'refreshsign' then
                AKYRS.refresh_shop_sign()
                return 'Refresh Shop Sign'
            end
            return "shop enable <key>, shop disable <key>, shop refreshsign"
        end
    }
    AKYRS.DBGPLUS.addCommand{
        name = 'enchant',
        shortDesc = "Hover on card, add remove as you wish",
        desc = "Hover on a card and run this command to enchant or remove enchantment from it",
        exec = function (args, rawArgs, dp)
            local sub, key, level = unpack(args)
            local forced = string.find(rawArgs, '-f')
            level = tonumber(level) or 1
            if sub == 'add' then
                AKYRS.apply_enchantment(dp.hovered, key, level, not not forced)
                return "Enchanted card with " .. key .. " level " .. level
            end
            if sub == 'remove' then
                AKYRS.remove_enchantment(dp.hovered, key, not not forced)
                return "Remove " .. key .. ' from card'
            end
            if sub == 'clear' then
                AKYRS.clear_enchantments(dp.hovered, not not forced)
                return 'Clear enchantments from card'
            end
            if sub == 'wipe' then
                dp.hovered.akyrs_enchantments = nil
                return "Wiped all enchantments from card"
            end
            return "enchant add <key> [level], enchant remove <key> [level], you may add -f at the end to force it"
        end
    }
    AKYRS.DBGPLUS.addCommand{
        name = 'currency',
        shortDesc = "Set or add currency",
        desc = "Set or add to your currency. Usage:\ncurrency <currency_key> set [amount] - Set your currency to the given amount\ncurrency <currency_key> add [amount] - Adds the given amount to your currency.",
        exec = function(args, rawArgs, dp)
            if G.STAGE ~= G.STAGES.RUN then
                return "This command must be run during a run.", "ERROR"
            end
            local currency = args[1]
            local currency_obj = AKYRS.Currencies[currency]
            local subCmd = args[2]
            local amount = tonumber(args[3])
            if subCmd == "set" then
                if not amount then
                    return "Please provide a valid number to set/add.", "ERROR"
                end
                currency_obj:set_value(amount)
            elseif subCmd == "add" then
                if not amount then
                    return "Please provide a valid number to set/add.", "ERROR"
                end
                currency_obj:change_value(amount)
            else
                return "Please choose whether you want to add or set. For more info, run 'help currency'"
            end
            return "You now have " .. currency_obj:get_value() .. ' of ' .. currency
        end
    }
end