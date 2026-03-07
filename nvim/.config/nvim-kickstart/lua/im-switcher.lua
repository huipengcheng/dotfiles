local im_group = vim.api.nvim_create_augroup("IMSelect", { clear = true })

-- macOS FFI Implementation
if vim.fn.has('mac') == 1 then
    local ffi = require('ffi')
    local carbon_path = "/System/Library/Frameworks/Carbon.framework/Carbon"
    local ok, carbon = pcall(ffi.load, carbon_path)

    if ok then
        ffi.cdef[[
            typedef struct CFString *CFStringRef;
            typedef struct TISInputSource *TISInputSourceRef;
            CFStringRef TISCopyCurrentKeyboardInputSource(void);
            TISInputSourceRef TISCopyInputSourceForLanguage(CFStringRef language);
            int TISSelectInputSource(TISInputSourceRef inputSource);
            CFStringRef CFStringCreateWithCString(void *, const char *, int);
        ]]

        local function set_ascii_im()
            local im_id = "com.apple.keylayout.ABC" 
            local ascii = carbon.CFStringCreateWithCString(nil, im_id, 0)
            local source = carbon.TISCopyInputSourceForLanguage(ascii)
            if source ~= nil then
                carbon.TISSelectInputSource(source)
            end
        end

        vim.api.nvim_create_autocmd("InsertLeave", { group = im_group, callback = set_ascii_im })
        vim.api.nvim_create_autocmd("FocusGained", {
            group = im_group,
            callback = function()
                if vim.api.nvim_get_mode().mode ~= 'i' then set_ascii_im() end
            end,
        })
    end

-- Linux Implementation
elseif vim.fn.has('linux') == 1 then
    local function get_im_cmd()
        if vim.fn.executable("fcitx5-remote") == 1 then return {"fcitx5-remote", "-c"}
        elseif vim.fn.executable("fcitx-remote") == 1 then return {"fcitx-remote", "-c"}
        elseif vim.fn.executable("ibus") == 1 then return {"ibus", "engine", "xkb:us::eng"}
        end
    end

    local cmd = get_im_cmd()
    if cmd then
        local function set_linux_ascii() vim.fn.jobstart(cmd) end
        vim.api.nvim_create_autocmd("InsertLeave", { group = im_group, callback = set_linux_ascii })
        vim.api.nvim_create_autocmd("FocusGained", {
            group = im_group,
            callback = function()
                if vim.api.nvim_get_mode().mode ~= 'i' then set_linux_ascii() end
            end,
        })
    end
end

