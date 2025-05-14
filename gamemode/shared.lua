GM.Name = "Gaks Game"
GM.Author = "Gak"
GM.Email = "NA"
GM.Website = "NA"

DeriveGamemode("sandbox")

function Log(...)
    local msg = {...}

    for k, v in ipairs(msg) do
        msg[k] = tostring(v)
    end

    local msg = table.concat(msg, " ")
    print(msg)
end