local api = vim.api
local opt = vim.opt
local fn = vim.fn

local mod = {}

--Set Serial number at the start of lines(for $KRRSettings)
function mod.SetNumbersSerial()

    --Refresh screen only when needed
    opt.lazyredraw = true

    --Move to the top
    api.nvim_win_set_cursor(0,{1,0})

    --Get the first row of the list
    --(set 'W' flag not to wrap at the file end when the pattern is not found)
    local firstrow = fn.search([[^\d\+=]],'W')

    --Get the last row of the list
    --(just above the firstrow not start with \d+=)
    local lastrow = fn.search([[^\(\d\+=\)\@!]],'W') - 1

    --Number for substitute
    local newNumber=1

    -- Loop from the top row of the list to the last
    for r = firstrow , lastrow do

        -- Replace numbers for each rows
        local newLine =string.gsub(fn.getline(r),"^%d+",newNumber)
        fn.setline(r,newLine)

        newNumber = newNumber + 1

    end

    --Release hightlights
    opt.hlsearch = false

end

--Execute KRR ChoshoCtl.exe
function mod.ChoshoCtl()
    os.execute([[C:\KRR\ChoshoCtl\ChoshoCtl.exe]])
end

--Execute Nodo ChoshoCtl
function mod.NodoChoshoCtl()
    os.execute([[C:\農道台帳システム\帳票作成\ChoshoCtl.exe]])
end

--Count Buffers
function mod.CountBuffers()

    local i = fn.bufnr('$')
    local j = 0

    while i >= 1 do

        if fn.buflisted(i)==1 then
            j = j + 1
        end

        i = i - 1

    end

    return j

end

return mod
