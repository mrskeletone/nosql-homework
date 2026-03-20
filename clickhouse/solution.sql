-- Решение заданий по ClickHouse

-- 1. Создание таблицы
-- TODO: скопируйте и доработайте CREATE TABLE из schema.sql
CREATE TABLE IF NOT EXISTS server_logs
(
    user_id          UInt32,
    endpoint         String,
    timestamp        DATETIME,
    response_time_ms UInt32,
    status_code      UInt32
) ENGINE = MergeTree()
      ORDER BY (timestamp, endpoint);
-- TODO: выберите подходящий порядок сортировки

-- 2. Загрузка данных из CSV
-- Подсказка: можно использовать clickhouse-client с параметром --query
-- Пример команды (выполняется в терминале):
-- cat server_logs.csv | clickhouse-client --query="INSERT INTO server_logs FORMAT CSVWithNames"


-- 3. Запрос: Топ-5 самых медленных endpoint'ов (по среднему времени ответа)
-- TODO: напишите SELECT запрос
SELECT endpoint, round(avg(response_time_ms), 2)
from server_logs
group by endpoint
order by avg(response_time_ms) desc
limit 5;

-- 4. Запрос: Количество запросов по часам за весь период в логах
-- TODO: напишите SELECT запрос с использованием функции toHour() или formatDateTime()
select count(*), toHour(timestamp)
from server_logs
group by toHour(timestamp);
-- 5. Запрос: Процент ошибок (status_code >= 400) для каждого endpoint'а
-- TODO: напишите SELECT запрос с вычислением процента ошибок
select endpoint,
       round(countIf(status_code >= 400) * 100 / count(*), 2) as error_percent
from server_logs
group by endpoint;
