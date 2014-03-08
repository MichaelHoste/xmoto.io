threads 0, 5
workers 2
preload_app!

bind 'unix:///tmp/puma.xmoto_io.sock'

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
