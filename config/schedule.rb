set :environment, "production"
set :output, "log/cron.log"

every :day, at: ["12:00 AM"] do
    echo "--------- Starting ---------"
    runner "Todo.reset_unfinished"
    echo "--------- Ending ---------"
end
