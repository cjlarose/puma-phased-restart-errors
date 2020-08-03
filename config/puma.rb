port 3000
workers 1

lowlevel_error_handler do |err|
  STDERR.puts err.message
  STDERR.puts err.backtrace
  [500, {}, [err.message] + err.backtrace]
end
