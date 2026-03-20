local input

if IS_DESKTOP then
    -- is desktop (used for testing)
    input = (require "lib.baton").new {
        controls = {
            -- UI
            uiLeft =        { "axis:leftx-", "button:dpleft",  "key:left"  },
            uiRight =       { "axis:leftx+", "button:dpright", "key:right" },
            uiUp =          { "axis:lefty-", "button:dpup",    "key:up"    },
            uiDown =        { "axis:lefty+", "button:dpdown",  "key:down"  },
            uiConfirm =     { "button:a",    "key:return"    },
            uiBack =        { "button:b",    "key:escape"    },
            uiErectButton = { "button:back", "key:tab"       },
            
            -- Gameplay
            gameLeft =  { "axis:leftx-", "button:dpleft",  "axis:rightx-", "button:x", "axis:triggerleft+",    "key:left",  "key:a"   },
            gameDown =  { "axis:lefty+", "button:dpdown",  "axis:righty+", "button:y", "button:leftshoulder",  "key:down",  "key:s"   },
            gameUp =    { "axis:lefty-", "button:dpup",    "axis:righty-", "button:a", "button:rightshoulder", "key:up",    "key:w"   },
            gameRight = { "axis:leftx+", "button:dpright", "axis:rightx+", "button:b", "axis:triggerright+",   "key:right", "key:d"   },
        },
        joystick = love.joystick.getJoysticks()[1],
    }
else
    -- is 3DS
    input = (require "lib.baton").new {
        controls = {
            -- UI
            uiLeft =        { "axis:leftx-", "button:dpleft"  },
            uiRight =       { "axis:leftx+", "button:dpright" },
            uiUp =          { "axis:lefty-", "button:dpup"    },
            uiDown =        { "axis:lefty+", "button:dpdown"  },
            uiConfirm =     { "button:a"    },
            uiBack =        { "button:b"    },
            uiErectButton = { "button:back" },
            
            -- Gameplay
            gameLeft =  { "button:leftshoulder",  "axis:leftx-",  "axis:rightx-",       "button:dpleft",  "button:y"   },
            gameDown =  { "axis:lefty+",          "axis:righty+", "axis:triggerleft+",  "button:dpdown",  "button:b"   },
            gameUp =    { "axis:lefty-",          "axis:righty-", "axis:triggerright+", "button:dpup",    "button:x"   },
            gameRight = { "button:rightshoulder", "axis:leftx+",  "axis:rightx+",       "button:dpright", "button:a"   },
        },
        joystick = love.joystick.getJoysticks()[1],
    }
end

return input