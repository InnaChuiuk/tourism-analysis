select *
from dbo.cleaned_data_Ukraine


-- Порівняння загальних середніх показників за періодами
select
period,
avg(bukovel) as avg_bukovel,
avg(yaremche) as avg_yaremche
from dbo.cleaned_data_Ukraine
group by period

-- Аналіз сезонності за місяцями
-- Групування даних за номером місяця та періодом для виявлення пікових сезонів
select
period,
month(date) as month_num,
avg(bukovel) as avg_bukovel,
avg(yaremche) as avg_yaremche
from dbo.cleaned_data_Ukraine
group by period, month(date)
order by month_num, period

-- Розрахунок середньої частки ринку Яремче за місяцями
-- Як змінювався попит Яремче порівняно з Буковелем
select
month(date) as month_num,
period,
(avg(cast(yaremche as float)) / nullif((avg(cast(bukovel as float)) + avg(cast(yaremche as float))), 0)) * 100 as yaremche_share
from dbo.cleaned_data_Ukraine
group by period, month(date)
order by period, month_num

-- Фінальний запит для Power BI
-- Для того щоб візуалізувати динаміку по тижнях, але при цьому зберігти розраховану частку ринку (yaremche_share) для кожного рядка
select
date,
period,
bukovel,
yaremche,
(cast(yaremche as float) / 
nullif((cast(bukovel as float) + cast(yaremche as float)), 0)) * 100 as yaremche_share,
month(date) as month_num
from dbo.cleaned_data_Ukraine
order by date
