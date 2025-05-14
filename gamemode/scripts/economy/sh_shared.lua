gEconomy = gEconomy or {}
gEconomy.Database = "gEconomy"
gEconomy.StartingMoney = 5000
gEconomy.Transactions = "gEconomy_Transactions"

hook.Add("GakGame_InitializeSQL", "GakGame_TransactionsDatabase", function()
    if not sql.TableExists(gEconomy.Transactions) then
        local str = string.format("CREATE TABLE %s (transactionID AUTO INCREMENT PRIMARY KEY, logText TEXT)",
        gEconomy.Transactions
        )

        sql.Begin()
            sql.Query(str)
        sql.Commit()
    end

    if not sql.TableExists(gEconomy.Database) then
        local str = string.format("CREATE TABLE %s (id PRIMARY KEY, balance INT)",
        gEconomy.Database
        )

        sql.Begin()
            sql.Query(str)
        sql.Commit()
    end
end)

function gEconomy.LogTransaction(...)
    local Log = util.TableToJSON({...})
    local logSQL = sql.SQLStr(Log)

    local str = string.format("INSERT INTO %s (logText) VALUES ('%s')",
    logSQL
    )

    sql.Query(str)
end