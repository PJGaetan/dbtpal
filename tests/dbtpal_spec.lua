describe("dbtpal", function()
    it("can be required", function() require("dbtpal") end)

    it("can run dbt", function()
        local dbt = require("dbtpal")
        local result = dbt.run()
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "run")
    end)

    it("can run standard dbt commands", function()
        local dbt = require("dbtpal")
        local commands = { "run", "test", "compile", "build", "debug" }
        for _, cmd in ipairs(commands) do
            local result = dbt.run_command(cmd)
            assert.are.equal(result.command, "dbt")
            assert.are.equal(result.args[3], cmd)
        end
    end)

    it("can run arbitrary commands with string args", function()
        local dbt = require("dbtpal")

        local result = dbt.run_command("compile", "--models my_model")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "compile")
        assert.are.equal(result.args[4], "--models")
        assert.are.equal(result.args[5], "my_model")
    end)

    it("can run arbitrary commands with table args", function()
        local dbt = require("dbtpal")
        local result = dbt.run_command("compile", { "--models", "my_model" })
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "compile")
        assert.are.equal(result.args[4], "--models")
        assert.are.equal(result.args[5], "my_model")
    end)

    it("can run dbt with a model selector", function()
        local dbt = require("dbtpal")
        local result = dbt.run("my_model")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "run")
        assert.are.equal(result.args[4], "--select")
        assert.are.equal(result.args[5], "my_model")
    end)

    it("can run dbt with multiple model selectors", function()
        local dbt = require("dbtpal")
        local result = dbt.run("tag:nightly my_model finance.base.*")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "run")
        assert.are.equal(result.args[4], "--select")
        assert.are.equal(result.args[5], "tag:nightly my_model finance.base.*")
    end)

    it("can run dbt with multiple model selectors in a table", function()
        local dbt = require("dbtpal")
        local result = dbt.run({"tag:nightly", "my_model", "finance.base.*"})
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "run")
        assert.are.equal(result.args[4], "--select")
        assert.are.equal(result.args[5], "tag:nightly my_model finance.base.*")
    end)

    it("can run dbt with multiple model selectors and args", function()
        local dbt = require("dbtpal")
        local result = dbt.run(
        {"tag:nightly", "my_model", "finance.base.*"},
        {"--full-refresh", "--threads 4"}
        )
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "run")
        assert.are.equal(result.args[4], "--select")
        assert.are.equal(result.args[5], "tag:nightly my_model finance.base.*")
        assert.are.equal(result.args[6], "--full-refresh")
        assert.are.equal(result.args[7], "--threads 4")
    end)

end)
