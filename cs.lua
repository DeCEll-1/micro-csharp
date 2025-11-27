
local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")

config.RegisterCommonOption("csharpfmt", "csfmt", true)

function init()
    config.MakeCommand("csfmt", csfmt, config.NoComplete)
end

function onSave(bp)
    if bp.Buf:FileType() == "csharp" then
        csfmt(bp)
    end
    return true
end

function csfmt(bp)
    bp:Save()
    local _, err = shell.RunCommand("dotnet-csharpier --loglevel None " .. bp.Buf.Path)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end
    bp.Buf:ReOpen()

end
