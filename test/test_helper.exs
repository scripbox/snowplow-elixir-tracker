ExUnit.start()
{:ok, files} = File.ls("./test/support")

Enum.each(files, fn file ->
  Code.require_file("support/#{file}", __DIR__)
end)

PersistentEts.new(:events, "events.tab", [:named_table])
